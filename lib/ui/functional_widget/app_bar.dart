import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import 'friend_icon_with_badge.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSubscription;

  const MainAppBar({super.key, required this.isSubscription});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: const FriendIconWithBadge(),
      title: Text(
        AppLocalizations.of(context)!.appName,
        style: const TextStyle(
          fontFamily: 'SFProDisplay',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions:  [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
          },
          icon: ColorFiltered(
            colorFilter: const ColorFilter.mode(pinkMain, BlendMode.srcIn),
            child: Image.asset(
              'assets/icon/setting.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
