import 'package:drift/drift.dart';

import '../converters/activity_level_converter.dart';
import '../converters/gender_converter.dart';
import '../converters/goal_converter.dart';

@DataClassName('ProfileEntry')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get gender => integer().map(const GenderConverter())();

  IntColumn get age => integer()();

  RealColumn get heightCm => real()();

  RealColumn get weightKg => real()();

  RealColumn get targetWeightKg => real()();

  IntColumn get goal => integer().map(const GoalConverter())();

  IntColumn get activityLevel => integer().map(const ActivityLevelConverter())();
}
