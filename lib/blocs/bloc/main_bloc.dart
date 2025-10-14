import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naked_truth/database/nt_database.dart';
import 'package:naked_truth/service/user_service.dart';

import '../../models/category_topic.dart';
import '../../utils/share_preferences_user_data.dart';
import '../event/main_event.dart';
import '../state/main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final NTDatabase database;
  final UserService userService = UserService();
  Timer? _subscriptionChecker;

  MainBloc({required this.database}) : super(MainInitial()) {
    _checkUserDataAboutPremiumAtDatabase();
    _startSubscriptionMonitoring();
    on<LoadMain>(_onLoadMain);
  }

  Future<void> _onLoadMain(LoadMain event, Emitter<MainState> emit) async {
    final questions =
        await database.questionDao.getAllDistinctTopicsForAllCategories();
    final Map<String, List<CategoryTopic>> grouped = {};
    for (final q in questions) {
      final key = q.category;
      grouped.putIfAbsent(key, () => []);
      final alreadyExists = grouped[key]!.any((t) => t.topic == q.topic);
      if (!alreadyExists) {
        grouped[key]!.add(CategoryTopic(topic: q.topic, isFree: q.isFree));
      }
    }
    final isPremium = await _resolvePremiumStatus();
    emit(MainLoaded(grouped, isPremium));
  }

  void _checkUserDataAboutPremiumAtDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userService.loadAndSavePremiumData(user.uid);
    }
  }

  void _startSubscriptionMonitoring() {
    _subscriptionChecker?.cancel();
    _subscriptionChecker =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      final isPremiumStored = await SPUserData.getPremiumPreviousStatus();
      final isPremiumNow = await _resolvePremiumStatus();
      if (isPremiumNow != isPremiumStored) {
        await SPUserData.setHavePremium(isPremiumNow);
        add(LoadMain());
      }
      if (isPremiumNow) {
        _subscriptionChecker?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _subscriptionChecker?.cancel();
    return super.close();
  }

  Future<bool> _resolvePremiumStatus() async {
    final userHavePremiumFromFriend = await _checkFriendPremiumAndUpdate();
    final stored = await SPUserData.getHavePremium();
    final isPremium = userHavePremiumFromFriend || stored;
    await SPUserData.setPremiumPreviousStatus(isPremium);
    await SPUserData.setHavePremium(isPremium);

    return isPremium;
  }

  Future<bool> _checkFriendPremiumAndUpdate() async {
    final now = DateTime.now();
    final spExpiresAt = await SPUserData.getCodePremiumTo();
    final spCode = await SPUserData.getFriendPremiumCode();

    if (spExpiresAt != null && spExpiresAt.isAfter(now)) {
      return true;
    }
    if (spCode != null && spCode.isNotEmpty) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final data = userDoc.data();

        if (data != null) {
          final premiumToStr = data['premiumTo'] as String?;
          final premiumTo =
              premiumToStr != null ? DateTime.tryParse(premiumToStr) : null;

          if (premiumTo != null && premiumTo.isAfter(now)) {
            await SPUserData.setFriendPremium(
              havePremium: true,
              code: spCode,
              expiresAt: premiumTo,
            );
            return true;
          }
        }
      }
    }
    await _resetFriendPremium();
    return false;
  }

  Future<void> _resetFriendPremium() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'premium': false,
      'premiumCodeUsed': null,
      'premiumTo': null,
    });

    await SPUserData.setFriendPremium(
      havePremium: false,
      code: '',
      expiresAt: null,
    );
  }
}
