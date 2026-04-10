import 'package:client/data/local/source/preferences_local_source.dart';
import 'package:client/domain/models/enums/budget_level.dart';
import 'package:client/domain/models/enums/diet_type.dart';
import 'package:client/domain/models/user_preferences.dart';

class PreferencesRepository {
  PreferencesRepository(this._local);

  final PreferencesLocalSource _local;

  Future<UserPreferences?> getPreferences() => _local.getPreferences();

  Future<UserPreferences> getOrCreateDefaults() => _local.getOrCreateDefaults();

  Future<void> savePreferences(UserPreferences preferences) =>
      _local.savePreferences(preferences);

  Future<void> updatePreferences(UserPreferences preferences) =>
      _local.updatePreferences(preferences);

  Future<void> saveAllergiesFromOnboarding(List<String> allergies) async {
    final current = await getPreferences();
    if (current == null) {
      await savePreferences(
        UserPreferences(
          id: 0,
          allergies: allergies,
          dislikedProducts: const [],
          likedProducts: const [],
          maxCookingMinutes: 30,
          budget: BudgetLevel.medium,
          dietType: DietType.omnivore,
        ),
      );
    } else {
      await updatePreferences(current.copyWith(allergies: allergies));
    }
  }
}

