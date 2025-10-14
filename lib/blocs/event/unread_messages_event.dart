abstract class UnreadMessagesEvent {}

class ListenUnreadMessages extends UnreadMessagesEvent {
  ListenUnreadMessages();
}

class UnreadCountChanged extends UnreadMessagesEvent {
  final int count;
  final String? friendUid;
  final String? friendName;
  final String? friendCode;
  UnreadCountChanged(this.count, this.friendUid, this.friendName, this.friendCode);
}
