import 'package:client/data/local/db/app_database.dart';
import 'package:client/data/local/db/db_enums.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/gender.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/profile.dart';

abstract final class ProfileMapper {
  static Profile fromEntry(ProfileEntry row) {
    return Profile(
      id: row.id,
      name: row.name,
      gender: _gender(row.gender),
      age: row.age,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      targetWeightKg: row.targetWeightKg,
      goal: _goal(row.goal),
      activityLevel: _activity(row.activityLevel),
    );
  }

  static ProfileEntry toEntry(Profile model) {
    return ProfileEntry(
      id: model.id,
      name: model.name,
      gender: _dbGender(model.gender),
      age: model.age,
      heightCm: model.heightCm,
      weightKg: model.weightKg,
      targetWeightKg: model.targetWeightKg,
      goal: _dbGoal(model.goal),
      activityLevel: _dbActivity(model.activityLevel),
    );
  }

  static ProfilesCompanion toInsertCompanion(Profile model) {
    return ProfilesCompanion.insert(
      name: model.name,
      gender: _dbGender(model.gender),
      age: model.age,
      heightCm: model.heightCm,
      weightKg: model.weightKg,
      targetWeightKg: model.targetWeightKg,
      goal: _dbGoal(model.goal),
      activityLevel: _dbActivity(model.activityLevel),
    );
  }

  static Gender _gender(DbGender value) => switch (value) {
        DbGender.male => Gender.male,
        DbGender.female => Gender.female,
      };

  static DbGender _dbGender(Gender value) => switch (value) {
        Gender.male => DbGender.male,
        Gender.female => DbGender.female,
      };

  static Goal _goal(DbGoal value) => switch (value) {
        DbGoal.loseWeight => Goal.loseWeight,
        DbGoal.maintain => Goal.maintain,
        DbGoal.gainMuscle => Goal.gainMuscle,
        DbGoal.cutting => Goal.cutting,
      };

  static DbGoal _dbGoal(Goal value) => switch (value) {
        Goal.loseWeight => DbGoal.loseWeight,
        Goal.maintain => DbGoal.maintain,
        Goal.gainMuscle => DbGoal.gainMuscle,
        Goal.cutting => DbGoal.cutting,
      };

  static ActivityLevel _activity(DbActivityLevel value) => switch (value) {
        DbActivityLevel.sedentary => ActivityLevel.sedentary,
        DbActivityLevel.light => ActivityLevel.light,
        DbActivityLevel.moderate => ActivityLevel.moderate,
        DbActivityLevel.active => ActivityLevel.active,
        DbActivityLevel.veryActive => ActivityLevel.veryActive,
      };

  static DbActivityLevel _dbActivity(ActivityLevel value) => switch (value) {
        ActivityLevel.sedentary => DbActivityLevel.sedentary,
        ActivityLevel.light => DbActivityLevel.light,
        ActivityLevel.moderate => DbActivityLevel.moderate,
        ActivityLevel.active => DbActivityLevel.active,
        ActivityLevel.veryActive => DbActivityLevel.veryActive,
      };
}
