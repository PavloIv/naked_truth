import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/nt_database.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  late NTDatabase _database;

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Future<void> init() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mht.sqlite'));

    _database = NTDatabase(NativeDatabase(file));
  }

  NTDatabase get database => _database;
}
