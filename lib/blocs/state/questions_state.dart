
import '../../database/nt_database.dart';

abstract class QuestionsState {}

class QuestionsInitial extends QuestionsState {}

class QuestionsLoading extends QuestionsState {}

class QuestionsEmpty extends QuestionsState {}

class QuestionsLoaded extends QuestionsState {
  final List<Question> questions;
  final int currentIndex;

  QuestionsLoaded({required this.questions, required this.currentIndex});

  Question get currentQuestion => questions[currentIndex];

  QuestionsLoaded copyWith({int? currentIndex}) {
    return QuestionsLoaded(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
