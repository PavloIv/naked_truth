import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naked_truth/utils/share_preferences_user_data.dart';

class UserService {

  Future<bool> addFriendByCode(String myUid, String code) async {
    final firestore = FirebaseFirestore.instance;

    final friendQuery = await firestore
        .collection('users')
        .where('friendCode', isEqualTo: code)
        .limit(1)
        .get();

    if (friendQuery.docs.isEmpty) return false;

    final friendDoc = friendQuery.docs.first;
    final friendUid = friendDoc.id;

    if (friendUid == myUid) return false;

    final now = Timestamp.now();

    await firestore.collection('users').doc(myUid).update({
      'friends': {
        'friendId': friendUid,
        'since': now,
      }
    });

    await firestore.collection('users').doc(friendUid).update({
      'friends': {
        'friendId': myUid,
        'since': now,
      }
    });

    return true;
  }

  String generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> sendMessage(String fromUid, String toUid, String text) async {
    final chatId = generateChatId(fromUid, toUid);
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('chats').doc(chatId).set({
      'participants': [fromUid, toUid],
    }, SetOptions(merge: true));

    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': fromUid,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> chatMessages(String uid1, String uid2) {
    final chatId = generateChatId(uid1, uid2);
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String?> getFriendCode(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['friendCode'];
  }

  Future<void> loadAndSavePremiumData(String uid) async {
    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists) return;

    final data = doc.data();
    if (data == null) return;

    final bool havePremium = data['premium'] ?? false;
    final String? premiumCodeUsed = data['premiumCodeUsed'];
    final String? premiumTo = data['premiumTo'];

    await SPUserData.setHavePremium(havePremium);
    await SPUserData.setPremiumDetails(
      productId: premiumCodeUsed,
      expiresAt: premiumTo,
    );
  }

}