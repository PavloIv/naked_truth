import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../service/friend_service.dart';
import '../event/friend_event.dart';
import '../state/friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendService service;
  StreamSubscription? _onlineSub;
  StreamSubscription? _unreadSub;

  FriendBloc({required this.service}) : super(const FriendState()) {
    on<LoadFriend>(_onLoadFriend);
    on<FriendOnlineChanged>((e, emit) => emit(state.copyWith(isOnline: e.isOnline)));
    on<UnreadChanged>((e, emit) => emit(state.copyWith(unreadCount: e.count)));
    on<StatsLoaded>((e, emit) => emit(state.copyWith(stats: e.stats)));
  }

  Future<void> _onLoadFriend(LoadFriend event, Emitter<FriendState> emit) async {
    _onlineSub?.cancel();
    _unreadSub?.cancel();

    _onlineSub = service.listenOnlineStatus(event.friendUid).listen((online) {
      add(FriendOnlineChanged(online));
    });

    _unreadSub = service.listenUnreadCount(event.friendUid).listen((count) {
      add(UnreadChanged(count));
    });

    final stats = await service.loadFriendStats(event.friendUid);
    add(StatsLoaded(stats));
  }

  @override
  Future<void> close() {
    _onlineSub?.cancel();
    _unreadSub?.cancel();
    return super.close();
  }
}