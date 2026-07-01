import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naked_truth/utils/utils_formats.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../blocs/bloc/add_friend_bloc.dart';
import '../blocs/event/friend_event.dart';
import '../blocs/event/add_friend_event.dart';
import '../blocs/state/friend_state.dart';
import '../service/friend_service.dart';
import '../service/user_service.dart';
import '../blocs/bloc/friend_bloc.dart';
import 'add_friend_page.dart';
import 'chat_page.dart';

class MyFriendPage extends StatelessWidget {
  static const _pagePadding = EdgeInsets.symmetric(horizontal: 16);

  final String friendUid;
  final String friendName;
  final String friendCode;

  const MyFriendPage({
    super.key,
    required this.friendUid,
    required this.friendName,
    required this.friendCode,
  });

  Future<void> _changeFriend(BuildContext context) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AddFriendBloc(
            userService: UserService(),
            auth: FirebaseAuth.instance,
          )..add(LoadMyFriendCode()),
          child: const AddFriendPage(replaceExistingFriend: true),
        ),
      ),
    );

    if (changed == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _removeFriendship(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: purpleGradient,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_remove_outlined,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 14),
                Text(
                  AppLocalizations.of(context)!.endFriendshipQuestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.endFriendshipDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _DialogActionButton(
                        label: AppLocalizations.of(context)!.cancel,
                        gradient: settingTitleGradient,
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DialogActionButton(
                        label: AppLocalizations.of(context)!.endFriendshipAction,
                        gradient: pinkPurpleGradient,
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final result = await UserService().removeFriendship(currentUser.uid);
    if (!context.mounted) return;

    if (result.success) {
      Navigator.of(context).pop(true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => FriendBloc(
        service: FriendService(
          firestore: FirebaseFirestore.instance,
          auth: FirebaseAuth.instance,
        ),
      )..add(LoadFriend(friendUid)),
      child: Scaffold(
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
                    title: Text(
                      AppLocalizations.of(context)!.myFriend,
                      style: const TextStyle(color: Colors.white),
                    ),
                    centerTitle: true,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: _pagePadding,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: purpleGradient,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: BlocBuilder<FriendBloc, FriendState>(
                                builder: (context, state) {
                                  final stats = state.stats;
                                  final distanceStr = stats?.distanceKm != null
                                      ? UtilsFormats.formatDistance(
                                          stats!.distanceKm!,
                                        )
                                      : AppLocalizations.of(context)!.noData;
                                  final sinceStr = stats?.since != null
                                      ? UtilsFormats.formatSince(stats!.since!)
                                      : AppLocalizations.of(context)!.noData;

                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.white24),
                                          gradient: appBackgroundGradient,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    friendName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: state.isOnline
                                                          ? Colors.greenAccent
                                                          : Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      state.isOnline
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .online
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .offline,
                                                      style: TextStyle(
                                                        color: state.isOnline
                                                            ? Colors
                                                                .greenAccent
                                                            : Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.key,
                                                  size: 16,
                                                  color: Colors.white70,
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.friendCodeLabel}: $friendCode',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.place_outlined,
                                                  size: 16,
                                                  color: Colors.white70,
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.distanceLabel}: $distanceStr',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.favorite_outline,
                                                  size: 16,
                                                  color: Colors.white70,
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    '${AppLocalizations.of(context)!.friendsSinceLabel}: $sinceStr',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: _pagePadding,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: settingTitleGradient,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: BlocBuilder<FriendBloc, FriendState>(
                                builder: (context, state) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 4,
                                    ),
                                    leading: const Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      AppLocalizations.of(context)!.openChat,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (state.unreadCount > 0)
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              state.unreadCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          'assets/icon/arrow_forward.png',
                                          width: 12,
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatPage(
                                            friendUid: friendUid,
                                            friendName: friendName,
                                          ),
                                        ),
                                      );
                                      if (!context.mounted) return;
                                      context.read<FriendBloc>().add(
                                            LoadFriend(friendUid),
                                          );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _FriendManagementPanel(
                    onChangeFriend: () => _changeFriend(context),
                    onRemoveFriend: () => _removeFriendship(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendManagementPanel extends StatelessWidget {
  final VoidCallback onChangeFriend;
  final VoidCallback onRemoveFriend;

  const _FriendManagementPanel({
    required this.onChangeFriend,
    required this.onRemoveFriend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: settingTitleGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BottomActionTile(
              icon: Icons.swap_horiz_rounded,
              label: AppLocalizations.of(context)!.changeFriend,
              onTap: onChangeFriend,
            ),
            const SizedBox(height: 10),
            _BottomActionTile(
              icon: Icons.person_remove_outlined,
              label: AppLocalizations.of(context)!.endFriendship,
              onTap: onRemoveFriend,
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _BottomActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDestructive ? const Color(0xFFFFC1D6) : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDestructive ? 0.08 : 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDestructive
                  ? const Color(0x66FF8FB8)
                  : Colors.white12,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: textColor.withValues(alpha: 0.9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  final String label;
  final Gradient gradient;
  final VoidCallback onPressed;

  const _DialogActionButton({
    required this.label,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
