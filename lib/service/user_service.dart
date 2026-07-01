import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naked_truth/utils/share_preferences_user_data.dart';

class FriendActionResult {
  final bool success;
  final String message;
  final bool shouldClose;

  const FriendActionResult({
    required this.success,
    required this.message,
    this.shouldClose = false,
  });
}

class FriendRequestInfo {
  final String otherUid;
  final String? otherName;
  final String? otherCode;
  final DateTime? createdAt;
  final bool replaceExistingFriend;

  const FriendRequestInfo({
    required this.otherUid,
    required this.otherName,
    required this.otherCode,
    required this.createdAt,
    this.replaceExistingFriend = false,
  });
}

class AddFriendPageData {
  final String myFriendCode;
  final FriendRequestInfo? incomingRequest;
  final FriendRequestInfo? outgoingRequest;

  const AddFriendPageData({
    required this.myFriendCode,
    this.incomingRequest,
    this.outgoingRequest,
  });
}

class _FriendActionException implements Exception {
  final String message;

  const _FriendActionException(this.message);
}

class UserService {
  Future<AddFriendPageData> loadAddFriendPageData(String myUid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(myUid).get();
    final data = userDoc.data() ?? <String, dynamic>{};

    return AddFriendPageData(
      myFriendCode: (data['friendCode'] as String?) ?? '',
      incomingRequest: _extractFriendRequest(
        data['incomingFriendRequest'],
        isIncoming: true,
      ),
      outgoingRequest: _extractFriendRequest(
        data['outgoingFriendRequest'],
        isIncoming: false,
      ),
    );
  }

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

    if (friendUid == myUid) {
      return const FriendActionResult(
        success: false,
        message: 'Не можна додати себе',
      );
    }

    final myRef = firestore.collection('users').doc(myUid);
    final friendRef = firestore.collection('users').doc(friendUid);

    try {
      await firestore.runTransaction((tx) async {
        final myDoc = await tx.get(myRef);
        final targetDoc = await tx.get(friendRef);
        final myData = myDoc.data() ?? <String, dynamic>{};
        final targetData = targetDoc.data() ?? <String, dynamic>{};

        final myCurrentFriendUid = _extractFriendUid(myData['friends']);
        final targetCurrentFriendUid = _extractFriendUid(targetData['friends']);
        final myIncomingRequest = _extractFriendRequest(
          myData['incomingFriendRequest'],
          isIncoming: true,
        );
        final myOutgoingRequest = _extractFriendRequest(
          myData['outgoingFriendRequest'],
          isIncoming: false,
        );
        final targetIncomingRequest = _extractFriendRequest(
          targetData['incomingFriendRequest'],
          isIncoming: true,
        );
        final targetOutgoingRequest = _extractFriendRequest(
          targetData['outgoingFriendRequest'],
          isIncoming: false,
        );

        if (myCurrentFriendUid == friendUid) {
          throw const _FriendActionException('Цей користувач уже ваш друг');
        }

        if (myCurrentFriendUid != null && !replaceExistingFriend) {
          throw const _FriendActionException(
            'Спершу приберіть поточного друга',
          );
        }

        if (targetCurrentFriendUid != null && targetCurrentFriendUid != myUid) {
          throw const _FriendActionException('У цього користувача вже є друг');
        }

        if (myIncomingRequest?.otherUid == friendUid) {
          throw const _FriendActionException(
            'У вас уже є вхідний запит від цього користувача',
          );
        }

        if (myOutgoingRequest?.otherUid == friendUid) {
          throw const _FriendActionException('Запит уже надіслано');
        }

        if (myIncomingRequest != null || myOutgoingRequest != null) {
          throw const _FriendActionException(
            'У вас уже є активний запит на дружбу',
          );
        }

        if (targetIncomingRequest != null || targetOutgoingRequest != null) {
          throw const _FriendActionException(
            'У цього користувача вже є активний запит на дружбу',
          );
        }

        final now = Timestamp.now();
        final myDisplayName = myData['displayName'] as String?;
        final myFriendCode = myData['friendCode'] as String?;

        tx.update(myRef, {
          'outgoingFriendRequest': {
            'toUid': friendUid,
            'toName': targetData['displayName'],
            'toCode': targetData['friendCode'],
            'createdAt': now,
            'replaceExistingFriend': replaceExistingFriend,
          },
        });

        tx.update(friendRef, {
          'incomingFriendRequest': {
            'fromUid': myUid,
            'fromName': myDisplayName,
            'fromCode': myFriendCode,
            'createdAt': now,
            'replaceExistingFriend': replaceExistingFriend,
          },
        });
      });

      return const FriendActionResult(
        success: true,
        message: 'Запит на дружбу надіслано',
      );
    } on _FriendActionException catch (e) {
      return FriendActionResult(success: false, message: e.message);
    }
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

