import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../blocs/bloc/add_friend_bloc.dart';
import '../../blocs/bloc/unread_messages_bloc.dart';
import '../../blocs/event/add_friend_event.dart';
import '../../blocs/event/unread_messages_event.dart';
import '../../blocs/state/unread_messages_state.dart';
import '../../service/user_service.dart';
import '../../service/unread_messages_service.dart';
import '../../constants.dart';
import '../add_friend_page.dart';
import '../friend_page.dart';
import 'unread_message_badge.dart';

class FriendIconWithBadge extends StatelessWidget {
  const FriendIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UnreadMessagesBloc(
        service: UnreadMessagesService(
          firestore: FirebaseFirestore.instance,
          auth: FirebaseAuth.instance,
        ),
      )..add(ListenUnreadMessages()),
      child: BlocBuilder<UnreadMessagesBloc, UnreadMessagesState>(
        builder: (context, state) {
          String? friendUid;
          String? friendName;
          String? friendCode;

          if (state is UnreadCountUpdated) {
            friendUid = state.friendUid;
            friendName = state.friendName;
            friendCode = state.friendCode;
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () async {
                  if (friendUid != null) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MyFriendPage(
                          friendUid: friendUid!,
                          friendName: friendName ?? 'Friend',
                          friendCode: friendCode ?? '',
                        ),
                      ),
                    );
                  } else {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => AddFriendBloc(
                            userService: UserService(),
                            auth: FirebaseAuth.instance,
                          )..add(LoadMyFriendCode()),
                          child: const AddFriendPage(),
                        ),
                      ),
                    );
                  }
                  if (!context.mounted) return;
                  context.read<UnreadMessagesBloc>().add(ListenUnreadMessages());
                },
                icon: ColorFiltered(
                  colorFilter: const ColorFilter.mode(pinkMain, BlendMode.srcIn),
                  child: Image.asset(
                    'assets/icon/friend.png',
                    width: 26,
                    height: 26,
                  ),
                ),
              ),
              const Positioned(
                right: 2,
                top: 2,
                child: UnreadMessagesBadge(),
              ),
            ],
          );
        },
      ),
    );
  }
}
