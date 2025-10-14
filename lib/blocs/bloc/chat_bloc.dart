import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../event/chat_event.dart';
import '../state/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final String chatId;
  final String friendUid;

  StreamSubscription? _messagesSub;
  StreamSubscription? _friendStatusSub;
  StreamSubscription? _friendReadSub;

  ChatBloc({
    required this.firestore,
    required this.auth,
    required this.chatId,
    required this.friendUid,
  }) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<ListenFriendStatus>(_onListenFriendStatus);
    on<ListenFriendReadStatus>(_onListenFriendReadStatus);
  }

  /// 📨 Отримання повідомлень
  Future<void> _onLoadMessages(
      LoadMessages event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());
    await _messagesSub?.cancel();

    _messagesSub = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        final messages = snapshot.docs.map((d) => Message.fromFirestore(d)).toList();

        add(MarkAsRead());

        final current = state;
        emit(ChatLoaded(
          messages: messages,
          isFriendOnline: current is ChatLoaded ? current.isFriendOnline : false,
          friendLastSeen: current is ChatLoaded ? current.friendLastSeen : null,
          friendLastRead: current is ChatLoaded ? current.friendLastRead : null,
        ));
      },
      onError: (error) {
        print("❌ Firestore stream error: $error");
        emit(ChatError("Помилка завантаження повідомлень"));
      },
    );
  }

  /// 💬 Відправлення повідомлення
  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<ChatState> emit,
      ) async {
    final uid = auth.currentUser!.uid;
    try {
      await firestore.collection('chats').doc(chatId).collection('messages').add({
        'senderId': uid,
        'text': event.text,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print("❌ Помилка при відправці повідомлення: $e");
    }
  }

  /// ✅ Відмітка як прочитано
  Future<void> _onMarkAsRead(
      MarkAsRead event,
      Emitter<ChatState> emit,
      ) async {
    final uid = auth.currentUser!.uid;
    try {
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('participants')
          .doc(uid)
          .set({
        'lastRead': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("⚠️ Помилка при оновленні lastRead: $e");
    }
  }

  /// 👤 Слухач статусу друга (онлайн / останній візит)
  Future<void> _onListenFriendStatus(
      ListenFriendStatus event,
      Emitter<ChatState> emit,
      ) async {
    await _friendStatusSub?.cancel();

    _friendStatusSub = firestore
        .collection('users')
        .doc(friendUid)
        .snapshots()
        .listen(
          (snap) {
        final data = snap.data();
        final isOnline = data?['isOnline'] ?? false;
        final lastSeen = (data?['lastSeen'] as Timestamp?)?.toDate();

        final current = state;
        if (current is ChatLoaded) {
          emit(ChatLoaded(
            messages: current.messages,
            isFriendOnline: isOnline,
            friendLastSeen: lastSeen,
            friendLastRead: current.friendLastRead,
          ));
        }
      },
      onError: (e) {
        print("⚠️ Помилка статусу друга: $e");
      },
    );
  }

  /// 👁‍🗨 Слухач lastRead друга
  Future<void> _onListenFriendReadStatus(
      ListenFriendReadStatus event,
      Emitter<ChatState> emit,
      ) async {
    await _friendReadSub?.cancel();

    _friendReadSub = firestore
        .collection('chats')
        .doc(chatId)
        .collection('participants')
        .doc(friendUid)
        .snapshots()
        .listen(
          (snap) {
        final lastRead = (snap.data()?['lastRead'] as Timestamp?)?.toDate();

        final current = state;
        if (current is ChatLoaded) {
          emit(ChatLoaded(
            messages: current.messages,
            isFriendOnline: current.isFriendOnline,
            friendLastSeen: current.friendLastSeen,
            friendLastRead: lastRead,
          ));
        }
      },
      onError: (e) {
        print("⚠️ Помилка friendRead: $e");
      },
    );
  }

  @override
  Future<void> close() async {
    await _messagesSub?.cancel();
    await _friendStatusSub?.cancel();
    await _friendReadSub?.cancel();
    return super.close();
  }
}
