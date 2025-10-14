import '../event/chat_event.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isFriendOnline;
  final DateTime? friendLastSeen;
  final DateTime? friendLastRead;

  ChatLoaded({
    required this.messages,
    required this.isFriendOnline,
    required this.friendLastSeen,
    required this.friendLastRead,
  });
}


class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
