import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc/auth_bloc.dart';
import '../blocs/state/auth_state.dart';
import '../service/auth_service.dart';
import '../service/location_service.dart';
import '../service/presence_service.dart';
import '../service/settings_sync_service.dart';
import 'login_page.dart';
import 'main/main_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final PresenceService _presenceService = PresenceService();
  final LocationService _locationService = LocationService();
  bool _isPreparingSession = false;
  String? _preparedUid;
  Future<void>? _prepareFuture;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _userSettingsSubscription;

  @override
  void dispose() {
    _userSettingsSubscription?.cancel();
    _presenceService.dispose();
    _locationService.stop();
    super.dispose();
  }

  Future<void> _prepareAuthenticatedSession(User user) {
    if (_preparedUid == user.uid && _prepareFuture != null) {
      return _prepareFuture!;
    }

    _preparedUid = user.uid;
    _isPreparingSession = true;
    _prepareFuture = _runSessionPreparation();
    return _prepareFuture!;
  }

  Future<void> _runSessionPreparation() async {
    final settingsSyncService = SettingsSyncService(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );

    await settingsSyncService.syncUserSettings();
    _startUserSettingsSync(settingsSyncService);

    _presenceService.init();
    unawaited(_locationService.startForCurrentUser());

    if (mounted) {
      setState(() {
        _isPreparingSession = false;
      });
    } else {
      _isPreparingSession = false;
    }
  }

  void _resetSessionServices() {
    _preparedUid = null;
    _prepareFuture = null;
    _isPreparingSession = false;
    _userSettingsSubscription?.cancel();
    _userSettingsSubscription = null;
    _presenceService.dispose();
    _locationService.stop();
  }

  void _startUserSettingsSync(SettingsSyncService settingsSyncService) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _userSettingsSubscription?.cancel();
    _userSettingsSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots()
        .listen((_) async {
      await settingsSyncService.syncUserSettings();
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthService(),
      child: BlocProvider(
        create: (ctx) => AuthBloc(service: ctx.read<AuthService>()),
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.user?.uid != current.user?.uid,
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated && state.user != null) {
              _prepareAuthenticatedSession(state.user!);
            } else if (state.status == AuthStatus.unauthenticated) {
              _resetSessionServices();
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.authenticated &&
                  state.user != null) {
                if (_preparedUid != state.user!.uid || _isPreparingSession) {
                  _prepareAuthenticatedSession(state.user!);
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return const MainPage();
              }

              if (state.status == AuthStatus.unknown ||
                  state.status == AuthStatus.authenticating) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
