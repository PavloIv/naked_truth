import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:naked_truth/database/nt_database.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class QuestionImporter {
  static Future<void> importIfNeeded(NTDatabase db) async {

    final prefs = await SharedPreferences.getInstance();
    final lastMigration = prefs.getInt('questions_migration') ?? 0;

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final versionedFolders = <int>{};
    final pathRegex = RegExp(r'^assets/source/(\d+)/');

    for (final path in manifestMap.keys) {
      final match = pathRegex.firstMatch(path);
      if (match != null) {
        versionedFolders.add(int.parse(match.group(1)!));
      }
    }

    final applicableVersions =
    versionedFolders.where((v) => v > lastMigration).toList()..sort();

    if (applicableVersions.isEmpty) {
      return;
    }

    int questionId = 1;
    final dao = db.questionDao;

    for (final path in manifestMap.keys) {
      if (!path.startsWith('assets/source/') || !path.endsWith('.txt')) continue;

      final segments = p.split(path);
      if (segments.length < 7) continue;

      final version = int.tryParse(segments[2]);
      if (version == null || !applicableVersions.contains(version)) continue;

      final language = segments[3];
      final category = segments[4];
      final topic = segments[5];

      final fileContent = await rootBundle.loadString(path);
      final lines = LineSplitter.split(fileContent).toList();

      final questions = <QuestionsCompanion>[];

      for (final line in lines) {
        String text = line.trim();
        if (text.isEmpty) continue;
        text = text.replaceFirst(RegExp(r'^\d+\.\s*'), '');

        questions.add(QuestionsCompanion.insert(
          id: Value(questionId++),
          language: language,
          isFree: false,
          category: category,
          topic: topic,
          question: text,
          questionNumber: 0,
        ));
      }

      if (questions.isNotEmpty) {
        final alreadyExistsFree = await dao.hasFreeTopic(language, category);
        if (alreadyExistsFree != true) {
          final updated = questions.mapIndexed((i, q) {
            return q.copyWith(isFree: const Value(true));
          }).toList();
          await dao.insertQuestions(updated);
        } else {
          await dao.insertQuestions(questions);
        }
      }
    }

    final latestVersion = applicableVersions.last;
    await prefs.setInt('questions_migration', latestVersion);
  }
}
