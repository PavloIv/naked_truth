abstract class UnreadMessagesState {}

class UnreadInitial extends UnreadMessagesState {}

class UnreadCountUpdated extends UnreadMessagesState {
  final int count;
  final String? friendUid;
  final String? friendName;
  final String? friendCode;

  UnreadCountUpdated(this.count, this.friendUid, this.friendName, this.friendCode);
}