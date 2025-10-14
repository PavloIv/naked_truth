import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/friend_stats.dart';

class FriendService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FriendService({required this.firestore, required this.auth});

  Stream<bool> listenOnlineStatus(String friendUid) {
    return firestore.collection('users').doc(friendUid).snapshots().map((snap) {
      final data = snap.data();
      final lastSeen = (data?['lastSeen'] as Timestamp?)?.toDate();
      if (lastSeen == null) return false;
      return DateTime.now().difference(lastSeen).inSeconds < 60;
    });
  }

  Stream<int> listenUnreadCount(String friendUid) {
    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null) return const Stream<int>.empty();

    final chatId = _buildChatId(currentUserId, friendUid);

    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('participants')
        .doc(currentUserId)
        .snapshots()
        .asyncExpand((partSnap) {
      if (!partSnap.exists) return Stream<int>.value(0);
      final lastRead = (partSnap['lastRead'] as Timestamp?)?.toDate();
      if (lastRead == null) return Stream<int>.value(0);

      return firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('timestamp', isGreaterThan: lastRead)
          .snapshots()
          .map((msgSnap) {
        final docs = msgSnap.docs;
        return docs
            .where((d) => d['senderId'] != currentUserId)
            .length; // тільки від друга
      });
    });
  }

  Future<FriendStats> loadFriendStats(String friendUid) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return FriendStats();

    final myDoc = await firestore.collection('users').doc(uid).get();
    final frDoc = await firestore.collection('users').doc(friendUid).get();

    double? myLat = (myDoc.data()?['location']?['latitude'])?.toDouble();
    double? myLon = (myDoc.data()?['location']?['longitude'])?.toDouble();
    double? frLat = (frDoc.data()?['location']?['latitude'])?.toDouble();
    double? frLon = (frDoc.data()?['location']?['longitude'])?.toDouble();

    double? distanceKm;
    if ([myLat, myLon, frLat, frLon].every((e) => e != null)) {
      distanceKm = _haversineKm(myLat!, myLon!, frLat!, frLon!);
    }

    DateTime? since;
    final sinceDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(friendUid)
        .get();

    if (sinceDoc.exists) {
      final ts = sinceDoc.data()?['since'];
      if (ts is Timestamp) since = ts.toDate();
    }
    if (since == null) {
      final ts = frDoc.data()?['createdAt'];
      if (ts is Timestamp) since = ts.toDate();
    }

    return FriendStats(distanceKm: distanceKm, since: since);
  }

  static String _buildChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180.0);
}
