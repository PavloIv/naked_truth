import 'package:shared_preferences/shared_preferences.dart';

class SPUserData {
  static const String _keyHavePremium = 'havePremium';
  static const String _keyPremiumPreviousStatus = 'premiumPreviousStatus';
  static const String _keyPremiumProductId = 'premiumProductId';
  static const String _keyPremiumCodeUsed = 'premiumCodeUsed';
  static const String _keyPremiumExpiresAt = 'premiumExpiresAt';
  static const String _keyLastImportedMigration = 'lastImportedMigration';
  static const String _keyFriendCode = 'friendCode';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyHavePremiumFromFriend = 'havePremiumFromFriend';
  static const String _keyFriendPremiumCodeUsed = 'friendPremiumCodeUsed';
  static const String _keyCodePremium = 'codePremium';
  static const String _keyCodePremiumTo = 'codePremiumTo';
  static const String _keyFriendUid = 'friendUid';
  static const String _keyFriendName = 'friendName';
  static const String _keyFriendCodeExternal = 'friendCodeExternal';
  static Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, value);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? true;
  }

  static Future<void> setPremiumDetails({
    required String? productId,
    required String? expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (productId != null) {
      await prefs.setString(_keyPremiumCodeUsed, productId);
    }
    if (expiresAt != null) {
      await prefs.setString(_keyPremiumExpiresAt, expiresAt);
    }
  }

  static Future<void> setHavePremium(bool havePremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHavePremium, havePremium);
  }

  static Future<void> setPremiumPreviousStatus(bool havePremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremiumPreviousStatus, havePremium);
  }

  static Future<bool> getHavePremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHavePremium) ?? false;
  }

  static Future<bool> getPremiumPreviousStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPremiumPreviousStatus) ?? false;
  }

  static Future<void> setFriendCode(String? friendCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFriendCode, friendCode ?? '');
  }

  static Future<String> getFriendCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFriendCode) ?? '';
  }

  static Future<void> setPremiumProductId(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPremiumProductId, productId);
  }

  static Future<String?> getPremiumProductId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPremiumProductId);
  }

  static Future<String?> getPremiumCodeUsed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPremiumCodeUsed);
  }

  static Future<void> setPremiumExpiresAt(DateTime expiresAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPremiumExpiresAt, expiresAt.toIso8601String());
  }

  static Future<DateTime?> getPremiumExpiresAt() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyPremiumExpiresAt);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  static Future<bool> isPremiumStillValidOffline() async {
    final expiresAt = await getPremiumExpiresAt();
    if (expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt);
  }

  static Future<bool> isPremiumExpiringSoon({int daysBefore = 2}) async {
    final expiresAt = await getPremiumExpiresAt();
    if (expiresAt == null) return false;

    final now = DateTime.now();
    final diff = expiresAt.difference(now).inDays;

    return diff <= daysBefore && now.isBefore(expiresAt);
  }

  static Future<void> setLastImportedMigration(String migrationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastImportedMigration, migrationId);
  }

  static Future<String?> getLastImportedMigration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastImportedMigration);
  }

  static Future<void> setFriendPremium({
    required bool havePremium,
    required String? code,
    required DateTime? expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHavePremiumFromFriend, havePremium);
    await prefs.setBool(_keyHavePremium, havePremium);

    await prefs.setString(_keyFriendPremiumCodeUsed, code ?? '');

    await prefs.setString(
      _keyCodePremiumTo,
      expiresAt?.toIso8601String() ?? '',
    );
  }

  static Future<void> setGeneratedFriendCode({
    required String code,
    required DateTime expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCodePremium, code);
    await prefs.setString(_keyCodePremiumTo, expiresAt.toIso8601String());
  }

  static Future<bool> getHavePremiumFromFriend() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHavePremiumFromFriend) ?? false;
  }

  static Future<String?> getCodePremium() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyCodePremium);
    if (code == null || code.isEmpty) return null;
    return code;
  }

  static Future<DateTime?> getCodePremiumTo() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCodePremiumTo);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static Future<bool> isFriendPremiumValid() async {
    final havePremium = await getHavePremiumFromFriend();
    final expiresAt = await getCodePremiumTo();

    if (!havePremium || expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt);
  }

  static Future<String?> getFriendPremiumCode() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyFriendPremiumCodeUsed);
    if (code == null || code.isEmpty) return null;
    return code;
  }

  static Future<void> setFriendUid(String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFriendUid, uid ?? '');
  }

  static Future<String?> getFriendUid() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(_keyFriendUid);
    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  static Future<void> setFriendName(String? name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFriendName, name ?? '');
  }

  static Future<String?> getFriendName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyFriendName);
    if (name == null || name.isEmpty) return null;
    return name;
  }

  static Future<void> setFriendCodeExternal(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFriendCodeExternal, code ?? '');
  }

  static Future<String?> getFriendCodeExternal() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyFriendCodeExternal);
    if (code == null || code.isEmpty) return null;
    return code;
  }
}
