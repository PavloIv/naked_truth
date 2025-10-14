import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:naked_truth/database/nt_database.dart';
import '../event/questions_event.dart';
import '../state/questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  final NTDatabase database;

  QuestionsBloc({required this.database}) : super(QuestionsInitial()) {
    on<LoadQuestionsForTopic>(_onLoadQuestionsForTopic);
    on<UpdateCurrentIndex>(_onUpdateCurrentIndex);
  }

  Future<void> _onLoadQuestionsForTopic(
      LoadQuestionsForTopic event, Emitter<QuestionsState> emit) async {
    emit(QuestionsLoading());

    final questions = await database.questionDao.getQuestionsByCategoryAndTopic(
      event.category,
      event.topic,
    );

    if (questions.isEmpty) {
      emit(QuestionsEmpty());
    } else {
      emit(QuestionsLoaded(questions: questions, currentIndex: 0));
    }
  }

  void _onUpdateCurrentIndex(
      UpdateCurrentIndex event, Emitter<QuestionsState> emit) {
    final currentState = state;
    if (currentState is QuestionsLoaded) {
      emit(currentState.copyWith(currentIndex: event.index));
    }
  }
}
