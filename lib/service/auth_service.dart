import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
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
    final rawNonce = generateNonce();
    final hashedNonce = _sha256OfString(rawNonce);

    final apple = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    ).timeout(timeout);

    final identityToken = apple.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-apple-id-token',
        message: 'Apple Sign-In did not return an identity token.',
      );
    }

    final oauth = OAuthProvider('apple.com').credential(
      idToken: identityToken,
      rawNonce: rawNonce,
      accessToken: apple.authorizationCode,
    );

    final cred = await _auth.signInWithCredential(oauth);
    await _updateAppleProfileIfNeeded(
      credential: cred,
      givenName: apple.givenName,
      familyName: apple.familyName,
    );

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

  Future<void> _updateAppleProfileIfNeeded({
    required UserCredential credential,
    String? givenName,
    String? familyName,
  }) async {
    final user = credential.user;
    if (user == null) return;

    final appleDisplayName = [givenName, familyName]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(' ');

    if (appleDisplayName.isNotEmpty && (user.displayName?.trim().isEmpty ?? true)) {
      await user.updateDisplayName(appleDisplayName);
      await user.reload();
    }
  }

  Future<void> handleStartupLogic() async {
    final user = currentUser;
    if (user == null) throw StateError('No authenticated user found');
    await _createUserIfMissing(user);
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
