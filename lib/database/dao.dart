import 'package:drift/drift.dart';
import 'entity/questions.dart';
import 'nt_database.dart';

part 'dao.g.dart';

@DriftAccessor(tables: [Questions])
class QuestionDao extends DatabaseAccessor<NTDatabase>
    with _$QuestionDaoMixin {
  QuestionDao(NTDatabase db) : super(db);

  Future<void> insertQuestion(QuestionsCompanion question) =>
      into(questions).insertOnConflictUpdate(question);

  Future<void> insertQuestions(List<QuestionsCompanion> questionList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(questions, questionList);
    });
  }

  Future<void> updateQuestion(Question question) =>
      update(questions).replace(question);

  Future<void> deleteQuestion(Question question) =>
      delete(questions).delete(question);

  Future<void> deleteAllQuestions() => delete(questions).go();

  Future<List<Question>> getAllQuestions() => select(questions).get();

  Future<List<Question>> getQuestionsByTopic(String topic, String language) {
    return (select(questions)
      ..where((q) =>
      q.topic.equals(topic) & q.language.equals(language))
      ..orderBy([
            (q) => OrderingTerm(expression: q.questionNumber),
      ]))
        .get();
  }

  Future<List<Question>> getFreeQuestionsByCategory(
      String category, String language) {
    return (select(questions)
      ..where((q) =>
      q.category.equals(category) &
      q.language.equals(language) &
      q.isFree.equals(true))
      ..orderBy([
            (q) => OrderingTerm(expression: q.topic),
            (q) => OrderingTerm(expression: q.questionNumber),
      ]))
        .get();
  }

  Future<Question?> getQuestionById(int id) =>
      (select(questions)..where((q) => q.id.equals(id))).getSingleOrNull();

  Future<int> getQuestionCount() =>
      customSelect('SELECT COUNT(*) AS count FROM questions',
          readsFrom: {questions})
          .map((row) => row.read<int>('count'))
          .getSingle();

  Future<List<Question>> getDistinctTopicsByCategory(String category) async {
    final rows = await customSelect(
      '''
    SELECT * FROM questions
    WHERE category = ?
    GROUP BY topic
    ''',
      variables: [Variable<String>(category)],
      readsFrom: {questions},
    ).get();

    return rows.map((row) => Question(
      id: row.read<int>('id'),
      language: row.read<String>('language'),
      isFree: row.read<bool>('is_free'),
      category: row.read<String>('category'),
      topic: row.read<String>('topic'),
      questionNumber: row.read<int>('question_number'),
      question: row.read<String>('question'),
    )).toList();
  }

  Future<List<Question>> getAllDistinctTopicsForAllCategories() async {
    final rows = await customSelect(
      '''
    SELECT * FROM questions
    GROUP BY topic
    ''',
      readsFrom: {questions},
    ).get();

    return rows.map((row) => Question(
      id: row.read<int>('id'),
      language: row.read<String>('language'),
      isFree: row.read<bool>('is_free'),
      category: row.read<String>('category'),
      topic: row.read<String>('topic'),
      questionNumber: row.read<int>('question_number'),
      question: row.read<String>('question'),
    )).toList();
  }

  Future<List<Question>> getQuestionsByCategoryAndTopic(
      String category, String topic) {
    return (select(questions)
      ..where((q) =>
      q.category.equals(category) & q.topic.equals(topic))
      ..orderBy([
            (q) => OrderingTerm(expression: q.questionNumber),
      ]))
        .get();
  }

  Future<bool> hasFreeTopic(String lang, String category) async {
    final result = await customSelect(
      '''
      SELECT EXISTS(
        SELECT 1 FROM questions
        WHERE language = ? AND category = ? AND is_free = 1
      ) AS result
    ''',
      variables: [Variable<String>(lang), Variable<String>(category)],
      readsFrom: {questions},
    ).getSingle();

    return result.read<bool>('result') ?? false;
  }
}
