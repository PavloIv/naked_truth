import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../utils/share_preferences_user_data.dart';

class SettingsSyncService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  SettingsSyncService({
    required this.auth,
    required this.firestore,
  });

  Future<void> syncUserSettings() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return;
    }
    try {
      final userDoc =
      await firestore.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) {
        return;
      }
      final data = userDoc.data() ?? {};
      final premiumToRaw = data['premiumTo'];
      DateTime? premiumTo;
      if (premiumToRaw is String) {
        premiumTo = DateTime.tryParse(premiumToRaw);
      } else if (premiumToRaw is Timestamp) {
        premiumTo = premiumToRaw.toDate();
      }
      await SPUserData.setHavePremium(data['premium'] == true);
      await SPUserData.setPremiumProductId(data['premiumProductId'] ?? '');
      if (premiumTo != null) {
        await SPUserData.setPremiumExpiresAt(premiumTo);
      }
      String? friendUid;
      if (data['friends'] != null) {
        final friendData = data['friends'];
        if (friendData is Map<String, dynamic>) {
          friendUid = friendData['friendId'];
        } else if (friendData is List && friendData.isNotEmpty) {
          final firstFriend = friendData.first;
          if (firstFriend is Map<String, dynamic>) {
            friendUid = firstFriend['friendId'];
          }
        }
      }
      if (friendUid != null) {
        await SPUserData.setFriendUid(friendUid);
        final friendDoc =
        await firestore.collection('users').doc(friendUid).get();
        final friendInfo = friendDoc.data();
        if (friendInfo != null) {
          await SPUserData.setFriendName(friendInfo['displayName']);
          await SPUserData.setFriendCode(friendInfo['friendCode']);
        }
      } else {
        await SPUserData.setFriendUid(null);
        await SPUserData.setFriendName(null);
        await SPUserData.setFriendCode(null);
      }
    } catch (e, st) {
      if (kDebugMode) {
        print("❌ Помилка у syncUserSettings: $e\n$st");
      }
    }
  }
}
