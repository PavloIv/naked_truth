import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';
import '../blocs/bloc/auth_bloc.dart';
import '../blocs/event/auth_event.dart';
import '../blocs/state/auth_state.dart';
import '../l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _pagePadding = EdgeInsets.symmetric(horizontal: 20);

  bool _permissionFlowStarted = false;
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _forceLocationPermissionFlow());
  }

  Future<void> _forceLocationPermissionFlow() async {
    if (_permissionFlowStarted) return;
    _permissionFlowStarted = true;

    if (!await Geolocator.isLocationServiceEnabled()) {
      final open = await _showPermissionDialog(
        title: l10n.enableLocationTitle,
        text: l10n.enableLocationText,
        actionText: l10n.openSettingsAction,
      );
      if (open == true) {
        await Geolocator.openLocationSettings();
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }

    var perm = await Geolocator.checkPermission();
    if (!_isGranted(perm)) {
      final allow = await _showPermissionDialog(
        title: l10n.locationAccessTitle,
        text: l10n.locationAccessText,
        actionText: l10n.okAction,
      );

      if (allow == true) {
        if (perm == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
          await Future.delayed(const Duration(milliseconds: 400));
        } else {
          perm = await Geolocator.requestPermission();
        }
      }
    }

    perm = await Geolocator.checkPermission();
    if (!_isGranted(perm)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.locationAccessNotGranted),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  bool _isGranted(LocationPermission p) =>
      p == LocationPermission.always || p == LocationPermission.whileInUse;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.user?.uid != c.user?.uid,
      listener: (context, state) async {
        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? l10n.loginFailed)),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
                height: screenH,
                decoration:
                    const BoxDecoration(gradient: appBackgroundGradient)),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: _pagePadding,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: purpleGradient,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n.welcome,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.signInToStart,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                BlocBuilder<AuthBloc, AuthState>(
                                  buildWhen: (p, c) => p.status != c.status,
                                  builder: (context, state) {
                                    final isLoading =
                                        state.status == AuthStatus.authenticating;

                                    Future<void> onSignIn() async {
                                      if (isLoading) return;

                                      const webClientId =
                                          '870984725053-e6ngh9e4g68sd72tc0apl4gg8pb1ui4u.apps.googleusercontent.com';

                                      context.read<AuthBloc>().add(
                                            const SignInWithGooglePressed(
                                              serverClientId: webClientId,
                                            ),
                                          );
                                    }

                                    return SizedBox(
                                      height: 52,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: appBackgroundGradient,
                                          borderRadius: BorderRadius.circular(26),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: isLoading ? null : onSignIn,
                                          icon: isLoading
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : const Icon(Icons.login,
                                                  color: Colors.white),
                                          label: Text(
                                            isLoading
                                                ? l10n.signingIn
                                                : l10n.signIn,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showPermissionDialog({
    required String title,
    required String text,
    required String actionText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: purpleGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: appBackgroundGradient,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                      ),
                      child: Text(actionText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
