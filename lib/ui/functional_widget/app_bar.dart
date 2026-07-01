import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/bloc/auth_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../account_page.dart';
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
      leading: currentUser == null
          ? null
          : IconButton(
              tooltip: AppLocalizations.of(context)!.account,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AuthBloc>(),
                      child: const AccountPage(),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
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
              const FriendIconWithBadge(),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