  Future<FriendActionResult> acceptIncomingFriendRequest(String myUid) async {
    final firestore = FirebaseFirestore.instance;
    final myRef = firestore.collection('users').doc(myUid);

    try {
      String? acceptedFriendUid;
      String? acceptedFriendName;
      String? acceptedFriendCode;

      await firestore.runTransaction((tx) async {
        final myDoc = await tx.get(myRef);
        final myData = myDoc.data() ?? <String, dynamic>{};
        final incomingRequest = _extractFriendRequest(
          myData['incomingFriendRequest'],
          isIncoming: true,
        );

        if (incomingRequest == null) {
          throw const _FriendActionException('Активний запит не знайдено');
        }

        final requesterRef =
            firestore.collection('users').doc(incomingRequest.otherUid);
        final requesterDoc = await tx.get(requesterRef);
        final requesterData = requesterDoc.data() ?? <String, dynamic>{};

        final requesterOutgoing = _extractFriendRequest(
          requesterData['outgoingFriendRequest'],
          isIncoming: false,
        );

        if (requesterOutgoing?.otherUid != myUid) {
          throw const _FriendActionException('Запит уже неактуальний');
        }

        final myCurrentFriendUid = _extractFriendUid(myData['friends']);
        if (myCurrentFriendUid != null) {
          throw const _FriendActionException('У вас уже є друг');
        }

        final requesterCurrentFriendUid =
            _extractFriendUid(requesterData['friends']);
        final canReplaceExisting =
            incomingRequest.replaceExistingFriend ||
            requesterOutgoing!.replaceExistingFriend;

        if (requesterCurrentFriendUid != null && !canReplaceExisting) {
          throw const _FriendActionException('У цього користувача вже є друг');
        }

        if (requesterCurrentFriendUid != null &&
            requesterCurrentFriendUid != myUid) {
          final requesterOldFriendRef = firestore
              .collection('users')
              .doc(requesterCurrentFriendUid);
          tx.update(requesterOldFriendRef, {
            'friends': FieldValue.delete(),
          });
        }

        final now = Timestamp.now();

        tx.update(myRef, {
          'friends': {
            'friendId': incomingRequest.otherUid,
            'since': now,
          },
          'incomingFriendRequest': FieldValue.delete(),
        });

        tx.update(requesterRef, {
          'friends': {
            'friendId': myUid,
            'since': now,
          },
          'outgoingFriendRequest': FieldValue.delete(),
        });

        acceptedFriendUid = incomingRequest.otherUid;
        acceptedFriendName = incomingRequest.otherName;
        acceptedFriendCode = incomingRequest.otherCode;
      });

      await SPUserData.setFriendUid(acceptedFriendUid);
      await SPUserData.setFriendName(acceptedFriendName);
      await SPUserData.setFriendCode(acceptedFriendCode);

      return const FriendActionResult(
        success: true,
        message: 'Дружбу підтверджено',
        shouldClose: true,
      );
    } on _FriendActionException catch (e) {
      return FriendActionResult(success: false, message: e.message);
    }
  }

