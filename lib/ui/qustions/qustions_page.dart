import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../blocs/bloc/questions_bloc.dart';
import '../../blocs/event/questions_event.dart';
import '../../blocs/state/questions_state.dart';
import '../../constants.dart';
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
    return BlocProvider(
      lazy: false,
      create: (_) => QuestionsBloc(database: context.read())
        ..add(LoadQuestionsForTopic(
          category: widget.category,
          topic: widget.topic,
        )),
      child: Container(
        decoration: const BoxDecoration(gradient: appBackgroundGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocBuilder<QuestionsBloc, QuestionsState>(
              builder: (context, state) {
                if (state is QuestionsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is QuestionsEmpty) {
                  return const Center(child: Text('😕 Немає доступних питань.'));
                } else if (state is QuestionsLoaded) {
                  final questions = state.questions;
                  final currentQuestion = questions[state.currentIndex];
                  final cardWidth = MediaQuery.of(context).size.width * 0.75;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                              '${state.currentIndex + 1} з ${state.questions.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Image.asset(
                                'assets/icon/settings/restore.png',
                                color: purpleMain,
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {
                                _controller.jumpToPage(0);
                                context.read<QuestionsBloc>().add(UpdateCurrentIndex(0));
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
                            context.read<QuestionsBloc>().add(UpdateCurrentIndex(index));
                          },
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                final page = _controller.hasClients &&
                                    _controller.position.hasContentDimensions
                                    ? _controller.page ?? _controller.initialPage.toDouble()
                                    : _controller.initialPage.toDouble();
                                final distance = (page - index).abs();
                                final scale = (1.2 - distance * 0.3).clamp(0.8, 1.0);
                                return Center(
                                  child: Transform.scale(scale: scale, child: child),
                                );
                              },
                              child: QuestionCard(
                                question: state.questions[index],
                                topic: widget.topic,
                                category: widget.category,
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 46,
                          width: cardWidth,
                          decoration: BoxDecoration(
                            gradient: pinkPurpleGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Share.share(currentQuestion.question);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Поділитися',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 56),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
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

  const QuestionCard({
    super.key,
    required this.question,
    required this.topic,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: Converters().getGradientByTopic(topic),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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
                      gradient: Converters().getGradientByTopic(topic),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                            height: 1.5,
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
