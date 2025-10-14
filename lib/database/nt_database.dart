import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dao.dart';
import 'entity/questions.dart';

part 'nt_database.g.dart';

@DriftDatabase(tables: [Questions], daos: [QuestionDao])
class NTDatabase extends _$NTDatabase {
  NTDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

Future<LazyDatabase> openConnection({bool resetDb = false}) async {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mht.sqlite'));

    if (resetDb && await file.exists()) {
      await file.delete();
    }

    return NativeDatabase(file);
  });
}
