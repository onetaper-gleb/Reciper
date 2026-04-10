import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/utils/app_logger.dart';
import 'package:client/core/utils/nutrition_calculator.dart';
import 'package:client/core/utils/onboarding_validators.dart';
import 'package:client/data/repository/preferences_repository.dart';
import 'package:client/data/repository/profile_repository.dart';
import 'package:client/domain/bloc/onboarding/onboarding_event.dart';
import 'package:client/domain/bloc/onboarding/onboarding_state.dart';
import 'package:client/domain/models/enums/goal.dart';
import 'package:client/domain/models/onboarding_draft.dart';
import 'package:client/domain/models/profile.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._repository, this._preferencesRepository)
      : super(const OnboardingEditing(OnboardingDraft())) {
    on<OnboardingDraftUpdated>(_onDraftUpdated);
    on<OnboardingPrepareSummary>(_onPrepareSummary);
    on<OnboardingFinished>(_onFinished);
  }

  final ProfileRepository _repository;
  final PreferencesRepository _preferencesRepository;

  void _onDraftUpdated(
    OnboardingDraftUpdated event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingEditing(event.draft));
  }

  void _onPrepareSummary(
    OnboardingPrepareSummary event,
    Emitter<OnboardingState> emit,
  ) {
    final current = state;
    if (current is! OnboardingEditing) return;
    final d = current.draft;
    final err = _validateForNutrition(d);
    if (err != null) {
      emit(OnboardingEditing(d, errorMessage: err));
      return;
    }
    final nutrition = NutritionCalculator.dailyTargets(
      gender: d.gender!,
      age: d.age!,
      heightCm: d.heightCm!,
      weightKg: d.weightKg!,
      activityLevel: d.activityLevel!,
      goal: d.goal!,
    );
    emit(OnboardingEditing(d, nutritionPreview: nutrition));
  }

  Future<void> _onFinished(
    OnboardingFinished event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingEditing) return;
    final d = current.draft;

    final err = _validateComplete(d);
    if (err != null) {
      emit(OnboardingEditing(d, errorMessage: err));
      return;
    }

    emit(const OnboardingSubmitting());
    try {
      final profile = _buildProfile(d);
      await _repository.saveProfile(profile);
      final allergies = [...d.allergyTags];
      final other = d.allergiesOther.trim();
      if (other.isNotEmpty) allergies.add(other);
      await _preferencesRepository.saveAllergiesFromOnboarding(allergies);
      await _repository.setOnboardingCompleted(true);
      AppLogger.info('OnboardingBloc: finished for ${profile.name}');
      emit(const OnboardingCompleted());
    } catch (e, st) {
      AppLogger.warning('OnboardingBloc: finish failed', e, st);
      emit(
        OnboardingEditing(
          d,
          nutritionPreview: current.nutritionPreview,
          errorMessage: 'Не удалось сохранить профиль. Попробуйте снова.',
        ),
      );
    }
  }

  static String? _validateForNutrition(OnboardingDraft d) {
    if (d.gender == null) return 'Выберите пол';
    if (OnboardingValidators.ageError(d.age) != null) {
      return OnboardingValidators.ageError(d.age);
    }
    if (OnboardingValidators.heightCmError(d.heightCm) != null) {
      return OnboardingValidators.heightCmError(d.heightCm);
    }
    if (OnboardingValidators.weightKgError(d.weightKg) != null) {
      return OnboardingValidators.weightKgError(d.weightKg);
    }
    if (d.goal == null) return 'Выберите цель';
    if (d.activityLevel == null) return 'Выберите уровень активности';
    return null;
  }

  static String? _validateComplete(OnboardingDraft d) {
    final nameErr = OnboardingValidators.nameError(d.name);
    if (nameErr != null) return nameErr;
    return _validateForNutrition(d);
  }

  static Profile _buildProfile(OnboardingDraft d) {
    final weight = d.weightKg!;
    return Profile(
      id: 0,
      name: d.name.trim(),
      gender: d.gender!,
      age: d.age!,
      heightCm: d.heightCm!,
      weightKg: weight,
      targetWeightKg: _targetWeightKg(d.goal!, weight),
      goal: d.goal!,
      activityLevel: d.activityLevel!,
    );
  }

  static double _targetWeightKg(Goal goal, double weightKg) {
    return switch (goal) {
      Goal.loseWeight => (weightKg - 5).clamp(35.0, 250.0),
      Goal.cutting => (weightKg - 3).clamp(35.0, 250.0),
      Goal.maintain => weightKg,
      Goal.gainMuscle => (weightKg + 2).clamp(35.0, 250.0),
    };
  }
}
