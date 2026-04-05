import 'package:drift/drift.dart';

@DataClassName('FridgeProductEntry')
class FridgeProducts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get amount => real()();

  TextColumn get unit => text()();

  TextColumn get category => text()();

  DateTimeColumn get addedAt => dateTime()();
}
