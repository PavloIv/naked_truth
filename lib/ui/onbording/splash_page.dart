import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naked_truth/service/auth_service.dart';

import '../../constants.dart';
import '../../service/location_service.dart';
import '../../utils/share_preferences_user_data.dart';
import '../functional_widget/rotating_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  Future<void> _startTransition() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
        return;
      }

      final sw = Stopwatch()..start();
      debugPrint('[SPLASH] start, user=${user.uid}');

      try {
        await AuthService()
            .handleStartupLogic()
            .timeout(const Duration(seconds: 3));
        debugPrint('[SPLASH] handleStartupLogic OK in ${sw.elapsedMilliseconds}ms');
      } catch (e) {
        debugPrint('[SPLASH] handleStartupLogic timeout/error: $e');
      }

      unawaited(_startLocationSoft());
      final seenOnboarding = await SPUserData.hasSeenOnboarding();

      if (!context.mounted) return;

      if (seenOnboarding) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/main');
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        });
      }
    } catch (e) {
      debugPrint('Splash error: $e');
      if (!context.mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  Future<void> _startLocationSoft() async {
    try {
      await LocationService()
          .startForCurrentUser()
          .timeout(const Duration(seconds: 3));
      debugPrint('[SPLASH] location started');
    } catch (e) {
      debugPrint('[SPLASH] location start skipped: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: appBackgroundGradient,
        ),
        child: Center(
          child: RotatingLogo(
            size: 164,
            rotations: 3,
            duration: Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}
