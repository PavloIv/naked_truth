import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naked_truth/database/nt_database.dart';

import '../../models/category_topic.dart';
import '../event/main_event.dart';
import '../state/main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final NTDatabase database;

  MainBloc({required this.database}) : super(MainInitial()) {
    on<LoadMain>(_onLoadMain);
  }

  Future<void> _onLoadMain(LoadMain event, Emitter<MainState> emit) async {
    final questions =
        await database.questionDao.getAllDistinctTopicsForAllCategories();
    final Map<String, List<CategoryTopic>> grouped = {};
    for (final q in questions) {
      final key = q.category;
      grouped.putIfAbsent(key, () => []);
      final alreadyExists = grouped[key]!.any((t) => t.topic == q.topic);
      if (!alreadyExists) {
        grouped[key]!.add(CategoryTopic(topic: q.topic, isFree: q.isFree));
      }
    }
    emit(MainLoaded(grouped, false));
  }
}
