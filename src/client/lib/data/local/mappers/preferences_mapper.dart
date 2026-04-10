import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:client/data/local/db/app_database.dart';
import 'package:client/domain/models/enums/budget_level.dart';
import 'package:client/domain/models/enums/diet_type.dart';
import 'package:client/domain/models/user_preferences.dart';
import '../db/db_enums.dart';

abstract final class PreferencesMapper {
  static UserPreferences fromEntry(PreferencesEntry row) {
    return UserPreferences(
      id: row.id,
      allergies: _decodeList(row.allergies),
      dislikedProducts: _decodeList(row.dislikedProducts),
      likedProducts: _decodeList(row.likedProducts),
      maxCookingMinutes: row.maxCookingMinutes,
      budget: _budget(row.budget),
      dietType: _dietType(row.dietType),
    );
  }

  static PreferencesCompanion toInsertCompanion(UserPreferences model) {
    return PreferencesCompanion.insert(
      allergies: Value(_encodeList(model.allergies)),
      dislikedProducts: Value(_encodeList(model.dislikedProducts)),
      likedProducts: Value(_encodeList(model.likedProducts)),
      maxCookingMinutes: Value(model.maxCookingMinutes),
      budget: _dbBudget(model.budget),
      dietType: _dbDietType(model.dietType),
    );
  }

  static PreferencesEntry toEntry(UserPreferences model) {
    return PreferencesEntry(
      id: model.id,
      allergies: _encodeList(model.allergies),
      dislikedProducts: _encodeList(model.dislikedProducts),
      likedProducts: _encodeList(model.likedProducts),
      maxCookingMinutes: model.maxCookingMinutes,
      budget: _dbBudget(model.budget),
      dietType: _dbDietType(model.dietType),
    );
  }

  static String _encodeList(List<String> values) => jsonEncode(values);

  static List<String> _decodeList(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return const [];
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // fallback: comma-separated
    }
    return trimmed
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static BudgetLevel _budget(DbBudgetLevel value) => switch (value) {
        DbBudgetLevel.low => BudgetLevel.low,
        DbBudgetLevel.medium => BudgetLevel.medium,
        DbBudgetLevel.high => BudgetLevel.high,
      };

  static DbBudgetLevel _dbBudget(BudgetLevel value) => switch (value) {
        BudgetLevel.low => DbBudgetLevel.low,
        BudgetLevel.medium => DbBudgetLevel.medium,
        BudgetLevel.high => DbBudgetLevel.high,
      };

  static DietType _dietType(DbDietType value) => switch (value) {
        DbDietType.omnivore => DietType.omnivore,
        DbDietType.vegetarian => DietType.vegetarian,
        DbDietType.vegan => DietType.vegan,
        DbDietType.keto => DietType.keto,
      };

  static DbDietType _dbDietType(DietType value) => switch (value) {
        DietType.omnivore => DbDietType.omnivore,
        DietType.vegetarian => DbDietType.vegetarian,
        DietType.vegan => DbDietType.vegan,
        DietType.keto => DbDietType.keto,
      };
}

