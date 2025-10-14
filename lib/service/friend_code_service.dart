import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naked_truth/utils/share_preferences_user_data.dart';
import 'subscription_service.dart';

class FriendCodeService {
  final _firestore = FirebaseFirestore.instance;
  final SubscriptionService _subscriptionService = SubscriptionService();

  // Future<bool> generateFriendCode(String creatorUid) async {
  //   final subs = await _subscriptionService.checkSubscription();
  //
  //   subs.sort((a, b) {
  //     final ad = a.purchaseDate ?? DateTime.fromMillisecondsSinceEpoch(0);
  //     final bd = b.purchaseDate ?? DateTime.fromMillisecondsSinceEpoch(0);
  //     return bd.compareTo(ad);
  //   });
  //
  //   if (subs.isEmpty) {
  //     await SPUserData.setFriendCode('');
  //     return false;
  //   }
  //
  //   final latestSub = subs.first;
  //
  //   // if (!latestSub.productId.contains('pair') || latestSub.purchaseDate == null) {
  //   if (!latestSub.productId.contains('1y') || latestSub.purchaseDate == null) {
  //     print('❌ Остання підписка не є pair');
  //     await SPUserData.setFriendCode('');
  //     return false;
  //   }
  //
  //   final purchaseDate = latestSub.purchaseDate!;
  //   final expiryDate = _calculateExpiry(latestSub.productId, purchaseDate);
  //
  //   if (expiryDate.isBefore(DateTime.now())) {
  //     print('⚠️ Pair-підписка прострочена');
  //     await SPUserData.setFriendCode('');
  //     return false;
  //   }
  //
  //   final now = DateTime.now();
  //   final existingQuery = await _firestore
  //       .collection('friend_codes')
  //       .where('creatorUid', isEqualTo: creatorUid)
  //       .where('used', isEqualTo: false)
  //       .get();
  //
  //   for (final doc in existingQuery.docs) {
  //     final data = doc.data();
  //     final expiresAt = DateTime.tryParse(data['expiresAt'] ?? '');
  //     if (expiresAt != null && expiresAt.isAfter(now)) {
  //       final existingCode = data['code'] as String;
  //
  //       await SPUserData.setGeneratedFriendCode(
  //         code: existingCode,
  //         expiresAt: expiresAt,
  //       );
  //
  //       print('✅ Знайдено активний код: $existingCode, діє до $expiresAt');
  //       return true;
  //     }
  //   }
  //   while (true) {
  //     final code = _generateShortCode(9);
  //
  //     final docRef = _firestore.collection('friend_codes').doc(code);
  //     final existing = await docRef.get();
  //
  //     if (!existing.exists) {
  //       await docRef.set({
  //         'creatorUid': creatorUid,
  //         'code': code,
  //         'expiresAt': expiryDate.toIso8601String(),
  //         'used': false,
  //         'usedBy': null,
  //         'usedAt': null,
  //       });
  //
  //       await SPUserData.setGeneratedFriendCode(
  //         code: code,
  //         expiresAt: expiryDate,
  //       );
  //
  //       print('✅ Новий код збережено: $code, діє до $expiryDate');
  //       return true;
  //     }
  //
  //     print('⚠️ Код уже існує, генеруємо новий...');
  //   }
  // }

  Future<bool> generateFriendCode(String creatorUid) async {
    final subs = await _subscriptionService.checkSubscription();

    subs.sort((a, b) {
      final ad = a.purchaseDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.purchaseDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    if (subs.isEmpty) {
      await SPUserData.setFriendCode('');
      return false;
    }

    final latestSub = subs.first;

    if (!latestSub.productId.contains('1y') || latestSub.purchaseDate == null) {
      print('❌ Остання підписка не є pair');
      await SPUserData.setFriendCode('');
      return false;
    }

    // 🔹 Тепер для тесту завжди 5 хв
    final now = DateTime.now();
    final expiryDate = now.add(const Duration(minutes: 5));

    if (expiryDate.isBefore(now)) {
      print('⚠️ Pair-підписка прострочена');
      await SPUserData.setFriendCode('');
      return false;
    }

    // 🔹 Перевірка чи є вже існуючий код
    final existingQuery = await _firestore
        .collection('friend_codes')
        .where('creatorUid', isEqualTo: creatorUid)
        .where('used', isEqualTo: false)
        .get();

    for (final doc in existingQuery.docs) {
      final data = doc.data();
      final expiresAt = DateTime.tryParse(data['expiresAt'] ?? '');
      final existingCode = data['code'] as String;

      if (expiresAt != null) {
        if (expiresAt.isAfter(now)) {
          // ✅ Код ще дійсний
          await SPUserData.setGeneratedFriendCode(
            code: existingCode,
            expiresAt: expiresAt,
          );
          print('✅ Знайдено активний код: $existingCode, діє до $expiresAt');
          return true;
        } else {
          // ⚠️ Код прострочений, але підписка ще активна → створюємо новий
          print('♻️ Існуючий код $existingCode прострочений, генеруємо новий...');
        }
      }
    }

    // 🔹 Генеруємо новий код
    while (true) {
      final code = _generateShortCode(9);

      final docRef = _firestore.collection('friend_codes').doc(code);
      final existing = await docRef.get();

      if (!existing.exists) {
        await docRef.set({
          'creatorUid': creatorUid,
          'code': code,
          'expiresAt': expiryDate.toIso8601String(),
          'used': false,
          'usedBy': null,
          'usedAt': null,
        });

        await SPUserData.setGeneratedFriendCode(
          code: code,
          expiresAt: expiryDate,
        );

        print('✅ Новий код збережено: $code, діє до $expiryDate');
        return true;
      }

      print('⚠️ Код уже існує, генеруємо новий...');
    }
  }

  Future<String?> applyFriendCode({
    required String code,
    required String friendUid,
  }) async {
    try {
      final docRef = _firestore.collection('friend_codes').doc(code);
      final snap = await docRef.get();

      if (!snap.exists) {
        return '❌ Код не знайдено';
      }

      final data = snap.data()!;
      final usedBy = data['usedBy'];
      final expiresAtStr = data['expiresAt'] as String?;
      final expiryDate =
          expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

      if (usedBy != null) {
        return '❌ Цей код уже використаний';
      }

      if (expiryDate == null || expiryDate.isBefore(DateTime.now())) {
        return '❌ Термін дії коду закінчився';
      }

      await docRef.update({
        'used': true,
        'usedBy': friendUid,
        'usedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(friendUid).update({
        'premium': true,
        'premiumCodeUsed': code,
        'premiumTo': expiryDate.toIso8601String(),
      });

      await SPUserData.setFriendPremium(
        havePremium: true,
        code: code,
        expiresAt: expiryDate,
      );

      return null;
    } catch (e) {
      return '❌ Помилка: ${e.toString()}';
    }
  }

  DateTime _calculateExpiry(String productId, DateTime purchaseDate) {
    if (productId.contains('1w')) {
      return purchaseDate.add(const Duration(days: 7));
    } else if (productId.contains('1y')) {
      return DateTime(
        purchaseDate.year + 1,
        purchaseDate.month,
        purchaseDate.day,
        purchaseDate.hour,
        purchaseDate.minute,
        purchaseDate.second,
      );
    }
    return purchaseDate.add(const Duration(days: 7));
  }

  String _generateShortCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
