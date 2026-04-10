import 'package:flutter_test/flutter_test.dart';

import 'package:client/core/utils/onboarding_validators.dart';

void main() {
  group('OnboardingValidators.name', () {
    test('empty and whitespace fail', () {
      expect(OnboardingValidators.nameError(''), isNotNull);
      expect(OnboardingValidators.nameError('   '), isNotNull);
    });

    test('non-empty passes', () {
      expect(OnboardingValidators.nameError('Анна'), isNull);
    });
  });

  group('OnboardingValidators.age', () {
    test('null and out of range fail', () {
      expect(OnboardingValidators.ageError(null), isNotNull);
      expect(OnboardingValidators.ageError(9), isNotNull);
      expect(OnboardingValidators.ageError(121), isNotNull);
    });

    test('10–120 passes', () {
      expect(OnboardingValidators.ageError(10), isNull);
      expect(OnboardingValidators.ageError(120), isNull);
    });
  });

  group('OnboardingValidators.heightCm', () {
    test('bounds', () {
      expect(OnboardingValidators.heightCmError(null), isNotNull);
      expect(OnboardingValidators.heightCmError(49), isNotNull);
      expect(OnboardingValidators.heightCmError(251), isNotNull);
      expect(OnboardingValidators.heightCmError(170), isNull);
    });
  });

  group('OnboardingValidators.weightKg', () {
    test('bounds', () {
      expect(OnboardingValidators.weightKgError(null), isNotNull);
      expect(OnboardingValidators.weightKgError(0), isNotNull);
      expect(OnboardingValidators.weightKgError(19), isNotNull);
      expect(OnboardingValidators.weightKgError(301), isNotNull);
      expect(OnboardingValidators.weightKgError(75), isNull);
    });
  });
}
