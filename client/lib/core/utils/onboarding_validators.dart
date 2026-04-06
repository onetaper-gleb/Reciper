/// Validation rules for onboarding steps (see Development plan, task 5).
abstract final class OnboardingValidators {
  static String? nameError(String name) {
    if (name.trim().length < 2) {
      return 'Введите имя';
    }
    return null;
  }

  static String? ageError(int? age) {
    if (age == null) return 'Укажите возраст';
    if (age < 10 || age > 120) {
      return 'Возраст от 10 до 120 лет';
    }
    return null;
  }

  static String? heightCmError(double? heightCm) {
    if (heightCm == null) return 'Укажите рост';
    if (heightCm < 50 || heightCm > 250) {
      return 'Рост от 50 до 250 см';
    }
    return null;
  }

  static String? weightKgError(double? weightKg) {
    if (weightKg == null) return 'Укажите вес';
    if (weightKg < 20 || weightKg > 300) {
      return 'Вес от 20 до 300 кг';
    }
    return null;
  }
}
