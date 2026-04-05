import 'package:drift/drift.dart';

@DataClassName('FridgeScanEntry')
class FridgeScans extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get photoPath => text()();

  DateTimeColumn get scanDate => dateTime()();

  IntColumn get productCount => integer().withDefault(const Constant(0))();
}
