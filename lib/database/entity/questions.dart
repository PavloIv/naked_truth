import 'package:drift/drift.dart';

class Questions extends Table {
  IntColumn get id => integer().autoIncrement()(); // Primary key
  TextColumn get language => text()();
  BoolColumn get isFree => boolean()();
  TextColumn get category => text()();
  TextColumn get topic => text()();
  IntColumn get questionNumber => integer()();
  TextColumn get question => text()();
}
