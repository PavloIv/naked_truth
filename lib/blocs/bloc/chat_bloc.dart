import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
    on<MessagesUpdated>(_onMessagesUpdated);
    on<SendMessage>(_onSendMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<ListenFriendStatus>(_onListenFriendStatus);
    on<FriendStatusUpdated>(_onFriendStatusUpdated);
    on<ListenFriendReadStatus>(_onListenFriendReadStatus);
    on<FriendReadUpdated>(_onFriendReadUpdated);
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
        add(MessagesUpdated(messages));
      },
      onError: (error) {
        debugPrint("Firestore stream error: $error");
        add(MessagesUpdated(const []));
      },
    );
  }

  void _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<ChatState> emit,
  ) {
    add(MarkAsRead());

    final current = state;
    emit(ChatLoaded(
      messages: event.messages,
      isFriendOnline: current is ChatLoaded ? current.isFriendOnline : false,
      friendLastSeen: current is ChatLoaded ? current.friendLastSeen : null,
      friendLastRead: current is ChatLoaded ? current.friendLastRead : null,
    ));
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
      debugPrint("Помилка при відправці повідомлення: $e");
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
      debugPrint("Помилка при оновленні lastRead: $e");
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
        add(FriendStatusUpdated(isOnline: isOnline, lastSeen: lastSeen));
      },
      onError: (e) {
        debugPrint("Помилка статусу друга: $e");
      },
    );
  }

  void _onFriendStatusUpdated(
    FriendStatusUpdated event,
    Emitter<ChatState> emit,
  ) {
    final current = state;
    if (current is! ChatLoaded) return;

    emit(ChatLoaded(
      messages: current.messages,
      isFriendOnline: event.isOnline,
      friendLastSeen: event.lastSeen,
      friendLastRead: current.friendLastRead,
    ));
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
        add(FriendReadUpdated(lastRead));
      },
      onError: (e) {
        debugPrint("Помилка friendRead: $e");
      },
    );
  }

  void _onFriendReadUpdated(
    FriendReadUpdated event,
    Emitter<ChatState> emit,
  ) {
    final current = state;
    if (current is! ChatLoaded) return;

    emit(ChatLoaded(
      messages: current.messages,
      isFriendOnline: current.isFriendOnline,
      friendLastSeen: current.friendLastSeen,
      friendLastRead: event.lastRead,
    ));
  }

  @override
  Future<void> close() async {
    await _messagesSub?.cancel();
    await _friendStatusSub?.cancel();
    await _friendReadSub?.cancel();
    return super.close();
  }
}
