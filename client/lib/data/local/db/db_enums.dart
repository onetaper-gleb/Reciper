/// Stored as integer indices in SQLite (via Drift type converters).
enum DbGender {
  male,
  female,
}

enum DbGoal {
  loseWeight,
  maintain,
  gainMuscle,
}

enum DbActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive,
}

enum DbMealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

enum DbBudgetLevel {
  low,
  medium,
  high,
}

enum DbDietType {
  omnivore,
  vegetarian,
  vegan,
  keto,
}

enum DbDifficulty {
  easy,
  medium,
  hard,
}
