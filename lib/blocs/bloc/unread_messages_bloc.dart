import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../service/unread_messages_service.dart';
import '../../utils/share_preferences_user_data.dart';
import '../event/unread_messages_event.dart';
import '../state/unread_messages_state.dart';

class UnreadMessagesBloc extends Bloc<UnreadMessagesEvent, UnreadMessagesState> {
  final UnreadMessagesService service;
  StreamSubscription<int>? _sub;

  UnreadMessagesBloc({required this.service}) : super(UnreadInitial()) {
    on<ListenUnreadMessages>(_onListenUnreadMessages);
    on<UnreadCountChanged>(_onUnreadCountChanged);
  }

  Future<void> _onListenUnreadMessages(
      ListenUnreadMessages event,
      Emitter<UnreadMessagesState> emit,
      ) async {
    _sub?.cancel();

    final friendUid = await SPUserData.getFriendUid();
    final friendName = await SPUserData.getFriendName();
    final friendCode = await SPUserData.getFriendCode();

    if (kDebugMode) {
      print("👥 SPUserData -> friendUid=$friendUid, friendName=$friendName, friendCode=$friendCode");
    }

    if (friendUid != null && friendUid.isNotEmpty) {
      _sub = service.getUnreadCount(friendUid).listen((count) {
        add(UnreadCountChanged(count,friendUid,friendName,friendCode));
      });
    } else {
      emit(UnreadInitial());
      if (kDebugMode) {
        print("⚠️ Не знайдено жодного friendUid у SPUserData");
      }
    }
  }

  void _onUnreadCountChanged(
      UnreadCountChanged event,
      Emitter<UnreadMessagesState> emit,
      ) {
    emit(UnreadCountUpdated(event.count,event.friendUid,event.friendName,event.friendCode));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
