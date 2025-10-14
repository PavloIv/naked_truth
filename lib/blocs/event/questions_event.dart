abstract class QuestionsEvent {}

class LoadQuestionsForTopic extends QuestionsEvent {
  final String category;
  final String topic;

  LoadQuestionsForTopic({required this.category, required this.topic});
}

class UpdateCurrentIndex extends QuestionsEvent {
  final int index;

  UpdateCurrentIndex(this.index);
}
