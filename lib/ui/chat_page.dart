import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../blocs/bloc/chat_bloc.dart';
import '../blocs/event/chat_event.dart';
import '../blocs/state/chat_state.dart';

class ChatPage extends StatelessWidget {
  final String friendUid;
  final String friendName;

  const ChatPage({
    super.key,
    required this.friendUid,
    required this.friendName,
  });

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _generateChatId(currentUid, friendUid);

    return BlocProvider(
      create: (_) => ChatBloc(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
        chatId: chatId,
        friendUid: friendUid,
      )
        ..add(LoadMessages())
        ..add(ListenFriendStatus())
        ..add(ListenFriendReadStatus()),
      child: _ChatView(friendName: friendName),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String friendName;
  const _ChatView({required this.friendName});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(text));
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (prev, curr) => curr is ChatLoaded,
      listener: (context, state) {
        // ✅ виконуємо MarkAsRead тільки після завантаження повідомлень
        context.read<ChatBloc>().add(MarkAsRead());
      },
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
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (p, c) => c is ChatLoaded,
                    builder: (context, state) {
                      String subtitle = '';
                      if (state is ChatLoaded) {
                        subtitle = state.isFriendOnline
                            ? '(онлайн)'
                            : state.friendLastSeen != null
                            ? '(був о ${state.friendLastSeen!.hour.toString().padLeft(2, '0')}:${state.friendLastSeen!.minute.toString().padLeft(2, '0')})'
                            : '';
                      }
                      return AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: const BackButton(color: Colors.white),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.friendName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                            if (subtitle.isNotEmpty)
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                        centerTitle: true,
                      );
                    },
                  ),

                  Expanded(
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }
                        if (state is ChatLoaded && state.messages.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final msg = state.messages[index];
                              final isMe = msg.senderId ==
                                  FirebaseAuth.instance.currentUser!.uid;
                              final isRead = isMe &&
                                  state.friendLastRead != null &&
                                  msg.timestamp.isBefore(state.friendLastRead!);

                              return _MessageBubble(
                                text: msg.text,
                                time: _formatTime(msg.timestamp),
                                isMe: isMe,
                                isRead: isRead,
                              );
                            },
                          );
                        }
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Почніть розмову',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(height: 1, color: Colors.white24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: SafeArea(
                      top: false,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: settingTitleGradient,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _send(),
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Введіть повідомлення...',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: _send,
                              splashRadius: 22,
                            ),
                          ],
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

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;
  final bool isRead;

  const _MessageBubble({
    required this.text,
    required this.time,
    required this.isMe,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final Gradient bubbleGradient =
        isMe ? purpleGradient : settingTitleGradient;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
    );
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: bubbleGradient,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: isRead ? Colors.lightBlueAccent : Colors.white70,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
