import 'package:drift/drift.dart';

@DataClassName('BodyWeightEntry')
class WeightEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get weightKg => real()();

  DateTimeColumn get entryDate => dateTime()();
}