  Future<FriendActionResult> declineIncomingFriendRequest(String myUid) async {
    final firestore = FirebaseFirestore.instance;
    final myRef = firestore.collection('users').doc(myUid);

    try {
      await firestore.runTransaction((tx) async {
        final myDoc = await tx.get(myRef);
        final myData = myDoc.data() ?? <String, dynamic>{};
        final incomingRequest = _extractFriendRequest(
          myData['incomingFriendRequest'],
          isIncoming: true,
        );

        if (incomingRequest == null) {
          throw const _FriendActionException('Активний запит не знайдено');
        }

        final requesterRef =
            firestore.collection('users').doc(incomingRequest.otherUid);
        final requesterDoc = await tx.get(requesterRef);
        final requesterData = requesterDoc.data() ?? <String, dynamic>{};
        final requesterOutgoing = _extractFriendRequest(
          requesterData['outgoingFriendRequest'],
          isIncoming: false,
        );

        tx.update(myRef, {
          'incomingFriendRequest': FieldValue.delete(),
        });

        if (requesterOutgoing?.otherUid == myUid) {
          tx.update(requesterRef, {
            'outgoingFriendRequest': FieldValue.delete(),
          });
        }
      });

      return const FriendActionResult(
        success: true,
        message: 'Запит відхилено',
      );
    } on _FriendActionException catch (e) {
      return FriendActionResult(success: false, message: e.message);
    }
  }

  Future<FriendActionResult> cancelOutgoingFriendRequest(String myUid) async {
    final firestore = FirebaseFirestore.instance;
    final myRef = firestore.collection('users').doc(myUid);

    try {
      await firestore.runTransaction((tx) async {
        final myDoc = await tx.get(myRef);
        final myData = myDoc.data() ?? <String, dynamic>{};
        final outgoingRequest = _extractFriendRequest(
          myData['outgoingFriendRequest'],
          isIncoming: false,
        );

        if (outgoingRequest == null) {
          throw const _FriendActionException('Активний запит не знайдено');
        }

        final targetRef =
            firestore.collection('users').doc(outgoingRequest.otherUid);
        final targetDoc = await tx.get(targetRef);
        final targetData = targetDoc.data() ?? <String, dynamic>{};
        final targetIncoming = _extractFriendRequest(
          targetData['incomingFriendRequest'],
          isIncoming: true,
        );

        tx.update(myRef, {
          'outgoingFriendRequest': FieldValue.delete(),
        });

        if (targetIncoming?.otherUid == myUid) {
          tx.update(targetRef, {
            'incomingFriendRequest': FieldValue.delete(),
          });
        }
      });

      return const FriendActionResult(
        success: true,
        message: 'Запит скасовано',
      );
    } on _FriendActionException catch (e) {
      return FriendActionResult(success: false, message: e.message);
    }
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

  FriendRequestInfo? _extractFriendRequest(
    dynamic raw, {
    required bool isIncoming,
  }) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    final otherUid = isIncoming ? raw['fromUid'] : raw['toUid'];
    if (otherUid is! String || otherUid.isEmpty) {
      return null;
    }

    final createdAtRaw = raw['createdAt'];
    DateTime? createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return FriendRequestInfo(
      otherUid: otherUid,
      otherName: (isIncoming ? raw['fromName'] : raw['toName']) as String?,
      otherCode: (isIncoming ? raw['fromCode'] : raw['toCode']) as String?,
      createdAt: createdAt,
      replaceExistingFriend: raw['replaceExistingFriend'] == true,
    );
  }

  Future<void> _clearLocalFriendState() async {
    await SPUserData.setFriendUid(null);
    await SPUserData.setFriendName(null);
    await SPUserData.setFriendCode(null);
    await SPUserData.setFriendCodeExternal(null);
  }

}
