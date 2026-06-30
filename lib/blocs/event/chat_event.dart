import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Message(
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] is Timestamp)
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {}

class MessagesUpdated extends ChatEvent {
  final List<Message> messages;

  MessagesUpdated(this.messages);
}

class SendMessage extends ChatEvent {
  final String text;
  SendMessage(this.text);
}

class MarkAsRead extends ChatEvent {}

class ListenFriendStatus extends ChatEvent {}

class FriendStatusUpdated extends ChatEvent {
  final bool isOnline;
  final DateTime? lastSeen;

  FriendStatusUpdated({
    required this.isOnline,
    required this.lastSeen,
  });
}

class ListenFriendReadStatus extends ChatEvent {}

class FriendReadUpdated extends ChatEvent {
  final DateTime? lastRead;

  FriendReadUpdated(this.lastRead);
}
