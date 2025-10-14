import '../../models/friend_stats.dart';

class FriendState {
  final bool isOnline;
  final int unreadCount;
  final FriendStats? stats;

  const FriendState({
    this.isOnline = false,
    this.unreadCount = 0,
    this.stats,
  });

  FriendState copyWith({
    bool? isOnline,
    int? unreadCount,
    FriendStats? stats,
  }) {
    return FriendState(
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
      stats: stats ?? this.stats,
    );
  }
}
