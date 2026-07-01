import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/bloc/auth_bloc.dart';
import '../blocs/event/auth_event.dart';
import '../blocs/state/auth_state.dart';
import '../constants.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    if (_isSigningOut) return;

    debugPrint('AccountPage._handleSignOut: tapped');
    final authBloc = context.read<AuthBloc>();
    final signOutStateFuture = authBloc.stream.firstWhere(
      (state) =>
          state.status == AuthStatus.unauthenticated ||
          state.status == AuthStatus.failure,
    );

    setState(() {
      _isSigningOut = true;
    });

    authBloc.add(const SignOutRequested());

    AuthState nextState;
    try {
      nextState = await signOutStateFuture.timeout(
        const Duration(seconds: 8),
      );
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _isSigningOut = false;
      });
      debugPrint('AccountPage._handleSignOut: timeout');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вихід триває занадто довго. Спробуй ще раз.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      _isSigningOut = false;
    });

    if (nextState.status == AuthStatus.unauthenticated) {
      debugPrint('AccountPage._handleSignOut: success');
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    debugPrint('AccountPage._handleSignOut: failure ${nextState.error}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nextState.error ?? 'Не вдалося вийти з акаунта'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenH = MediaQuery.of(context).size.height;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(gradient: appBackgroundGradient),
          alignment: Alignment.center,
          child: const Text(
            'Користувача не знайдено',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            height: screenH,
            decoration: const BoxDecoration(gradient: appBackgroundGradient),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const BackButton(color: Colors.white),
                  title: const Text(
                    'Акаунт',
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                ),
                Expanded(
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      final data = snapshot.data?.data() ?? {};
                      final displayName =
                          (data['displayName'] as String?)?.trim().isNotEmpty ==
                                  true
                              ? data['displayName'] as String
                              : (user.displayName?.trim().isNotEmpty == true
                                  ? user.displayName!
                                  : 'Користувач');
                      final email =
                          (data['email'] as String?) ?? user.email ?? 'Не вказано';
                      final friendCode =
                          (data['friendCode'] as String?) ?? 'Не згенеровано';
                      final createdAt = _formatCreatedAt(data['createdAt']);
                      final hasFriend = _hasFriend(data['friends']);

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - 32,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _AccountHeaderCard(
                                      displayName: displayName,
                                      email: email,
                                      photoUrl: user.photoURL,
                                    ),
                                    const SizedBox(height: 16),
                                    const _SectionTitle(title: 'Основна інформація'),
                                    const SizedBox(height: 10),
                                    _InfoCard(
                                      children: [
                                        _InfoRow(
                                          label: 'Friend code',
                                          value: friendCode,
                                          icon: Icons.qr_code_2_rounded,
                                        ),
                                        _InfoRow(
                                          label: 'Дата реєстрації',
                                          value: createdAt,
                                          icon: Icons.calendar_month_outlined,
                                        ),
                                        _InfoRow(
                                          label: 'Статус друга',
                                          value: hasFriend
                                              ? 'Друг підключений'
                                              : 'Поки без друга',
                                          icon: Icons.favorite_border,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(height: 24),
                                    _SignOutButton(
                                      isLoading: _isSigningOut,
                                      onPressed: _handleSignOut,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static bool _hasFriend(dynamic friends) {
    if (friends is Map<String, dynamic>) {
      return (friends['friendId'] as String?)?.isNotEmpty == true;
    }
    if (friends is List) {
      return friends.isNotEmpty;
    }
    return false;
  }

  static String _formatCreatedAt(dynamic raw) {
    DateTime? dt;
    if (raw is Timestamp) {
      dt = raw.toDate();
    }
    if (dt == null) {
      return 'Невідомо';
    }
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    return '$day.$month.$year';
  }
}

class _AccountHeaderCard extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;

  const _AccountHeaderCard({
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: settingTitleGradient,
              border: Border.all(color: Colors.white24),
            ),
            child: ClipOval(
              child: photoUrl != null && photoUrl!.isNotEmpty
                  ? Image.network(
                      photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _AvatarFallback(),
                    )
                  : const _AvatarFallback(),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: settingTitleGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _SignOutButton({
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: pinkPurpleGradient,
          borderRadius: BorderRadius.circular(26),
        ),
        child: ElevatedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.logout_rounded, color: Colors.white),
          label: Text(
            isLoading ? 'Виходимо...' : 'Вийти з акаунта',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
        ),
      ),
    );
  }
}
