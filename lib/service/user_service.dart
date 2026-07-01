import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naked_truth/utils/share_preferences_user_data.dart';

class FriendActionResult {
  final bool success;
  final String message;

  const FriendActionResult({
    required this.success,
    required this.message,
  });
}

class UserService {
  Future<FriendActionResult> addFriendByCode(
    String myUid,
    String code, {
    bool replaceExistingFriend = false,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final friendQuery = await firestore
        .collection('users')
        .where('friendCode', isEqualTo: code)
        .limit(1)
        .get();

    if (friendQuery.docs.isEmpty) {
      return const FriendActionResult(
        success: false,
        message: 'Код не знайдено',
      );
    }

    final friendDoc = friendQuery.docs.first;
    final friendUid = friendDoc.id;
    final friendData = friendDoc.data();

    if (friendUid == myUid) {
      return const FriendActionResult(
        success: false,
        message: 'Не можна додати себе',
      );
    }

    final myDoc = await firestore.collection('users').doc(myUid).get();
    final myCurrentFriendUid = _extractFriendUid(myDoc.data()?['friends']);
    final targetCurrentFriendUid =
        _extractFriendUid(friendData['friends']);

    if (myCurrentFriendUid == friendUid) {
      return const FriendActionResult(
        success: false,
        message: 'Цей користувач уже ваш друг',
      );
    }

    if (myCurrentFriendUid != null && !replaceExistingFriend) {
      return const FriendActionResult(
        success: false,
        message: 'Спершу приберіть поточного друга',
      );
    }

    if (targetCurrentFriendUid != null && targetCurrentFriendUid != myUid) {
      return const FriendActionResult(
        success: false,
        message: 'У цього користувача вже є друг',
      );
    }

    if (myCurrentFriendUid != null) {
      await removeFriendship(myUid, clearLocalState: false);
    }

    final now = Timestamp.now();
    final batch = firestore.batch();

    batch.update(firestore.collection('users').doc(myUid), {
      'friends': {
        'friendId': friendUid,
        'since': now,
      },
    });

    batch.update(firestore.collection('users').doc(friendUid), {
      'friends': {
        'friendId': myUid,
        'since': now,
      },
    });

    await batch.commit();

    await SPUserData.setFriendUid(friendUid);
    await SPUserData.setFriendName(friendData['displayName'] as String?);
    await SPUserData.setFriendCode(friendData['friendCode'] as String?);

    return FriendActionResult(
      success: true,
      message: replaceExistingFriend ? 'Друга змінено' : 'Друг доданий!',
    );
  }

  Future<FriendActionResult> removeFriendship(
    String myUid, {
    bool clearLocalState = true,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final myDoc = await firestore.collection('users').doc(myUid).get();
    final myFriendUid = _extractFriendUid(myDoc.data()?['friends']);

    if (myFriendUid == null) {
      if (clearLocalState) {
        await _clearLocalFriendState();
      }
      return const FriendActionResult(
        success: false,
        message: 'У вас зараз немає активного друга',
      );
    }

    final batch = firestore.batch();
    batch.update(firestore.collection('users').doc(myUid), {
      'friends': FieldValue.delete(),
    });
    batch.update(firestore.collection('users').doc(myFriendUid), {
      'friends': FieldValue.delete(),
    });
    await batch.commit();

    if (clearLocalState) {
      await _clearLocalFriendState();
    }

    return const FriendActionResult(
      success: true,
      message: 'Дружбу прибрано',
    );
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

  String? _extractFriendUid(dynamic friends) {
    if (friends is Map<String, dynamic>) {
      final friendId = friends['friendId'];
      if (friendId is String && friendId.isNotEmpty) {
        return friendId;
      }
    }

    if (friends is List && friends.isNotEmpty) {
      final firstFriend = friends.first;
      if (firstFriend is Map<String, dynamic>) {
        final friendId = firstFriend['friendId'];
        if (friendId is String && friendId.isNotEmpty) {
          return friendId;
        }
      }
    }

    return null;
  }

  Future<void> _clearLocalFriendState() async {
    await SPUserData.setFriendUid(null);
    await SPUserData.setFriendName(null);
    await SPUserData.setFriendCode(null);
    await SPUserData.setFriendCodeExternal(null);
  }

}
