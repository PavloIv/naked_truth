import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../blocs/bloc/questions_bloc.dart';
import '../../blocs/bloc/unread_messages_bloc.dart';
import '../../blocs/event/unread_messages_event.dart';
import '../../blocs/event/questions_event.dart';
import '../../blocs/state/unread_messages_state.dart';
import '../../blocs/state/questions_state.dart';
import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../../service/unread_messages_service.dart';
import '../chat_page.dart';
import '../../utils/converters.dart';

class QuestionsPage extends StatefulWidget {
  final String category;
  final String topic;

  const QuestionsPage({super.key, required this.category, required this.topic});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late final PageController _controller;
  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.75);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.page ?? _controller.initialPage.toDouble());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => QuestionsBloc(database: context.read())
            ..add(LoadQuestionsForTopic(
              category: widget.category,
              topic: widget.topic,
            )),
        ),
        BlocProvider(
          create: (_) => UnreadMessagesBloc(
            service: UnreadMessagesService(
              firestore: FirebaseFirestore.instance,
              auth: FirebaseAuth.instance,
            ),
          )..add(ListenUnreadMessages()),
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                BlocBuilder<QuestionsBloc, QuestionsState>(
                  builder: (context, state) {
                    if (state is QuestionsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (state is QuestionsEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            AppLocalizations.of(context)!.noQuestionsAvailable,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else if (state is QuestionsLoaded) {
                      final questions = state.questions;
                      final currentQuestion = questions[state.currentIndex];
                      final chatBottomSpace = _isChatOpen
                          ? (MediaQuery.of(context).size.height * 0.276)
                              .clamp(207.0, 274.0) +
                              (isKeyboardOpen ? 6 : 24)
                          : 78.0;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icon/arrow_back.png',
                                    color: purpleMain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  onPressed: _handleBack,
                                ),
                                const Spacer(),
                                Text(
                                  AppLocalizations.of(context)!.questionProgress(
                                    state.currentIndex + 1,
                                    state.questions.length,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    color: purpleMain,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    SharePlus.instance.share(
                                      ShareParams(text: currentQuestion.question),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Image.asset(
                                    'assets/icon/settings/restore.png',
                                    color: purpleMain,
                                    width: 20,
                                    height: 20,
                                  ),
                                  onPressed: () {
                                    _controller.jumpToPage(0);
                                    context.read<QuestionsBloc>().add(
                                          UpdateCurrentIndex(0),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: PageView.builder(
                              controller: _controller,
                              clipBehavior: Clip.none,
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.questions.length,
                              onPageChanged: (index) {
                                context.read<QuestionsBloc>().add(
                                      UpdateCurrentIndex(index),
                                    );
                              },
                              itemBuilder: (context, index) {
                                return AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    final page = _controller.hasClients &&
                                            _controller
                                                .position.hasContentDimensions
                                        ? _controller.page ??
                                            _controller.initialPage.toDouble()
                                        : _controller.initialPage.toDouble();
                                    final distance = (page - index).abs();
                                    final scale =
                                        (1.2 - distance * 0.3).clamp(0.8, 1.0);
                                    return Center(
                                      child: Transform.scale(
                                        scale: scale,
                                        child: child,
                                      ),
                                    );
                                  },
                              child: QuestionCard(
                                    key: ValueKey(
                                      '${state.questions[index].question}_${isKeyboardOpen ? 'compact' : 'default'}',
                                    ),
                                    question: state.questions[index],
                                    topic: widget.topic,
                                    category: widget.category,
                                    compactForKeyboard: isKeyboardOpen,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: chatBottomSpace),
                          const SafeArea(
                            top: false,
                            child: SizedBox(height: 12),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                _InGameChatOverlay(
                  isOpen: _isChatOpen,
                  onOpen: () => setState(() => _isChatOpen = true),
                  onClose: () => setState(() => _isChatOpen = false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final dynamic question;
  final String topic;
  final String category;
  final bool compactForKeyboard;

  const QuestionCard({
    super.key,
    required this.question,
    required this.topic,
    required this.category,
    this.compactForKeyboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final scale = Tween<double>(begin: 0.97, end: 1.0).animate(fade);
        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: child,
          ),
        );
      },
      child: compactForKeyboard
          ? _CompactQuestionCard(
              key: const ValueKey('compact_question_card'),
              question: question,
            )
          : _DefaultQuestionCard(
              key: const ValueKey('default_question_card'),
              question: question,
              topic: topic,
              category: category,
            ),
    );
  }
}

class _DefaultQuestionCard extends StatelessWidget {
  final dynamic question;
  final String topic;
  final String category;

  const _DefaultQuestionCard({
    super.key,
    required this.question,
    required this.topic,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.16),
            Color.fromRGBO(255, 255, 255, 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: Converters().getGradientByTopic('Default'),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category[0].toUpperCase() + category.substring(1),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Bitter',
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: Converters().getGradientByTopic('Default'),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          question.question,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.45,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          topic,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
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

class _CompactQuestionCard extends StatelessWidget {
  final dynamic question;

  const _CompactQuestionCard({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: screenSize.width * 0.965,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 2),
      height: screenSize.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 255, 255, 0.16),
            Color.fromRGBO(255, 255, 255, 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: Converters().getGradientByTopic('Default'),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.18,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InGameChatOverlay extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  const _InGameChatOverlay({
    required this.isOpen,
    required this.onOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadMessagesBloc, UnreadMessagesState>(
      builder: (context, state) {
        if (state is! UnreadCountUpdated || state.friendUid == null) {
          return const SizedBox.shrink();
        }

        final screenSize = MediaQuery.of(context).size;
        final panelHeight = (screenSize.height * 0.276).clamp(207.0, 274.0);
        const launcherHeight = 68.0;

        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            height: panelHeight + launcherHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: 0,
                  bottom: isOpen ? 0 : -panelHeight,
                  height: panelHeight,
                  child: IgnorePointer(
                    ignoring: !isOpen,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: appBackgroundGradient,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        border: Border.all(color: Colors.white12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.28),
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        child: ChatConversation(
                          friendUid: state.friendUid!,
                          friendName: state.friendName ??
                              AppLocalizations.of(context)!.friend,
                          embedded: true,
                          onCollapse: onClose,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    ignoring: isOpen,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: isOpen ? 0 : 1,
                      child: _ChatLauncherButton(
                        friendName:
                            state.friendName ?? AppLocalizations.of(context)!.friend,
                        unreadCount: state.count,
                        onTap: onOpen,
                      ),
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

class _ChatLauncherButton extends StatelessWidget {
  final String friendName;
  final int unreadCount;
  final VoidCallback onTap;

  const _ChatLauncherButton({
    required this.friendName,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
        ),
        child: Ink(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            gradient: purpleGradient,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(14),
            ),
            border: Border.all(color: Colors.white12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.24),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    if (unreadCount > 0)
                      const Positioned(
                        top: -1,
                        right: -1,
                        child: _UnreadDot(),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    friendName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF2A0E62),
          width: 1,
        ),
      ),
    );
  }
}
