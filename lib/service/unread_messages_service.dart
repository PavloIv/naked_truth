import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnreadMessagesService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UnreadMessagesService({required this.firestore, required this.auth});

  Stream<int> getUnreadCount(String friendUid) {
    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null) {
      return const Stream<int>.empty();
    }

    final chatId = _buildChatId(currentUserId, friendUid);

    final lastReadStream = firestore
        .collection('chats')
        .doc(chatId)
        .collection('participants')
        .doc(currentUserId)
        .snapshots();

    return lastReadStream.asyncExpand((partSnap) {
      if (!partSnap.exists) return  Stream<int>.value(0);

      final lastRead = (partSnap['lastRead'] as Timestamp?)?.toDate();
      if (lastRead == null) return  Stream<int>.value(0);

      return firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages').snapshots()
          .map((msgSnap) {
        final docs = msgSnap.docs;

        final unreadFromFriend = docs.where((d) {
          final ts = (d['timestamp'] as Timestamp).toDate();
          final senderId = d['senderId'];
          return senderId != currentUserId &&
              (ts.isAfter(lastRead));
        }).length;

        return unreadFromFriend;
      });
    });
  }

  static String _buildChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
