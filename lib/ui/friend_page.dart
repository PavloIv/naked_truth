import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naked_truth/utils/utils_formats.dart';

import '../constants.dart';
import '../blocs/event/friend_event.dart';
import '../blocs/state/friend_state.dart';
import '../service/friend_service.dart';
import '../blocs/bloc/friend_bloc.dart';
import 'chat_page.dart';

class MyFriendPage extends StatelessWidget {
  final String friendUid;
  final String friendName;
  final String friendCode;

  const MyFriendPage({
    super.key,
    required this.friendUid,
    required this.friendName,
    required this.friendCode,
  });

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
                    title: const Text('Мій друг',
                        style: TextStyle(color: Colors.white)),
                    centerTitle: true,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: purpleGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: BlocBuilder<FriendBloc, FriendState>(
                        builder: (context, state) {
                          final stats = state.stats;
                          final distanceStr = stats?.distanceKm != null
                              ? UtilsFormats.formatDistance(stats!.distanceKm!)
                              : 'Немає даних';
                          final sinceStr = stats?.since != null
                              ? UtilsFormats.formatSince(stats!.since!)
                              : 'Немає даних';

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24),
                                  gradient: appBackgroundGradient,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person,
                                    color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            friendName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
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
                                                  ? 'Online'
                                                  : 'Offline',
                                              style: TextStyle(
                                                color: state.isOnline
                                                    ? Colors.greenAccent
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
                                        const Icon(Icons.key,
                                            size: 16, color: Colors.white70),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            'Friend code: $friendCode',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.place_outlined,
                                            size: 16, color: Colors.white70),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            'Відстань: $distanceStr',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.favorite_outline,
                                            size: 16, color: Colors.white70),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            'Дружимо: $sinceStr',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: settingTitleGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: BlocBuilder<FriendBloc, FriendState>(
                        builder: (context, state) {
                          return ListTile(
                            leading: const Icon(Icons.chat_bubble_outline,
                                color: Colors.white),
                            title: const Text(
                              'Відкрити чат',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (state.unreadCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      state.unreadCount.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
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
                              context.read<FriendBloc>().add(LoadFriend(friendUid));
                            },

                          );
                        },
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
}
