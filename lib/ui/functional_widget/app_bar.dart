import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../blocs/bloc/auth_bloc.dart';
import '../../blocs/event/auth_event.dart';
import '../../l10n/app_localizations.dart';
import 'friend_icon_with_badge.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: currentUser != null ? const FriendIconWithBadge() : null,
      title: Text(
        AppLocalizations.of(context)!.appName,
        style: const TextStyle(
          fontFamily: 'SFProDisplay',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: currentUser == null
          ? null
          : [
              IconButton(
                tooltip: 'Вийти',
                onPressed: () async {
                  context.read<AuthBloc>().add(const SignOutRequested());
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
