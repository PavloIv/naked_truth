import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.userChanges();

  Future<UserCredential> signInWithGoogle({
    String? serverClientId,
  }) async {
    if (serverClientId != null && serverClientId.isNotEmpty) {
      await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
    } else {
      await GoogleSignIn.instance.initialize();
    }

    final account = await GoogleSignIn.instance.authenticate();

    final auth = account.authentication;

    final credential = GoogleAuthProvider.credential(idToken: auth.idToken);

    final cred = await _auth.signInWithCredential(credential);

    await _runStartupLogicSafely();
    return cred;
  }


  Future<UserCredential> signInWithApple({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final apple = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    ).timeout(timeout);

    final oauth = OAuthProvider('apple.com').credential(
      idToken: apple.identityToken,
      accessToken: apple.authorizationCode,
    );

    final cred = await _auth.signInWithCredential(oauth);

    await _runStartupLogicSafely();
    return cred;
  }

  Future<void> _runStartupLogicSafely() async {
    try {
      await handleStartupLogic();
    } catch (err, st) {
      debugPrint('Startup logic failed after sign-in: $err');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> signOut() async {
    debugPrint('AuthService.signOut: start');
    await _auth.signOut();
    debugPrint('AuthService.signOut: FirebaseAuth signOut complete');
    try {
      await GoogleSignIn.instance.signOut().timeout(
        const Duration(seconds: 5),
      );
      debugPrint('AuthService.signOut: GoogleSignIn signOut complete');
    } catch (err, st) {
      debugPrint('AuthService.signOut: GoogleSignIn signOut failed: $err');
      debugPrintStack(stackTrace: st);
    }
    debugPrint('AuthService.signOut: end');
  }

  Future<String> _generateUniqueFriendCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    while (true) {
      final code = List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();
      final snapshot = await _db
          .collection('users')
          .where('friendCode', isEqualTo: code)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return code;
    }
  }

  Future<void> _createUserIfMissing(User user) async {
    final ref = _db.collection('users').doc(user.uid);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (snap.exists) return;

      final code = await _generateUniqueFriendCode();
      tx.set(ref, {
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'friendCode': code,
        'friends': <String>[],
        'premium': false,
        'premiumCodeUsed': null,
        'premiumTo': null,
        'location': {
          'latitude': null,
          'longitude': null,
          'timestamp': null,
        },
      });
    });
  }

  Future<void> handleStartupLogic() async {
    final user = currentUser;
    if (user == null) throw StateError('No authenticated user found');
    await _createUserIfMissing(user);
  }
}
