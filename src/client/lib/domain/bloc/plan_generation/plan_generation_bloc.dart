import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/errors/user_facing_error.dart';
import 'package:client/core/utils/app_logger.dart';
import 'package:client/data/repository/meal_plan_repository.dart';
import 'package:client/data/repository/preferences_repository.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/domain/models/enums/activity_level.dart';
import 'package:client/domain/models/enums/budget_level.dart';
import 'package:client/domain/models/enums/diet_type.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'plan_generation_event.dart';
import 'plan_generation_state.dart';

typedef FridgeProductsJsonLoader = Future<List<Map<String, dynamic>>> Function();

class PlanGenerationBloc extends Bloc<PlanGenerationEvent, PlanGenerationState> {
  PlanGenerationBloc({
    required MealPlanRepository mealPlanRepository,
    required ProfileRepository profileRepository,
    required PreferencesRepository preferencesRepository,
    FridgeProductsJsonLoader? fridgeProductsJsonLoader,
    DateTime? planStartDate,
  })  : _repo = mealPlanRepository,
        _profileRepo = profileRepository,
        _preferencesRepo = preferencesRepository,
        _planStartDate = planStartDate,
        _fridgeProductsJsonLoader =
            fridgeProductsJsonLoader ?? (() async => const <Map<String, dynamic>>[]),
        super(const PlanGenerationStepState(currentStep: 'start', collectedData: {})) {
    on<StepCompleted>(_onStepCompleted);
    on<GenerationRequested>(_onGenerationRequested);
    on<PlanAccepted>(_onAccepted);
    on<PlanRejected>(_onRejected);
  }

  final MealPlanRepository _repo;
  final ProfileRepository _profileRepo;
  final PreferencesRepository _preferencesRepo;
  final FridgeProductsJsonLoader _fridgeProductsJsonLoader;
  final DateTime? _planStartDate;

  Future<void> _onStepCompleted(
    StepCompleted event,
    Emitter<PlanGenerationState> emit,
  ) async {
    final current = state is PlanGenerationStepState
        ? (state as PlanGenerationStepState).collectedData
        : <String, dynamic>{};
    final updated = Map<String, dynamic>.from(current);
    updated[event.stepKey] = event.data;
    emit(PlanGenerationStepState(currentStep: event.stepKey, collectedData: updated));
  }

  Future<void> _onGenerationRequested(
    GenerationRequested event,
    Emitter<PlanGenerationState> emit,
  ) async {
    final collected = state is PlanGenerationStepState
        ? (state as PlanGenerationStepState).collectedData
        : state is PlanGenerationError
            ? (state as PlanGenerationError).collectedData
            : <String, dynamic>{};
    emit(PlanGenerating(collected));
    try {
      final profile = await _profileRepo.getProfile();
      if (profile == null) {
        emit(
          PlanGenerationError(
            'Профиль не заполнен. Пройди онбординг.',
            collectedData: collected,
          ),
        );
        return;
      }

      final prefs = await _preferencesRepo.getPreferences();

      final period = collected['period'] as Map? ?? {};
      final cookWhen = collected['cook_when'] as Map? ?? {};
      final fridgePrefs = collected['fridge'] as Map? ?? {};
      final useFridge = fridgePrefs['use'] == true;
      final fridgeProductsJson =
          useFridge ? await _fridgeProductsJsonLoader() : const <Map<String, dynamic>>[];

      final plan = await _repo.generatePlan(
        profileJson: {
          'gender': profile.gender.name,
          'age': profile.age,
          'height_cm': profile.heightCm,
          'weight_kg': profile.weightKg,
          'target_weight_kg': profile.targetWeightKg,
          'goal': _mapGoal(profile.goal),
          'activity_level': _mapActivity(profile.activityLevel),
        },
        preferencesJson: {
          'diet_type': prefs != null ? _mapDietType(prefs.dietType) : 'regular',
          'allergies': prefs?.allergies ?? const <String>[],
          'disliked_products': prefs?.dislikedProducts ?? const <String>[],
          'favorite_products': prefs?.likedProducts ?? const <String>[],
          'max_cooking_time_min': prefs?.maxCookingMinutes ?? 30,
          'budget_level': prefs != null ? _mapBudget(prefs.budget) : 'medium',
        },
        planOptionsJson: () {
          final opts = <String, dynamic>{
            'days': period['days'] ?? 7,
            'meals_per_day': period['meals_per_day'] ?? 5,
            'cook_when': cookWhen['value'] ?? 'evening',
            'use_fridge_products': useFridge,
          };
          final anchor = _planStartDate;
          if (anchor != null) {
            opts['start_date'] =
                '${anchor.year.toString().padLeft(4, '0')}-'
                '${anchor.month.toString().padLeft(2, '0')}-'
                '${anchor.day.toString().padLeft(2, '0')}';
          }
          return opts;
        }(),
        fridgeProductsJson: fridgeProductsJson,
        additionalNotes: _optionalNotes(collected['notes']),
      );
      emit(PlanGenerated(plan: plan));
    } catch (e, st) {
      AppLogger.warning('PlanGenerationBloc: generation failed', e, st);
      emit(PlanGenerationError(userFacingErrorMessage(e), collectedData: collected));
    }
  }

  String _mapGoal(Goal goal) => switch (goal) {
        Goal.loseWeight => 'weight_loss',
        Goal.maintain => 'maintain',
        Goal.gainMuscle => 'gain_muscle',
        Goal.cutting => 'cutting',
      };

  String _mapActivity(ActivityLevel level) => switch (level) {
        ActivityLevel.sedentary => 'sedentary',
        ActivityLevel.light => 'light',
        ActivityLevel.moderate => 'moderate',
        ActivityLevel.active => 'active',
        ActivityLevel.veryActive => 'very_active',
      };

  String _mapBudget(BudgetLevel level) => switch (level) {
        BudgetLevel.low => 'low',
        BudgetLevel.medium => 'medium',
        BudgetLevel.high => 'high',
      };

  String _mapDietType(DietType type) => switch (type) {
        DietType.omnivore => 'regular',
        DietType.vegetarian => 'vegetarian',
        DietType.vegan => 'vegan',
        DietType.keto => 'keto',
      };

  String? _optionalNotes(dynamic notesEntry) {
    if (notesEntry is! Map) return null;
    final raw = notesEntry['text'];
    if (raw is! String || raw.trim().isEmpty) return null;
    return raw.trim();
  }

  void _onAccepted(PlanAccepted event, Emitter<PlanGenerationState> emit) {
    // UI can navigate away; repository already stored active plan.
  }

  void _onRejected(PlanRejected event, Emitter<PlanGenerationState> emit) {
    final collected = state is PlanGenerated
        ? const <String, dynamic>{}
        : state is PlanGenerating
            ? (state as PlanGenerating).collectedData
            : state is PlanGenerationStepState
                ? (state as PlanGenerationStepState).collectedData
                : <String, dynamic>{};
    emit(PlanGenerationStepState(currentStep: 'start', collectedData: collected));
  }
}

