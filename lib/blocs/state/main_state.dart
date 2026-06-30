
import '../../models/category_topic.dart';

abstract class MainState {}

final class MainInitial extends MainState {}

final class MainLoading extends MainState {}

class MainLoaded extends MainState {
  final Map<String, List<CategoryTopic>> topicsByCategory;

  MainLoaded(this.topicsByCategory);
}

class MainError extends MainState {
  final String message;

  MainError(this.message);
}
