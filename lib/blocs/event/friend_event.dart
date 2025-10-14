import '../../models/friend_stats.dart';

abstract class FriendEvent {}

class LoadFriend extends FriendEvent {
  final String friendUid;
  LoadFriend(this.friendUid);
}

class FriendOnlineChanged extends FriendEvent {
  final bool isOnline;
  FriendOnlineChanged(this.isOnline);
}

class UnreadChanged extends FriendEvent {
  final int count;
  UnreadChanged(this.count);
}

class StatsLoaded extends FriendEvent {
  final FriendStats stats;
  StatsLoaded(this.stats);
}
