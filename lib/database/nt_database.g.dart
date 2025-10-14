// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nt_database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFreeMeta = const VerificationMeta('isFree');
  @override
  late final GeneratedColumn<bool> isFree = GeneratedColumn<bool>(
    'is_free',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_free" IN (0, 1))',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionNumberMeta = const VerificationMeta(
    'questionNumber',
  );
  @override
  late final GeneratedColumn<int> questionNumber = GeneratedColumn<int>(
    'question_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    isFree,
    category,
    topic,
    questionNumber,
    question,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('is_free')) {
      context.handle(
        _isFreeMeta,
        isFree.isAcceptableOrUnknown(data['is_free']!, _isFreeMeta),
      );
    } else if (isInserting) {
      context.missing(_isFreeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('question_number')) {
      context.handle(
        _questionNumberMeta,
        questionNumber.isAcceptableOrUnknown(
          data['question_number']!,
          _questionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionNumberMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      isFree: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_free'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      questionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_number'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final String language;
  final bool isFree;
  final String category;
  final String topic;
  final int questionNumber;
  final String question;
  const Question({
    required this.id,
    required this.language,
    required this.isFree,
    required this.category,
    required this.topic,
    required this.questionNumber,
    required this.question,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['language'] = Variable<String>(language);
    map['is_free'] = Variable<bool>(isFree);
    map['category'] = Variable<String>(category);
    map['topic'] = Variable<String>(topic);
    map['question_number'] = Variable<int>(questionNumber);
    map['question'] = Variable<String>(question);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      language: Value(language),
      isFree: Value(isFree),
      category: Value(category),
      topic: Value(topic),
      questionNumber: Value(questionNumber),
      question: Value(question),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      isFree: serializer.fromJson<bool>(json['isFree']),
      category: serializer.fromJson<String>(json['category']),
      topic: serializer.fromJson<String>(json['topic']),
      questionNumber: serializer.fromJson<int>(json['questionNumber']),
      question: serializer.fromJson<String>(json['question']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'language': serializer.toJson<String>(language),
      'isFree': serializer.toJson<bool>(isFree),
      'category': serializer.toJson<String>(category),
      'topic': serializer.toJson<String>(topic),
      'questionNumber': serializer.toJson<int>(questionNumber),
      'question': serializer.toJson<String>(question),
    };
  }

  Question copyWith({
    int? id,
    String? language,
    bool? isFree,
    String? category,
    String? topic,
    int? questionNumber,
    String? question,
  }) => Question(
    id: id ?? this.id,
    language: language ?? this.language,
    isFree: isFree ?? this.isFree,
    category: category ?? this.category,
    topic: topic ?? this.topic,
    questionNumber: questionNumber ?? this.questionNumber,
    question: question ?? this.question,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      isFree: data.isFree.present ? data.isFree.value : this.isFree,
      category: data.category.present ? data.category.value : this.category,
      topic: data.topic.present ? data.topic.value : this.topic,
      questionNumber: data.questionNumber.present
          ? data.questionNumber.value
          : this.questionNumber,
      question: data.question.present ? data.question.value : this.question,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('isFree: $isFree, ')
          ..write('category: $category, ')
          ..write('topic: $topic, ')
          ..write('questionNumber: $questionNumber, ')
          ..write('question: $question')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    language,
    isFree,
    category,
    topic,
    questionNumber,
    question,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.language == this.language &&
          other.isFree == this.isFree &&
          other.category == this.category &&
          other.topic == this.topic &&
          other.questionNumber == this.questionNumber &&
          other.question == this.question);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<String> language;
  final Value<bool> isFree;
  final Value<String> category;
  final Value<String> topic;
  final Value<int> questionNumber;
  final Value<String> question;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.isFree = const Value.absent(),
    this.category = const Value.absent(),
    this.topic = const Value.absent(),
    this.questionNumber = const Value.absent(),
    this.question = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required String language,
    required bool isFree,
    required String category,
    required String topic,
    required int questionNumber,
    required String question,
  }) : language = Value(language),
       isFree = Value(isFree),
       category = Value(category),
       topic = Value(topic),
       questionNumber = Value(questionNumber),
       question = Value(question);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<String>? language,
    Expression<bool>? isFree,
    Expression<String>? category,
    Expression<String>? topic,
    Expression<int>? questionNumber,
    Expression<String>? question,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (isFree != null) 'is_free': isFree,
      if (category != null) 'category': category,
      if (topic != null) 'topic': topic,
      if (questionNumber != null) 'question_number': questionNumber,
      if (question != null) 'question': question,
    });
  }

  QuestionsCompanion copyWith({
    Value<int>? id,
    Value<String>? language,
    Value<bool>? isFree,
    Value<String>? category,
    Value<String>? topic,
    Value<int>? questionNumber,
    Value<String>? question,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      isFree: isFree ?? this.isFree,
      category: category ?? this.category,
      topic: topic ?? this.topic,
      questionNumber: questionNumber ?? this.questionNumber,
      question: question ?? this.question,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (isFree.present) {
      map['is_free'] = Variable<bool>(isFree.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (questionNumber.present) {
      map['question_number'] = Variable<int>(questionNumber.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('isFree: $isFree, ')
          ..write('category: $category, ')
          ..write('topic: $topic, ')
          ..write('questionNumber: $questionNumber, ')
          ..write('question: $question')
          ..write(')'))
        .toString();
  }
}

abstract class _$NTDatabase extends GeneratedDatabase {
  _$NTDatabase(QueryExecutor e) : super(e);
  $NTDatabaseManager get managers => $NTDatabaseManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final QuestionDao questionDao = QuestionDao(this as NTDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [questions];
}

typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      required String language,
      required bool isFree,
      required String category,
      required String topic,
      required int questionNumber,
      required String question,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      Value<String> language,
      Value<bool> isFree,
      Value<String> category,
      Value<String> topic,
      Value<int> questionNumber,
      Value<String> question,
    });

class $$QuestionsTableFilterComposer
    extends Composer<_$NTDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFree => $composableBuilder(
    column: $table.isFree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionNumber => $composableBuilder(
    column: $table.questionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$NTDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFree => $composableBuilder(
    column: $table.isFree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionNumber => $composableBuilder(
    column: $table.questionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$NTDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get isFree =>
      $composableBuilder(column: $table.isFree, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<int> get questionNumber => $composableBuilder(
    column: $table.questionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$NTDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, BaseReferences<_$NTDatabase, $QuestionsTable, Question>),
          Question,
          PrefetchHooks Function()
        > {
  $$QuestionsTableTableManager(_$NTDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> isFree = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<int> questionNumber = const Value.absent(),
                Value<String> question = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                language: language,
                isFree: isFree,
                category: category,
                topic: topic,
                questionNumber: questionNumber,
                question: question,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String language,
                required bool isFree,
                required String category,
                required String topic,
                required int questionNumber,
                required String question,
              }) => QuestionsCompanion.insert(
                id: id,
                language: language,
                isFree: isFree,
                category: category,
                topic: topic,
                questionNumber: questionNumber,
                question: question,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$NTDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, BaseReferences<_$NTDatabase, $QuestionsTable, Question>),
      Question,
      PrefetchHooks Function()
    >;

class $NTDatabaseManager {
  final _$NTDatabase _db;
  $NTDatabaseManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
}
