// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DbGender, int> gender =
      GeneratedColumn<int>(
        'gender',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbGender>($ProfilesTable.$convertergender);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DbGoal, int> goal =
      GeneratedColumn<int>(
        'goal',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbGoal>($ProfilesTable.$convertergoal);
  @override
  late final GeneratedColumnWithTypeConverter<DbActivityLevel, int>
  activityLevel = GeneratedColumn<int>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<DbActivityLevel>($ProfilesTable.$converteractivityLevel);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    age,
    heightCm,
    weightKg,
    targetWeightKg,
    goal,
    activityLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetWeightKgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: $ProfilesTable.$convertergender.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}gender'],
        )!,
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      )!,
      goal: $ProfilesTable.$convertergoal.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}goal'],
        )!,
      ),
      activityLevel: $ProfilesTable.$converteractivityLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}activity_level'],
        )!,
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static TypeConverter<DbGender, int> $convertergender =
      const GenderConverter();
  static TypeConverter<DbGoal, int> $convertergoal = const GoalConverter();
  static TypeConverter<DbActivityLevel, int> $converteractivityLevel =
      const ActivityLevelConverter();
}

class ProfileEntry extends DataClass implements Insertable<ProfileEntry> {
  final int id;
  final String name;
  final DbGender gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final DbGoal goal;
  final DbActivityLevel activityLevel;
  const ProfileEntry({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.goal,
    required this.activityLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['gender'] = Variable<int>(
        $ProfilesTable.$convertergender.toSql(gender),
      );
    }
    map['age'] = Variable<int>(age);
    map['height_cm'] = Variable<double>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['target_weight_kg'] = Variable<double>(targetWeightKg);
    {
      map['goal'] = Variable<int>($ProfilesTable.$convertergoal.toSql(goal));
    }
    {
      map['activity_level'] = Variable<int>(
        $ProfilesTable.$converteractivityLevel.toSql(activityLevel),
      );
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      age: Value(age),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      targetWeightKg: Value(targetWeightKg),
      goal: Value(goal),
      activityLevel: Value(activityLevel),
    );
  }

  factory ProfileEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<DbGender>(json['gender']),
      age: serializer.fromJson<int>(json['age']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      targetWeightKg: serializer.fromJson<double>(json['targetWeightKg']),
      goal: serializer.fromJson<DbGoal>(json['goal']),
      activityLevel: serializer.fromJson<DbActivityLevel>(
        json['activityLevel'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<DbGender>(gender),
      'age': serializer.toJson<int>(age),
      'heightCm': serializer.toJson<double>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'targetWeightKg': serializer.toJson<double>(targetWeightKg),
      'goal': serializer.toJson<DbGoal>(goal),
      'activityLevel': serializer.toJson<DbActivityLevel>(activityLevel),
    };
  }

  ProfileEntry copyWith({
    int? id,
    String? name,
    DbGender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    DbGoal? goal,
    DbActivityLevel? activityLevel,
  }) => ProfileEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender ?? this.gender,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    goal: goal ?? this.goal,
    activityLevel: activityLevel ?? this.activityLevel,
  );
  ProfileEntry copyWithCompanion(ProfilesCompanion data) {
    return ProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      goal: data.goal.present ? data.goal.value : this.goal,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('goal: $goal, ')
          ..write('activityLevel: $activityLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gender,
    age,
    heightCm,
    weightKg,
    targetWeightKg,
    goal,
    activityLevel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.targetWeightKg == this.targetWeightKg &&
          other.goal == this.goal &&
          other.activityLevel == this.activityLevel);
}

class ProfilesCompanion extends UpdateCompanion<ProfileEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<DbGender> gender;
  final Value<int> age;
  final Value<double> heightCm;
  final Value<double> weightKg;
  final Value<double> targetWeightKg;
  final Value<DbGoal> goal;
  final Value<DbActivityLevel> activityLevel;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.goal = const Value.absent(),
    this.activityLevel = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DbGender gender,
    required int age,
    required double heightCm,
    required double weightKg,
    required double targetWeightKg,
    required DbGoal goal,
    required DbActivityLevel activityLevel,
  }) : name = Value(name),
       gender = Value(gender),
       age = Value(age),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       targetWeightKg = Value(targetWeightKg),
       goal = Value(goal),
       activityLevel = Value(activityLevel);
  static Insertable<ProfileEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? gender,
    Expression<int>? age,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<double>? targetWeightKg,
    Expression<int>? goal,
    Expression<int>? activityLevel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (goal != null) 'goal': goal,
      if (activityLevel != null) 'activity_level': activityLevel,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DbGender>? gender,
    Value<int>? age,
    Value<double>? heightCm,
    Value<double>? weightKg,
    Value<double>? targetWeightKg,
    Value<DbGoal>? goal,
    Value<DbActivityLevel>? activityLevel,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(
        $ProfilesTable.$convertergender.toSql(gender.value),
      );
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(
        $ProfilesTable.$convertergoal.toSql(goal.value),
      );
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<int>(
        $ProfilesTable.$converteractivityLevel.toSql(activityLevel.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('goal: $goal, ')
          ..write('activityLevel: $activityLevel')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, PreferencesEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dislikedProductsMeta = const VerificationMeta(
    'dislikedProducts',
  );
  @override
  late final GeneratedColumn<String> dislikedProducts = GeneratedColumn<String>(
    'disliked_products',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _likedProductsMeta = const VerificationMeta(
    'likedProducts',
  );
  @override
  late final GeneratedColumn<String> likedProducts = GeneratedColumn<String>(
    'liked_products',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _maxCookingMinutesMeta = const VerificationMeta(
    'maxCookingMinutes',
  );
  @override
  late final GeneratedColumn<int> maxCookingMinutes = GeneratedColumn<int>(
    'max_cooking_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DbBudgetLevel, int> budget =
      GeneratedColumn<int>(
        'budget',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbBudgetLevel>($PreferencesTable.$converterbudget);
  @override
  late final GeneratedColumnWithTypeConverter<DbDietType, int> dietType =
      GeneratedColumn<int>(
        'diet_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbDietType>($PreferencesTable.$converterdietType);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    allergies,
    dislikedProducts,
    likedProducts,
    maxCookingMinutes,
    budget,
    dietType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<PreferencesEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('disliked_products')) {
      context.handle(
        _dislikedProductsMeta,
        dislikedProducts.isAcceptableOrUnknown(
          data['disliked_products']!,
          _dislikedProductsMeta,
        ),
      );
    }
    if (data.containsKey('liked_products')) {
      context.handle(
        _likedProductsMeta,
        likedProducts.isAcceptableOrUnknown(
          data['liked_products']!,
          _likedProductsMeta,
        ),
      );
    }
    if (data.containsKey('max_cooking_minutes')) {
      context.handle(
        _maxCookingMinutesMeta,
        maxCookingMinutes.isAcceptableOrUnknown(
          data['max_cooking_minutes']!,
          _maxCookingMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      dislikedProducts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disliked_products'],
      )!,
      likedProducts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}liked_products'],
      )!,
      maxCookingMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_cooking_minutes'],
      )!,
      budget: $PreferencesTable.$converterbudget.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}budget'],
        )!,
      ),
      dietType: $PreferencesTable.$converterdietType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}diet_type'],
        )!,
      ),
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }

  static TypeConverter<DbBudgetLevel, int> $converterbudget =
      const BudgetLevelConverter();
  static TypeConverter<DbDietType, int> $converterdietType =
      const DietTypeConverter();
}

class PreferencesEntry extends DataClass
    implements Insertable<PreferencesEntry> {
  final int id;

  /// Comma-separated or JSON string.
  final String allergies;
  final String dislikedProducts;
  final String likedProducts;
  final int maxCookingMinutes;
  final DbBudgetLevel budget;
  final DbDietType dietType;
  const PreferencesEntry({
    required this.id,
    required this.allergies,
    required this.dislikedProducts,
    required this.likedProducts,
    required this.maxCookingMinutes,
    required this.budget,
    required this.dietType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['allergies'] = Variable<String>(allergies);
    map['disliked_products'] = Variable<String>(dislikedProducts);
    map['liked_products'] = Variable<String>(likedProducts);
    map['max_cooking_minutes'] = Variable<int>(maxCookingMinutes);
    {
      map['budget'] = Variable<int>(
        $PreferencesTable.$converterbudget.toSql(budget),
      );
    }
    {
      map['diet_type'] = Variable<int>(
        $PreferencesTable.$converterdietType.toSql(dietType),
      );
    }
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      allergies: Value(allergies),
      dislikedProducts: Value(dislikedProducts),
      likedProducts: Value(likedProducts),
      maxCookingMinutes: Value(maxCookingMinutes),
      budget: Value(budget),
      dietType: Value(dietType),
    );
  }

  factory PreferencesEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesEntry(
      id: serializer.fromJson<int>(json['id']),
      allergies: serializer.fromJson<String>(json['allergies']),
      dislikedProducts: serializer.fromJson<String>(json['dislikedProducts']),
      likedProducts: serializer.fromJson<String>(json['likedProducts']),
      maxCookingMinutes: serializer.fromJson<int>(json['maxCookingMinutes']),
      budget: serializer.fromJson<DbBudgetLevel>(json['budget']),
      dietType: serializer.fromJson<DbDietType>(json['dietType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'allergies': serializer.toJson<String>(allergies),
      'dislikedProducts': serializer.toJson<String>(dislikedProducts),
      'likedProducts': serializer.toJson<String>(likedProducts),
      'maxCookingMinutes': serializer.toJson<int>(maxCookingMinutes),
      'budget': serializer.toJson<DbBudgetLevel>(budget),
      'dietType': serializer.toJson<DbDietType>(dietType),
    };
  }

  PreferencesEntry copyWith({
    int? id,
    String? allergies,
    String? dislikedProducts,
    String? likedProducts,
    int? maxCookingMinutes,
    DbBudgetLevel? budget,
    DbDietType? dietType,
  }) => PreferencesEntry(
    id: id ?? this.id,
    allergies: allergies ?? this.allergies,
    dislikedProducts: dislikedProducts ?? this.dislikedProducts,
    likedProducts: likedProducts ?? this.likedProducts,
    maxCookingMinutes: maxCookingMinutes ?? this.maxCookingMinutes,
    budget: budget ?? this.budget,
    dietType: dietType ?? this.dietType,
  );
  PreferencesEntry copyWithCompanion(PreferencesCompanion data) {
    return PreferencesEntry(
      id: data.id.present ? data.id.value : this.id,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      dislikedProducts: data.dislikedProducts.present
          ? data.dislikedProducts.value
          : this.dislikedProducts,
      likedProducts: data.likedProducts.present
          ? data.likedProducts.value
          : this.likedProducts,
      maxCookingMinutes: data.maxCookingMinutes.present
          ? data.maxCookingMinutes.value
          : this.maxCookingMinutes,
      budget: data.budget.present ? data.budget.value : this.budget,
      dietType: data.dietType.present ? data.dietType.value : this.dietType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesEntry(')
          ..write('id: $id, ')
          ..write('allergies: $allergies, ')
          ..write('dislikedProducts: $dislikedProducts, ')
          ..write('likedProducts: $likedProducts, ')
          ..write('maxCookingMinutes: $maxCookingMinutes, ')
          ..write('budget: $budget, ')
          ..write('dietType: $dietType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    allergies,
    dislikedProducts,
    likedProducts,
    maxCookingMinutes,
    budget,
    dietType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencesEntry &&
          other.id == this.id &&
          other.allergies == this.allergies &&
          other.dislikedProducts == this.dislikedProducts &&
          other.likedProducts == this.likedProducts &&
          other.maxCookingMinutes == this.maxCookingMinutes &&
          other.budget == this.budget &&
          other.dietType == this.dietType);
}

class PreferencesCompanion extends UpdateCompanion<PreferencesEntry> {
  final Value<int> id;
  final Value<String> allergies;
  final Value<String> dislikedProducts;
  final Value<String> likedProducts;
  final Value<int> maxCookingMinutes;
  final Value<DbBudgetLevel> budget;
  final Value<DbDietType> dietType;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.allergies = const Value.absent(),
    this.dislikedProducts = const Value.absent(),
    this.likedProducts = const Value.absent(),
    this.maxCookingMinutes = const Value.absent(),
    this.budget = const Value.absent(),
    this.dietType = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.allergies = const Value.absent(),
    this.dislikedProducts = const Value.absent(),
    this.likedProducts = const Value.absent(),
    this.maxCookingMinutes = const Value.absent(),
    required DbBudgetLevel budget,
    required DbDietType dietType,
  }) : budget = Value(budget),
       dietType = Value(dietType);
  static Insertable<PreferencesEntry> custom({
    Expression<int>? id,
    Expression<String>? allergies,
    Expression<String>? dislikedProducts,
    Expression<String>? likedProducts,
    Expression<int>? maxCookingMinutes,
    Expression<int>? budget,
    Expression<int>? dietType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (allergies != null) 'allergies': allergies,
      if (dislikedProducts != null) 'disliked_products': dislikedProducts,
      if (likedProducts != null) 'liked_products': likedProducts,
      if (maxCookingMinutes != null) 'max_cooking_minutes': maxCookingMinutes,
      if (budget != null) 'budget': budget,
      if (dietType != null) 'diet_type': dietType,
    });
  }

  PreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? allergies,
    Value<String>? dislikedProducts,
    Value<String>? likedProducts,
    Value<int>? maxCookingMinutes,
    Value<DbBudgetLevel>? budget,
    Value<DbDietType>? dietType,
  }) {
    return PreferencesCompanion(
      id: id ?? this.id,
      allergies: allergies ?? this.allergies,
      dislikedProducts: dislikedProducts ?? this.dislikedProducts,
      likedProducts: likedProducts ?? this.likedProducts,
      maxCookingMinutes: maxCookingMinutes ?? this.maxCookingMinutes,
      budget: budget ?? this.budget,
      dietType: dietType ?? this.dietType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (dislikedProducts.present) {
      map['disliked_products'] = Variable<String>(dislikedProducts.value);
    }
    if (likedProducts.present) {
      map['liked_products'] = Variable<String>(likedProducts.value);
    }
    if (maxCookingMinutes.present) {
      map['max_cooking_minutes'] = Variable<int>(maxCookingMinutes.value);
    }
    if (budget.present) {
      map['budget'] = Variable<int>(
        $PreferencesTable.$converterbudget.toSql(budget.value),
      );
    }
    if (dietType.present) {
      map['diet_type'] = Variable<int>(
        $PreferencesTable.$converterdietType.toSql(dietType.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('allergies: $allergies, ')
          ..write('dislikedProducts: $dislikedProducts, ')
          ..write('likedProducts: $likedProducts, ')
          ..write('maxCookingMinutes: $maxCookingMinutes, ')
          ..write('budget: $budget, ')
          ..write('dietType: $dietType')
          ..write(')'))
        .toString();
  }
}

class $MealPlansTable extends MealPlans
    with TableInfo<$MealPlansTable, MealPlanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DbGoal, int> goal =
      GeneratedColumn<int>(
        'goal',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbGoal>($MealPlansTable.$convertergoal);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    goal,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPlanEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      goal: $MealPlansTable.$convertergoal.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}goal'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealPlansTable createAlias(String alias) {
    return $MealPlansTable(attachedDatabase, alias);
  }

  static TypeConverter<DbGoal, int> $convertergoal = const GoalConverter();
}

class MealPlanEntry extends DataClass implements Insertable<MealPlanEntry> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final DbGoal goal;
  final bool isActive;
  final DateTime createdAt;
  const MealPlanEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.goal,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    {
      map['goal'] = Variable<int>($MealPlansTable.$convertergoal.toSql(goal));
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealPlansCompanion toCompanion(bool nullToAbsent) {
    return MealPlansCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      goal: Value(goal),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory MealPlanEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanEntry(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      goal: serializer.fromJson<DbGoal>(json['goal']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'goal': serializer.toJson<DbGoal>(goal),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MealPlanEntry copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    DbGoal? goal,
    bool? isActive,
    DateTime? createdAt,
  }) => MealPlanEntry(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    goal: goal ?? this.goal,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  MealPlanEntry copyWithCompanion(MealPlansCompanion data) {
    return MealPlanEntry(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      goal: data.goal.present ? data.goal.value : this.goal,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntry(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('goal: $goal, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startDate, endDate, goal, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanEntry &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.goal == this.goal &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class MealPlansCompanion extends UpdateCompanion<MealPlanEntry> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DbGoal> goal;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const MealPlansCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.goal = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealPlansCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required DbGoal goal,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       goal = Value(goal),
       createdAt = Value(createdAt);
  static Insertable<MealPlanEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? goal,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (goal != null) 'goal': goal,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealPlansCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<DbGoal>? goal,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return MealPlansCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      goal: goal ?? this.goal,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(
        $MealPlansTable.$convertergoal.toSql(goal.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlansCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('goal: $goal, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookingTimeMinutesMeta =
      const VerificationMeta('cookingTimeMinutes');
  @override
  late final GeneratedColumn<int> cookingTimeMinutes = GeneratedColumn<int>(
    'cooking_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DbDifficulty, int> difficulty =
      GeneratedColumn<int>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbDifficulty>($RecipesTable.$converterdifficulty);
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGMeta = const VerificationMeta(
    'proteinG',
  );
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
    'protein_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
    'fat_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
    'carbs_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _stepsJsonMeta = const VerificationMeta(
    'stepsJson',
  );
  @override
  late final GeneratedColumn<String> stepsJson = GeneratedColumn<String>(
    'steps_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    cookingTimeMinutes,
    difficulty,
    servings,
    calories,
    proteinG,
    fatG,
    carbsG,
    isFavorite,
    stepsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('cooking_time_minutes')) {
      context.handle(
        _cookingTimeMinutesMeta,
        cookingTimeMinutes.isAcceptableOrUnknown(
          data['cooking_time_minutes']!,
          _cookingTimeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cookingTimeMinutesMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    } else if (isInserting) {
      context.missing(_servingsMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(
        _proteinGMeta,
        proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinGMeta);
    }
    if (data.containsKey('fat_g')) {
      context.handle(
        _fatGMeta,
        fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGMeta);
    }
    if (data.containsKey('carbs_g')) {
      context.handle(
        _carbsGMeta,
        carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('steps_json')) {
      context.handle(
        _stepsJsonMeta,
        stepsJson.isAcceptableOrUnknown(data['steps_json']!, _stepsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      cookingTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cooking_time_minutes'],
      )!,
      difficulty: $RecipesTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      proteinG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_g'],
      )!,
      fatG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_g'],
      )!,
      carbsG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_g'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      stepsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}steps_json'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static TypeConverter<DbDifficulty, int> $converterdifficulty =
      const DifficultyConverter();
}

class RecipeEntry extends DataClass implements Insertable<RecipeEntry> {
  final int id;
  final String title;
  final int cookingTimeMinutes;
  final DbDifficulty difficulty;
  final int servings;
  final double calories;
  final double proteinG;
  final double fatG;
  final double carbsG;
  final bool isFavorite;
  final String stepsJson;
  const RecipeEntry({
    required this.id,
    required this.title,
    required this.cookingTimeMinutes,
    required this.difficulty,
    required this.servings,
    required this.calories,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
    required this.isFavorite,
    required this.stepsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['cooking_time_minutes'] = Variable<int>(cookingTimeMinutes);
    {
      map['difficulty'] = Variable<int>(
        $RecipesTable.$converterdifficulty.toSql(difficulty),
      );
    }
    map['servings'] = Variable<int>(servings);
    map['calories'] = Variable<double>(calories);
    map['protein_g'] = Variable<double>(proteinG);
    map['fat_g'] = Variable<double>(fatG);
    map['carbs_g'] = Variable<double>(carbsG);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['steps_json'] = Variable<String>(stepsJson);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      title: Value(title),
      cookingTimeMinutes: Value(cookingTimeMinutes),
      difficulty: Value(difficulty),
      servings: Value(servings),
      calories: Value(calories),
      proteinG: Value(proteinG),
      fatG: Value(fatG),
      carbsG: Value(carbsG),
      isFavorite: Value(isFavorite),
      stepsJson: Value(stepsJson),
    );
  }

  factory RecipeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      cookingTimeMinutes: serializer.fromJson<int>(json['cookingTimeMinutes']),
      difficulty: serializer.fromJson<DbDifficulty>(json['difficulty']),
      servings: serializer.fromJson<int>(json['servings']),
      calories: serializer.fromJson<double>(json['calories']),
      proteinG: serializer.fromJson<double>(json['proteinG']),
      fatG: serializer.fromJson<double>(json['fatG']),
      carbsG: serializer.fromJson<double>(json['carbsG']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      stepsJson: serializer.fromJson<String>(json['stepsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'cookingTimeMinutes': serializer.toJson<int>(cookingTimeMinutes),
      'difficulty': serializer.toJson<DbDifficulty>(difficulty),
      'servings': serializer.toJson<int>(servings),
      'calories': serializer.toJson<double>(calories),
      'proteinG': serializer.toJson<double>(proteinG),
      'fatG': serializer.toJson<double>(fatG),
      'carbsG': serializer.toJson<double>(carbsG),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'stepsJson': serializer.toJson<String>(stepsJson),
    };
  }

  RecipeEntry copyWith({
    int? id,
    String? title,
    int? cookingTimeMinutes,
    DbDifficulty? difficulty,
    int? servings,
    double? calories,
    double? proteinG,
    double? fatG,
    double? carbsG,
    bool? isFavorite,
    String? stepsJson,
  }) => RecipeEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    cookingTimeMinutes: cookingTimeMinutes ?? this.cookingTimeMinutes,
    difficulty: difficulty ?? this.difficulty,
    servings: servings ?? this.servings,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    fatG: fatG ?? this.fatG,
    carbsG: carbsG ?? this.carbsG,
    isFavorite: isFavorite ?? this.isFavorite,
    stepsJson: stepsJson ?? this.stepsJson,
  );
  RecipeEntry copyWithCompanion(RecipesCompanion data) {
    return RecipeEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      cookingTimeMinutes: data.cookingTimeMinutes.present
          ? data.cookingTimeMinutes.value
          : this.cookingTimeMinutes,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      servings: data.servings.present ? data.servings.value : this.servings,
      calories: data.calories.present ? data.calories.value : this.calories,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      stepsJson: data.stepsJson.present ? data.stepsJson.value : this.stepsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('cookingTimeMinutes: $cookingTimeMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('servings: $servings, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('fatG: $fatG, ')
          ..write('carbsG: $carbsG, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('stepsJson: $stepsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    cookingTimeMinutes,
    difficulty,
    servings,
    calories,
    proteinG,
    fatG,
    carbsG,
    isFavorite,
    stepsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.cookingTimeMinutes == this.cookingTimeMinutes &&
          other.difficulty == this.difficulty &&
          other.servings == this.servings &&
          other.calories == this.calories &&
          other.proteinG == this.proteinG &&
          other.fatG == this.fatG &&
          other.carbsG == this.carbsG &&
          other.isFavorite == this.isFavorite &&
          other.stepsJson == this.stepsJson);
}

class RecipesCompanion extends UpdateCompanion<RecipeEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> cookingTimeMinutes;
  final Value<DbDifficulty> difficulty;
  final Value<int> servings;
  final Value<double> calories;
  final Value<double> proteinG;
  final Value<double> fatG;
  final Value<double> carbsG;
  final Value<bool> isFavorite;
  final Value<String> stepsJson;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.cookingTimeMinutes = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.servings = const Value.absent(),
    this.calories = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.stepsJson = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int cookingTimeMinutes,
    required DbDifficulty difficulty,
    required int servings,
    required double calories,
    required double proteinG,
    required double fatG,
    required double carbsG,
    this.isFavorite = const Value.absent(),
    required String stepsJson,
  }) : title = Value(title),
       cookingTimeMinutes = Value(cookingTimeMinutes),
       difficulty = Value(difficulty),
       servings = Value(servings),
       calories = Value(calories),
       proteinG = Value(proteinG),
       fatG = Value(fatG),
       carbsG = Value(carbsG),
       stepsJson = Value(stepsJson);
  static Insertable<RecipeEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? cookingTimeMinutes,
    Expression<int>? difficulty,
    Expression<int>? servings,
    Expression<double>? calories,
    Expression<double>? proteinG,
    Expression<double>? fatG,
    Expression<double>? carbsG,
    Expression<bool>? isFavorite,
    Expression<String>? stepsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (cookingTimeMinutes != null)
        'cooking_time_minutes': cookingTimeMinutes,
      if (difficulty != null) 'difficulty': difficulty,
      if (servings != null) 'servings': servings,
      if (calories != null) 'calories': calories,
      if (proteinG != null) 'protein_g': proteinG,
      if (fatG != null) 'fat_g': fatG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (stepsJson != null) 'steps_json': stepsJson,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? cookingTimeMinutes,
    Value<DbDifficulty>? difficulty,
    Value<int>? servings,
    Value<double>? calories,
    Value<double>? proteinG,
    Value<double>? fatG,
    Value<double>? carbsG,
    Value<bool>? isFavorite,
    Value<String>? stepsJson,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      cookingTimeMinutes: cookingTimeMinutes ?? this.cookingTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      fatG: fatG ?? this.fatG,
      carbsG: carbsG ?? this.carbsG,
      isFavorite: isFavorite ?? this.isFavorite,
      stepsJson: stepsJson ?? this.stepsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (cookingTimeMinutes.present) {
      map['cooking_time_minutes'] = Variable<int>(cookingTimeMinutes.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(
        $RecipesTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (stepsJson.present) {
      map['steps_json'] = Variable<String>(stepsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('cookingTimeMinutes: $cookingTimeMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('servings: $servings, ')
          ..write('calories: $calories, ')
          ..write('proteinG: $proteinG, ')
          ..write('fatG: $fatG, ')
          ..write('carbsG: $carbsG, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('stepsJson: $stepsJson')
          ..write(')'))
        .toString();
  }
}

class $DayPlansTable extends DayPlans
    with TableInfo<$DayPlansTable, DayPlanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealPlanIdMeta = const VerificationMeta(
    'mealPlanId',
  );
  @override
  late final GeneratedColumn<int> mealPlanId = GeneratedColumn<int>(
    'meal_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_plans (id)',
    ),
  );
  static const VerificationMeta _planDateMeta = const VerificationMeta(
    'planDate',
  );
  @override
  late final GeneratedColumn<DateTime> planDate = GeneratedColumn<DateTime>(
    'plan_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mealPlanId, planDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayPlanEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_plan_id')) {
      context.handle(
        _mealPlanIdMeta,
        mealPlanId.isAcceptableOrUnknown(
          data['meal_plan_id']!,
          _mealPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    if (data.containsKey('plan_date')) {
      context.handle(
        _planDateMeta,
        planDate.isAcceptableOrUnknown(data['plan_date']!, _planDateMeta),
      );
    } else if (isInserting) {
      context.missing(_planDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayPlanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayPlanEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_plan_id'],
      )!,
      planDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}plan_date'],
      )!,
    );
  }

  @override
  $DayPlansTable createAlias(String alias) {
    return $DayPlansTable(attachedDatabase, alias);
  }
}

class DayPlanEntry extends DataClass implements Insertable<DayPlanEntry> {
  final int id;
  final int mealPlanId;
  final DateTime planDate;
  const DayPlanEntry({
    required this.id,
    required this.mealPlanId,
    required this.planDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_plan_id'] = Variable<int>(mealPlanId);
    map['plan_date'] = Variable<DateTime>(planDate);
    return map;
  }

  DayPlansCompanion toCompanion(bool nullToAbsent) {
    return DayPlansCompanion(
      id: Value(id),
      mealPlanId: Value(mealPlanId),
      planDate: Value(planDate),
    );
  }

  factory DayPlanEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayPlanEntry(
      id: serializer.fromJson<int>(json['id']),
      mealPlanId: serializer.fromJson<int>(json['mealPlanId']),
      planDate: serializer.fromJson<DateTime>(json['planDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealPlanId': serializer.toJson<int>(mealPlanId),
      'planDate': serializer.toJson<DateTime>(planDate),
    };
  }

  DayPlanEntry copyWith({int? id, int? mealPlanId, DateTime? planDate}) =>
      DayPlanEntry(
        id: id ?? this.id,
        mealPlanId: mealPlanId ?? this.mealPlanId,
        planDate: planDate ?? this.planDate,
      );
  DayPlanEntry copyWithCompanion(DayPlansCompanion data) {
    return DayPlanEntry(
      id: data.id.present ? data.id.value : this.id,
      mealPlanId: data.mealPlanId.present
          ? data.mealPlanId.value
          : this.mealPlanId,
      planDate: data.planDate.present ? data.planDate.value : this.planDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayPlanEntry(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('planDate: $planDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealPlanId, planDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayPlanEntry &&
          other.id == this.id &&
          other.mealPlanId == this.mealPlanId &&
          other.planDate == this.planDate);
}

class DayPlansCompanion extends UpdateCompanion<DayPlanEntry> {
  final Value<int> id;
  final Value<int> mealPlanId;
  final Value<DateTime> planDate;
  const DayPlansCompanion({
    this.id = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.planDate = const Value.absent(),
  });
  DayPlansCompanion.insert({
    this.id = const Value.absent(),
    required int mealPlanId,
    required DateTime planDate,
  }) : mealPlanId = Value(mealPlanId),
       planDate = Value(planDate);
  static Insertable<DayPlanEntry> custom({
    Expression<int>? id,
    Expression<int>? mealPlanId,
    Expression<DateTime>? planDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (planDate != null) 'plan_date': planDate,
    });
  }

  DayPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? mealPlanId,
    Value<DateTime>? planDate,
  }) {
    return DayPlansCompanion(
      id: id ?? this.id,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      planDate: planDate ?? this.planDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<int>(mealPlanId.value);
    }
    if (planDate.present) {
      map['plan_date'] = Variable<DateTime>(planDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayPlansCompanion(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('planDate: $planDate')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, MealEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayPlanIdMeta = const VerificationMeta(
    'dayPlanId',
  );
  @override
  late final GeneratedColumn<int> dayPlanId = GeneratedColumn<int>(
    'day_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES day_plans (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DbMealType, int> mealType =
      GeneratedColumn<int>(
        'meal_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DbMealType>($MealsTable.$convertermealType);
  static const VerificationMeta _mealTimeMeta = const VerificationMeta(
    'mealTime',
  );
  @override
  late final GeneratedColumn<DateTime> mealTime = GeneratedColumn<DateTime>(
    'meal_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayPlanId,
    mealType,
    mealTime,
    recipeId,
    isDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_plan_id')) {
      context.handle(
        _dayPlanIdMeta,
        dayPlanId.isAcceptableOrUnknown(data['day_plan_id']!, _dayPlanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayPlanIdMeta);
    }
    if (data.containsKey('meal_time')) {
      context.handle(
        _mealTimeMeta,
        mealTime.isAcceptableOrUnknown(data['meal_time']!, _mealTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTimeMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_plan_id'],
      )!,
      mealType: $MealsTable.$convertermealType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}meal_type'],
        )!,
      ),
      mealTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}meal_time'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }

  static TypeConverter<DbMealType, int> $convertermealType =
      const MealTypeConverter();
}

class MealEntry extends DataClass implements Insertable<MealEntry> {
  final int id;
  final int dayPlanId;
  final DbMealType mealType;
  final DateTime mealTime;
  final int recipeId;
  final bool isDone;
  const MealEntry({
    required this.id,
    required this.dayPlanId,
    required this.mealType,
    required this.mealTime,
    required this.recipeId,
    required this.isDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_plan_id'] = Variable<int>(dayPlanId);
    {
      map['meal_type'] = Variable<int>(
        $MealsTable.$convertermealType.toSql(mealType),
      );
    }
    map['meal_time'] = Variable<DateTime>(mealTime);
    map['recipe_id'] = Variable<int>(recipeId);
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      dayPlanId: Value(dayPlanId),
      mealType: Value(mealType),
      mealTime: Value(mealTime),
      recipeId: Value(recipeId),
      isDone: Value(isDone),
    );
  }

  factory MealEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealEntry(
      id: serializer.fromJson<int>(json['id']),
      dayPlanId: serializer.fromJson<int>(json['dayPlanId']),
      mealType: serializer.fromJson<DbMealType>(json['mealType']),
      mealTime: serializer.fromJson<DateTime>(json['mealTime']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayPlanId': serializer.toJson<int>(dayPlanId),
      'mealType': serializer.toJson<DbMealType>(mealType),
      'mealTime': serializer.toJson<DateTime>(mealTime),
      'recipeId': serializer.toJson<int>(recipeId),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  MealEntry copyWith({
    int? id,
    int? dayPlanId,
    DbMealType? mealType,
    DateTime? mealTime,
    int? recipeId,
    bool? isDone,
  }) => MealEntry(
    id: id ?? this.id,
    dayPlanId: dayPlanId ?? this.dayPlanId,
    mealType: mealType ?? this.mealType,
    mealTime: mealTime ?? this.mealTime,
    recipeId: recipeId ?? this.recipeId,
    isDone: isDone ?? this.isDone,
  );
  MealEntry copyWithCompanion(MealsCompanion data) {
    return MealEntry(
      id: data.id.present ? data.id.value : this.id,
      dayPlanId: data.dayPlanId.present ? data.dayPlanId.value : this.dayPlanId,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      mealTime: data.mealTime.present ? data.mealTime.value : this.mealTime,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealEntry(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('mealType: $mealType, ')
          ..write('mealTime: $mealTime, ')
          ..write('recipeId: $recipeId, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayPlanId, mealType, mealTime, recipeId, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealEntry &&
          other.id == this.id &&
          other.dayPlanId == this.dayPlanId &&
          other.mealType == this.mealType &&
          other.mealTime == this.mealTime &&
          other.recipeId == this.recipeId &&
          other.isDone == this.isDone);
}

class MealsCompanion extends UpdateCompanion<MealEntry> {
  final Value<int> id;
  final Value<int> dayPlanId;
  final Value<DbMealType> mealType;
  final Value<DateTime> mealTime;
  final Value<int> recipeId;
  final Value<bool> isDone;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.dayPlanId = const Value.absent(),
    this.mealType = const Value.absent(),
    this.mealTime = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required int dayPlanId,
    required DbMealType mealType,
    required DateTime mealTime,
    required int recipeId,
    this.isDone = const Value.absent(),
  }) : dayPlanId = Value(dayPlanId),
       mealType = Value(mealType),
       mealTime = Value(mealTime),
       recipeId = Value(recipeId);
  static Insertable<MealEntry> custom({
    Expression<int>? id,
    Expression<int>? dayPlanId,
    Expression<int>? mealType,
    Expression<DateTime>? mealTime,
    Expression<int>? recipeId,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayPlanId != null) 'day_plan_id': dayPlanId,
      if (mealType != null) 'meal_type': mealType,
      if (mealTime != null) 'meal_time': mealTime,
      if (recipeId != null) 'recipe_id': recipeId,
      if (isDone != null) 'is_done': isDone,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<int>? dayPlanId,
    Value<DbMealType>? mealType,
    Value<DateTime>? mealTime,
    Value<int>? recipeId,
    Value<bool>? isDone,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      dayPlanId: dayPlanId ?? this.dayPlanId,
      mealType: mealType ?? this.mealType,
      mealTime: mealTime ?? this.mealTime,
      recipeId: recipeId ?? this.recipeId,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayPlanId.present) {
      map['day_plan_id'] = Variable<int>(dayPlanId.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<int>(
        $MealsTable.$convertermealType.toSql(mealType.value),
      );
    }
    if (mealTime.present) {
      map['meal_time'] = Variable<DateTime>(mealTime.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('mealType: $mealType, ')
          ..write('mealTime: $mealTime, ')
          ..write('recipeId: $recipeId, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, IngredientEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    name,
    amount,
    unit,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class IngredientEntry extends DataClass implements Insertable<IngredientEntry> {
  final int id;
  final int recipeId;
  final String name;
  final double amount;
  final String unit;
  final String category;
  const IngredientEntry({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    map['category'] = Variable<String>(category);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      name: Value(name),
      amount: Value(amount),
      unit: Value(unit),
      category: Value(category),
    );
  }

  factory IngredientEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientEntry(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String>(category),
    };
  }

  IngredientEntry copyWith({
    int? id,
    int? recipeId,
    String? name,
    double? amount,
    String? unit,
    String? category,
  }) => IngredientEntry(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    category: category ?? this.category,
  );
  IngredientEntry copyWithCompanion(IngredientsCompanion data) {
    return IngredientEntry(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientEntry(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, name, amount, unit, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientEntry &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.category == this.category);
}

class IngredientsCompanion extends UpdateCompanion<IngredientEntry> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> unit;
  final Value<String> category;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required String name,
    required double amount,
    required String unit,
    required String category,
  }) : recipeId = Value(recipeId),
       name = Value(name),
       amount = Value(amount),
       unit = Value(unit),
       category = Value(category);
  static Insertable<IngredientEntry> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
    });
  }

  IngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<String>? name,
    Value<double>? amount,
    Value<String>? unit,
    Value<String>? category,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $FridgeProductsTable extends FridgeProducts
    with TableInfo<$FridgeProductsTable, FridgeProductEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FridgeProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    amount,
    unit,
    category,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fridge_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<FridgeProductEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FridgeProductEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FridgeProductEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FridgeProductsTable createAlias(String alias) {
    return $FridgeProductsTable(attachedDatabase, alias);
  }
}

class FridgeProductEntry extends DataClass
    implements Insertable<FridgeProductEntry> {
  final int id;
  final String name;
  final double amount;
  final String unit;
  final String category;
  final DateTime addedAt;
  const FridgeProductEntry({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    map['category'] = Variable<String>(category);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FridgeProductsCompanion toCompanion(bool nullToAbsent) {
    return FridgeProductsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      unit: Value(unit),
      category: Value(category),
      addedAt: Value(addedAt),
    );
  }

  factory FridgeProductEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FridgeProductEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String>(json['category']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String>(category),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  FridgeProductEntry copyWith({
    int? id,
    String? name,
    double? amount,
    String? unit,
    String? category,
    DateTime? addedAt,
  }) => FridgeProductEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    category: category ?? this.category,
    addedAt: addedAt ?? this.addedAt,
  );
  FridgeProductEntry copyWithCompanion(FridgeProductsCompanion data) {
    return FridgeProductEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FridgeProductEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, unit, category, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FridgeProductEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.addedAt == this.addedAt);
}

class FridgeProductsCompanion extends UpdateCompanion<FridgeProductEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> unit;
  final Value<String> category;
  final Value<DateTime> addedAt;
  const FridgeProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  FridgeProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double amount,
    required String unit,
    required String category,
    required DateTime addedAt,
  }) : name = Value(name),
       amount = Value(amount),
       unit = Value(unit),
       category = Value(category),
       addedAt = Value(addedAt);
  static Insertable<FridgeProductEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  FridgeProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? amount,
    Value<String>? unit,
    Value<String>? category,
    Value<DateTime>? addedAt,
  }) {
    return FridgeProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FridgeProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $FridgeScansTable extends FridgeScans
    with TableInfo<$FridgeScansTable, FridgeScanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FridgeScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scanDateMeta = const VerificationMeta(
    'scanDate',
  );
  @override
  late final GeneratedColumn<DateTime> scanDate = GeneratedColumn<DateTime>(
    'scan_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productCountMeta = const VerificationMeta(
    'productCount',
  );
  @override
  late final GeneratedColumn<int> productCount = GeneratedColumn<int>(
    'product_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, photoPath, scanDate, productCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fridge_scans';
  @override
  VerificationContext validateIntegrity(
    Insertable<FridgeScanEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('scan_date')) {
      context.handle(
        _scanDateMeta,
        scanDate.isAcceptableOrUnknown(data['scan_date']!, _scanDateMeta),
      );
    } else if (isInserting) {
      context.missing(_scanDateMeta);
    }
    if (data.containsKey('product_count')) {
      context.handle(
        _productCountMeta,
        productCount.isAcceptableOrUnknown(
          data['product_count']!,
          _productCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FridgeScanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FridgeScanEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      )!,
      scanDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scan_date'],
      )!,
      productCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_count'],
      )!,
    );
  }

  @override
  $FridgeScansTable createAlias(String alias) {
    return $FridgeScansTable(attachedDatabase, alias);
  }
}

class FridgeScanEntry extends DataClass implements Insertable<FridgeScanEntry> {
  final int id;
  final String photoPath;
  final DateTime scanDate;
  final int productCount;
  const FridgeScanEntry({
    required this.id,
    required this.photoPath,
    required this.scanDate,
    required this.productCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['photo_path'] = Variable<String>(photoPath);
    map['scan_date'] = Variable<DateTime>(scanDate);
    map['product_count'] = Variable<int>(productCount);
    return map;
  }

  FridgeScansCompanion toCompanion(bool nullToAbsent) {
    return FridgeScansCompanion(
      id: Value(id),
      photoPath: Value(photoPath),
      scanDate: Value(scanDate),
      productCount: Value(productCount),
    );
  }

  factory FridgeScanEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FridgeScanEntry(
      id: serializer.fromJson<int>(json['id']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      scanDate: serializer.fromJson<DateTime>(json['scanDate']),
      productCount: serializer.fromJson<int>(json['productCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'photoPath': serializer.toJson<String>(photoPath),
      'scanDate': serializer.toJson<DateTime>(scanDate),
      'productCount': serializer.toJson<int>(productCount),
    };
  }

  FridgeScanEntry copyWith({
    int? id,
    String? photoPath,
    DateTime? scanDate,
    int? productCount,
  }) => FridgeScanEntry(
    id: id ?? this.id,
    photoPath: photoPath ?? this.photoPath,
    scanDate: scanDate ?? this.scanDate,
    productCount: productCount ?? this.productCount,
  );
  FridgeScanEntry copyWithCompanion(FridgeScansCompanion data) {
    return FridgeScanEntry(
      id: data.id.present ? data.id.value : this.id,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      scanDate: data.scanDate.present ? data.scanDate.value : this.scanDate,
      productCount: data.productCount.present
          ? data.productCount.value
          : this.productCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FridgeScanEntry(')
          ..write('id: $id, ')
          ..write('photoPath: $photoPath, ')
          ..write('scanDate: $scanDate, ')
          ..write('productCount: $productCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, photoPath, scanDate, productCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FridgeScanEntry &&
          other.id == this.id &&
          other.photoPath == this.photoPath &&
          other.scanDate == this.scanDate &&
          other.productCount == this.productCount);
}

class FridgeScansCompanion extends UpdateCompanion<FridgeScanEntry> {
  final Value<int> id;
  final Value<String> photoPath;
  final Value<DateTime> scanDate;
  final Value<int> productCount;
  const FridgeScansCompanion({
    this.id = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.scanDate = const Value.absent(),
    this.productCount = const Value.absent(),
  });
  FridgeScansCompanion.insert({
    this.id = const Value.absent(),
    required String photoPath,
    required DateTime scanDate,
    this.productCount = const Value.absent(),
  }) : photoPath = Value(photoPath),
       scanDate = Value(scanDate);
  static Insertable<FridgeScanEntry> custom({
    Expression<int>? id,
    Expression<String>? photoPath,
    Expression<DateTime>? scanDate,
    Expression<int>? productCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (photoPath != null) 'photo_path': photoPath,
      if (scanDate != null) 'scan_date': scanDate,
      if (productCount != null) 'product_count': productCount,
    });
  }

  FridgeScansCompanion copyWith({
    Value<int>? id,
    Value<String>? photoPath,
    Value<DateTime>? scanDate,
    Value<int>? productCount,
  }) {
    return FridgeScansCompanion(
      id: id ?? this.id,
      photoPath: photoPath ?? this.photoPath,
      scanDate: scanDate ?? this.scanDate,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (scanDate.present) {
      map['scan_date'] = Variable<DateTime>(scanDate.value);
    }
    if (productCount.present) {
      map['product_count'] = Variable<int>(productCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FridgeScansCompanion(')
          ..write('id: $id, ')
          ..write('photoPath: $photoPath, ')
          ..write('scanDate: $scanDate, ')
          ..write('productCount: $productCount')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingListEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealPlanIdMeta = const VerificationMeta(
    'mealPlanId',
  );
  @override
  late final GeneratedColumn<int> mealPlanId = GeneratedColumn<int>(
    'meal_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_plans (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasedMeta = const VerificationMeta(
    'purchased',
  );
  @override
  late final GeneratedColumn<bool> purchased = GeneratedColumn<bool>(
    'purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("purchased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _inFridgeMeta = const VerificationMeta(
    'inFridge',
  );
  @override
  late final GeneratedColumn<bool> inFridge = GeneratedColumn<bool>(
    'in_fridge',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_fridge" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mealPlanId,
    name,
    amount,
    unit,
    category,
    purchased,
    inFridge,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingListEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_plan_id')) {
      context.handle(
        _mealPlanIdMeta,
        mealPlanId.isAcceptableOrUnknown(
          data['meal_plan_id']!,
          _mealPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealPlanIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('purchased')) {
      context.handle(
        _purchasedMeta,
        purchased.isAcceptableOrUnknown(data['purchased']!, _purchasedMeta),
      );
    }
    if (data.containsKey('in_fridge')) {
      context.handle(
        _inFridgeMeta,
        inFridge.isAcceptableOrUnknown(data['in_fridge']!, _inFridgeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingListEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingListEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_plan_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      purchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}purchased'],
      )!,
      inFridge: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_fridge'],
      )!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingListEntry extends DataClass
    implements Insertable<ShoppingListEntry> {
  final int id;
  final int mealPlanId;
  final String name;
  final double amount;
  final String unit;
  final String category;
  final bool purchased;
  final bool inFridge;
  const ShoppingListEntry({
    required this.id,
    required this.mealPlanId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    required this.purchased,
    required this.inFridge,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_plan_id'] = Variable<int>(mealPlanId);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    map['category'] = Variable<String>(category);
    map['purchased'] = Variable<bool>(purchased);
    map['in_fridge'] = Variable<bool>(inFridge);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      mealPlanId: Value(mealPlanId),
      name: Value(name),
      amount: Value(amount),
      unit: Value(unit),
      category: Value(category),
      purchased: Value(purchased),
      inFridge: Value(inFridge),
    );
  }

  factory ShoppingListEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingListEntry(
      id: serializer.fromJson<int>(json['id']),
      mealPlanId: serializer.fromJson<int>(json['mealPlanId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String>(json['category']),
      purchased: serializer.fromJson<bool>(json['purchased']),
      inFridge: serializer.fromJson<bool>(json['inFridge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealPlanId': serializer.toJson<int>(mealPlanId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String>(category),
      'purchased': serializer.toJson<bool>(purchased),
      'inFridge': serializer.toJson<bool>(inFridge),
    };
  }

  ShoppingListEntry copyWith({
    int? id,
    int? mealPlanId,
    String? name,
    double? amount,
    String? unit,
    String? category,
    bool? purchased,
    bool? inFridge,
  }) => ShoppingListEntry(
    id: id ?? this.id,
    mealPlanId: mealPlanId ?? this.mealPlanId,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    category: category ?? this.category,
    purchased: purchased ?? this.purchased,
    inFridge: inFridge ?? this.inFridge,
  );
  ShoppingListEntry copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingListEntry(
      id: data.id.present ? data.id.value : this.id,
      mealPlanId: data.mealPlanId.present
          ? data.mealPlanId.value
          : this.mealPlanId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      purchased: data.purchased.present ? data.purchased.value : this.purchased,
      inFridge: data.inFridge.present ? data.inFridge.value : this.inFridge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingListEntry(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('purchased: $purchased, ')
          ..write('inFridge: $inFridge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mealPlanId,
    name,
    amount,
    unit,
    category,
    purchased,
    inFridge,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingListEntry &&
          other.id == this.id &&
          other.mealPlanId == this.mealPlanId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.purchased == this.purchased &&
          other.inFridge == this.inFridge);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingListEntry> {
  final Value<int> id;
  final Value<int> mealPlanId;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> unit;
  final Value<String> category;
  final Value<bool> purchased;
  final Value<bool> inFridge;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.mealPlanId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.purchased = const Value.absent(),
    this.inFridge = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    required int mealPlanId,
    required String name,
    required double amount,
    required String unit,
    required String category,
    this.purchased = const Value.absent(),
    this.inFridge = const Value.absent(),
  }) : mealPlanId = Value(mealPlanId),
       name = Value(name),
       amount = Value(amount),
       unit = Value(unit),
       category = Value(category);
  static Insertable<ShoppingListEntry> custom({
    Expression<int>? id,
    Expression<int>? mealPlanId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<bool>? purchased,
    Expression<bool>? inFridge,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealPlanId != null) 'meal_plan_id': mealPlanId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (purchased != null) 'purchased': purchased,
      if (inFridge != null) 'in_fridge': inFridge,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealPlanId,
    Value<String>? name,
    Value<double>? amount,
    Value<String>? unit,
    Value<String>? category,
    Value<bool>? purchased,
    Value<bool>? inFridge,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      mealPlanId: mealPlanId ?? this.mealPlanId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      purchased: purchased ?? this.purchased,
      inFridge: inFridge ?? this.inFridge,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealPlanId.present) {
      map['meal_plan_id'] = Variable<int>(mealPlanId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (purchased.present) {
      map['purchased'] = Variable<bool>(purchased.value);
    }
    if (inFridge.present) {
      map['in_fridge'] = Variable<bool>(inFridge.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('mealPlanId: $mealPlanId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('purchased: $purchased, ')
          ..write('inFridge: $inFridge')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, BodyWeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, weightKg, entryDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyWeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyWeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyWeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class BodyWeightEntry extends DataClass implements Insertable<BodyWeightEntry> {
  final int id;
  final double weightKg;
  final DateTime entryDate;
  const BodyWeightEntry({
    required this.id,
    required this.weightKg,
    required this.entryDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weight_kg'] = Variable<double>(weightKg);
    map['entry_date'] = Variable<DateTime>(entryDate);
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      weightKg: Value(weightKg),
      entryDate: Value(entryDate),
    );
  }

  factory BodyWeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyWeightEntry(
      id: serializer.fromJson<int>(json['id']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weightKg': serializer.toJson<double>(weightKg),
      'entryDate': serializer.toJson<DateTime>(entryDate),
    };
  }

  BodyWeightEntry copyWith({int? id, double? weightKg, DateTime? entryDate}) =>
      BodyWeightEntry(
        id: id ?? this.id,
        weightKg: weightKg ?? this.weightKg,
        entryDate: entryDate ?? this.entryDate,
      );
  BodyWeightEntry copyWithCompanion(WeightEntriesCompanion data) {
    return BodyWeightEntry(
      id: data.id.present ? data.id.value : this.id,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntry(')
          ..write('id: $id, ')
          ..write('weightKg: $weightKg, ')
          ..write('entryDate: $entryDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weightKg, entryDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyWeightEntry &&
          other.id == this.id &&
          other.weightKg == this.weightKg &&
          other.entryDate == this.entryDate);
}

class WeightEntriesCompanion extends UpdateCompanion<BodyWeightEntry> {
  final Value<int> id;
  final Value<double> weightKg;
  final Value<DateTime> entryDate;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.entryDate = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    required double weightKg,
    required DateTime entryDate,
  }) : weightKg = Value(weightKg),
       entryDate = Value(entryDate);
  static Insertable<BodyWeightEntry> custom({
    Expression<int>? id,
    Expression<double>? weightKg,
    Expression<DateTime>? entryDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightKg != null) 'weight_kg': weightKg,
      if (entryDate != null) 'entry_date': entryDate,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<int>? id,
    Value<double>? weightKg,
    Value<DateTime>? entryDate,
  }) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      entryDate: entryDate ?? this.entryDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('weightKg: $weightKg, ')
          ..write('entryDate: $entryDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $MealPlansTable mealPlans = $MealPlansTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $DayPlansTable dayPlans = $DayPlansTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $FridgeProductsTable fridgeProducts = $FridgeProductsTable(this);
  late final $FridgeScansTable fridgeScans = $FridgeScansTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final MealPlanDao mealPlanDao = MealPlanDao(this as AppDatabase);
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  late final FridgeDao fridgeDao = FridgeDao(this as AppDatabase);
  late final ShoppingListDao shoppingListDao = ShoppingListDao(
    this as AppDatabase,
  );
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    preferences,
    mealPlans,
    recipes,
    dayPlans,
    meals,
    ingredients,
    fridgeProducts,
    fridgeScans,
    shoppingItems,
    weightEntries,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      required String name,
      required DbGender gender,
      required int age,
      required double heightCm,
      required double weightKg,
      required double targetWeightKg,
      required DbGoal goal,
      required DbActivityLevel activityLevel,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DbGender> gender,
      Value<int> age,
      Value<double> heightCm,
      Value<double> weightKg,
      Value<double> targetWeightKg,
      Value<DbGoal> goal,
      Value<DbActivityLevel> activityLevel,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DbGender, DbGender, int> get gender =>
      $composableBuilder(
        column: $table.gender,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DbGoal, DbGoal, int> get goal =>
      $composableBuilder(
        column: $table.goal,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DbActivityLevel, DbActivityLevel, int>
  get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DbGender, int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DbGoal, int> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DbActivityLevel, int> get activityLevel =>
      $composableBuilder(
        column: $table.activityLevel,
        builder: (column) => column,
      );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileEntry,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileEntry,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileEntry>,
          ),
          ProfileEntry,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DbGender> gender = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> targetWeightKg = const Value.absent(),
                Value<DbGoal> goal = const Value.absent(),
                Value<DbActivityLevel> activityLevel = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                gender: gender,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                goal: goal,
                activityLevel: activityLevel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DbGender gender,
                required int age,
                required double heightCm,
                required double weightKg,
                required double targetWeightKg,
                required DbGoal goal,
                required DbActivityLevel activityLevel,
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                goal: goal,
                activityLevel: activityLevel,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileEntry,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (
        ProfileEntry,
        BaseReferences<_$AppDatabase, $ProfilesTable, ProfileEntry>,
      ),
      ProfileEntry,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<String> allergies,
      Value<String> dislikedProducts,
      Value<String> likedProducts,
      Value<int> maxCookingMinutes,
      required DbBudgetLevel budget,
      required DbDietType dietType,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<String> allergies,
      Value<String> dislikedProducts,
      Value<String> likedProducts,
      Value<int> maxCookingMinutes,
      Value<DbBudgetLevel> budget,
      Value<DbDietType> dietType,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dislikedProducts => $composableBuilder(
    column: $table.dislikedProducts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get likedProducts => $composableBuilder(
    column: $table.likedProducts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxCookingMinutes => $composableBuilder(
    column: $table.maxCookingMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DbBudgetLevel, DbBudgetLevel, int>
  get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DbDietType, DbDietType, int> get dietType =>
      $composableBuilder(
        column: $table.dietType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dislikedProducts => $composableBuilder(
    column: $table.dislikedProducts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get likedProducts => $composableBuilder(
    column: $table.likedProducts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxCookingMinutes => $composableBuilder(
    column: $table.maxCookingMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get dislikedProducts => $composableBuilder(
    column: $table.dislikedProducts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get likedProducts => $composableBuilder(
    column: $table.likedProducts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxCookingMinutes => $composableBuilder(
    column: $table.maxCookingMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DbBudgetLevel, int> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DbDietType, int> get dietType =>
      $composableBuilder(column: $table.dietType, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          PreferencesEntry,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            PreferencesEntry,
            BaseReferences<_$AppDatabase, $PreferencesTable, PreferencesEntry>,
          ),
          PreferencesEntry,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> dislikedProducts = const Value.absent(),
                Value<String> likedProducts = const Value.absent(),
                Value<int> maxCookingMinutes = const Value.absent(),
                Value<DbBudgetLevel> budget = const Value.absent(),
                Value<DbDietType> dietType = const Value.absent(),
              }) => PreferencesCompanion(
                id: id,
                allergies: allergies,
                dislikedProducts: dislikedProducts,
                likedProducts: likedProducts,
                maxCookingMinutes: maxCookingMinutes,
                budget: budget,
                dietType: dietType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> dislikedProducts = const Value.absent(),
                Value<String> likedProducts = const Value.absent(),
                Value<int> maxCookingMinutes = const Value.absent(),
                required DbBudgetLevel budget,
                required DbDietType dietType,
              }) => PreferencesCompanion.insert(
                id: id,
                allergies: allergies,
                dislikedProducts: dislikedProducts,
                likedProducts: likedProducts,
                maxCookingMinutes: maxCookingMinutes,
                budget: budget,
                dietType: dietType,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      PreferencesEntry,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        PreferencesEntry,
        BaseReferences<_$AppDatabase, $PreferencesTable, PreferencesEntry>,
      ),
      PreferencesEntry,
      PrefetchHooks Function()
    >;
typedef $$MealPlansTableCreateCompanionBuilder =
    MealPlansCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required DbGoal goal,
      Value<bool> isActive,
      required DateTime createdAt,
    });
typedef $$MealPlansTableUpdateCompanionBuilder =
    MealPlansCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<DbGoal> goal,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$MealPlansTableReferences
    extends BaseReferences<_$AppDatabase, $MealPlansTable, MealPlanEntry> {
  $$MealPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DayPlansTable, List<DayPlanEntry>>
  _dayPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dayPlans,
    aliasName: $_aliasNameGenerator(db.mealPlans.id, db.dayPlans.mealPlanId),
  );

  $$DayPlansTableProcessedTableManager get dayPlansRefs {
    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.mealPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dayPlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingItemsTable, List<ShoppingListEntry>>
  _shoppingItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingItems,
    aliasName: $_aliasNameGenerator(
      db.mealPlans.id,
      db.shoppingItems.mealPlanId,
    ),
  );

  $$ShoppingItemsTableProcessedTableManager get shoppingItemsRefs {
    final manager = $$ShoppingItemsTableTableManager(
      $_db,
      $_db.shoppingItems,
    ).filter((f) => f.mealPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealPlansTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DbGoal, DbGoal, int> get goal =>
      $composableBuilder(
        column: $table.goal,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dayPlansRefs(
    Expression<bool> Function($$DayPlansTableFilterComposer f) f,
  ) {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.mealPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingItemsRefs(
    Expression<bool> Function($$ShoppingItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItems,
      getReferencedColumn: (t) => t.mealPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlansTable> {
  $$MealPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DbGoal, int> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> dayPlansRefs<T extends Object>(
    Expression<T> Function($$DayPlansTableAnnotationComposer a) f,
  ) {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.mealPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItems,
      getReferencedColumn: (t) => t.mealPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPlansTable,
          MealPlanEntry,
          $$MealPlansTableFilterComposer,
          $$MealPlansTableOrderingComposer,
          $$MealPlansTableAnnotationComposer,
          $$MealPlansTableCreateCompanionBuilder,
          $$MealPlansTableUpdateCompanionBuilder,
          (MealPlanEntry, $$MealPlansTableReferences),
          MealPlanEntry,
          PrefetchHooks Function({bool dayPlansRefs, bool shoppingItemsRefs})
        > {
  $$MealPlansTableTableManager(_$AppDatabase db, $MealPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<DbGoal> goal = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealPlansCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                goal: goal,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required DbGoal goal,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
              }) => MealPlansCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                goal: goal,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({dayPlansRefs = false, shoppingItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dayPlansRefs) db.dayPlans,
                    if (shoppingItemsRefs) db.shoppingItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dayPlansRefs)
                        await $_getPrefetchedData<
                          MealPlanEntry,
                          $MealPlansTable,
                          DayPlanEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MealPlansTableReferences
                              ._dayPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).dayPlansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shoppingItemsRefs)
                        await $_getPrefetchedData<
                          MealPlanEntry,
                          $MealPlansTable,
                          ShoppingListEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MealPlansTableReferences
                              ._shoppingItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MealPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mealPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MealPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPlansTable,
      MealPlanEntry,
      $$MealPlansTableFilterComposer,
      $$MealPlansTableOrderingComposer,
      $$MealPlansTableAnnotationComposer,
      $$MealPlansTableCreateCompanionBuilder,
      $$MealPlansTableUpdateCompanionBuilder,
      (MealPlanEntry, $$MealPlansTableReferences),
      MealPlanEntry,
      PrefetchHooks Function({bool dayPlansRefs, bool shoppingItemsRefs})
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      required String title,
      required int cookingTimeMinutes,
      required DbDifficulty difficulty,
      required int servings,
      required double calories,
      required double proteinG,
      required double fatG,
      required double carbsG,
      Value<bool> isFavorite,
      required String stepsJson,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> cookingTimeMinutes,
      Value<DbDifficulty> difficulty,
      Value<int> servings,
      Value<double> calories,
      Value<double> proteinG,
      Value<double> fatG,
      Value<double> carbsG,
      Value<bool> isFavorite,
      Value<String> stepsJson,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, RecipeEntry> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealsTable, List<MealEntry>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.meals.recipeId),
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IngredientsTable, List<IngredientEntry>>
  _ingredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredients,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.ingredients.recipeId),
  );

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookingTimeMinutes => $composableBuilder(
    column: $table.cookingTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DbDifficulty, DbDifficulty, int>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepsJson => $composableBuilder(
    column: $table.stepsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ingredientsRefs(
    Expression<bool> Function($$IngredientsTableFilterComposer f) f,
  ) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookingTimeMinutes => $composableBuilder(
    column: $table.cookingTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinG => $composableBuilder(
    column: $table.proteinG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatG => $composableBuilder(
    column: $table.fatG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsG => $composableBuilder(
    column: $table.carbsG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepsJson => $composableBuilder(
    column: $table.stepsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get cookingTimeMinutes => $composableBuilder(
    column: $table.cookingTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DbDifficulty, int> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stepsJson =>
      $composableBuilder(column: $table.stepsJson, builder: (column) => column);

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ingredientsRefs<T extends Object>(
    Expression<T> Function($$IngredientsTableAnnotationComposer a) f,
  ) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          RecipeEntry,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (RecipeEntry, $$RecipesTableReferences),
          RecipeEntry,
          PrefetchHooks Function({bool mealsRefs, bool ingredientsRefs})
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> cookingTimeMinutes = const Value.absent(),
                Value<DbDifficulty> difficulty = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> proteinG = const Value.absent(),
                Value<double> fatG = const Value.absent(),
                Value<double> carbsG = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String> stepsJson = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                title: title,
                cookingTimeMinutes: cookingTimeMinutes,
                difficulty: difficulty,
                servings: servings,
                calories: calories,
                proteinG: proteinG,
                fatG: fatG,
                carbsG: carbsG,
                isFavorite: isFavorite,
                stepsJson: stepsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int cookingTimeMinutes,
                required DbDifficulty difficulty,
                required int servings,
                required double calories,
                required double proteinG,
                required double fatG,
                required double carbsG,
                Value<bool> isFavorite = const Value.absent(),
                required String stepsJson,
              }) => RecipesCompanion.insert(
                id: id,
                title: title,
                cookingTimeMinutes: cookingTimeMinutes,
                difficulty: difficulty,
                servings: servings,
                calories: calories,
                proteinG: proteinG,
                fatG: fatG,
                carbsG: carbsG,
                isFavorite: isFavorite,
                stepsJson: stepsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mealsRefs = false, ingredientsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mealsRefs) db.meals,
                    if (ingredientsRefs) db.ingredients,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mealsRefs)
                        await $_getPrefetchedData<
                          RecipeEntry,
                          $RecipesTable,
                          MealEntry
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._mealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(db, table, p0).mealsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingredientsRefs)
                        await $_getPrefetchedData<
                          RecipeEntry,
                          $RecipesTable,
                          IngredientEntry
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._ingredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      RecipeEntry,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (RecipeEntry, $$RecipesTableReferences),
      RecipeEntry,
      PrefetchHooks Function({bool mealsRefs, bool ingredientsRefs})
    >;
typedef $$DayPlansTableCreateCompanionBuilder =
    DayPlansCompanion Function({
      Value<int> id,
      required int mealPlanId,
      required DateTime planDate,
    });
typedef $$DayPlansTableUpdateCompanionBuilder =
    DayPlansCompanion Function({
      Value<int> id,
      Value<int> mealPlanId,
      Value<DateTime> planDate,
    });

final class $$DayPlansTableReferences
    extends BaseReferences<_$AppDatabase, $DayPlansTable, DayPlanEntry> {
  $$DayPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealPlansTable _mealPlanIdTable(_$AppDatabase db) =>
      db.mealPlans.createAlias(
        $_aliasNameGenerator(db.dayPlans.mealPlanId, db.mealPlans.id),
      );

  $$MealPlansTableProcessedTableManager get mealPlanId {
    final $_column = $_itemColumn<int>('meal_plan_id')!;

    final manager = $$MealPlansTableTableManager(
      $_db,
      $_db.mealPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<MealEntry>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: $_aliasNameGenerator(db.dayPlans.id, db.meals.dayPlanId),
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.dayPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DayPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get planDate => $composableBuilder(
    column: $table.planDate,
    builder: (column) => ColumnFilters(column),
  );

  $$MealPlansTableFilterComposer get mealPlanId {
    final $$MealPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableFilterComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DayPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get planDate => $composableBuilder(
    column: $table.planDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealPlansTableOrderingComposer get mealPlanId {
    final $$MealPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableOrderingComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DayPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get planDate =>
      $composableBuilder(column: $table.planDate, builder: (column) => column);

  $$MealPlansTableAnnotationComposer get mealPlanId {
    final $$MealPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DayPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayPlansTable,
          DayPlanEntry,
          $$DayPlansTableFilterComposer,
          $$DayPlansTableOrderingComposer,
          $$DayPlansTableAnnotationComposer,
          $$DayPlansTableCreateCompanionBuilder,
          $$DayPlansTableUpdateCompanionBuilder,
          (DayPlanEntry, $$DayPlansTableReferences),
          DayPlanEntry,
          PrefetchHooks Function({bool mealPlanId, bool mealsRefs})
        > {
  $$DayPlansTableTableManager(_$AppDatabase db, $DayPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealPlanId = const Value.absent(),
                Value<DateTime> planDate = const Value.absent(),
              }) => DayPlansCompanion(
                id: id,
                mealPlanId: mealPlanId,
                planDate: planDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealPlanId,
                required DateTime planDate,
              }) => DayPlansCompanion.insert(
                id: id,
                mealPlanId: mealPlanId,
                planDate: planDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DayPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealPlanId = false, mealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealsRefs) db.meals],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealPlanId,
                                referencedTable: $$DayPlansTableReferences
                                    ._mealPlanIdTable(db),
                                referencedColumn: $$DayPlansTableReferences
                                    ._mealPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealsRefs)
                    await $_getPrefetchedData<
                      DayPlanEntry,
                      $DayPlansTable,
                      MealEntry
                    >(
                      currentTable: table,
                      referencedTable: $$DayPlansTableReferences
                          ._mealsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DayPlansTableReferences(db, table, p0).mealsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.dayPlanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DayPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayPlansTable,
      DayPlanEntry,
      $$DayPlansTableFilterComposer,
      $$DayPlansTableOrderingComposer,
      $$DayPlansTableAnnotationComposer,
      $$DayPlansTableCreateCompanionBuilder,
      $$DayPlansTableUpdateCompanionBuilder,
      (DayPlanEntry, $$DayPlansTableReferences),
      DayPlanEntry,
      PrefetchHooks Function({bool mealPlanId, bool mealsRefs})
    >;
typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      required int dayPlanId,
      required DbMealType mealType,
      required DateTime mealTime,
      required int recipeId,
      Value<bool> isDone,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      Value<int> dayPlanId,
      Value<DbMealType> mealType,
      Value<DateTime> mealTime,
      Value<int> recipeId,
      Value<bool> isDone,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, MealEntry> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DayPlansTable _dayPlanIdTable(_$AppDatabase db) => db.dayPlans
      .createAlias($_aliasNameGenerator(db.meals.dayPlanId, db.dayPlans.id));

  $$DayPlansTableProcessedTableManager get dayPlanId {
    final $_column = $_itemColumn<int>('day_plan_id')!;

    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.meals.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DbMealType, DbMealType, int> get mealType =>
      $composableBuilder(
        column: $table.mealType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  $$DayPlansTableFilterComposer get dayPlanId {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$DayPlansTableOrderingComposer get dayPlanId {
    final $$DayPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DbMealType, int> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<DateTime> get mealTime =>
      $composableBuilder(column: $table.mealTime, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  $$DayPlansTableAnnotationComposer get dayPlanId {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          MealEntry,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (MealEntry, $$MealsTableReferences),
          MealEntry,
          PrefetchHooks Function({bool dayPlanId, bool recipeId})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dayPlanId = const Value.absent(),
                Value<DbMealType> mealType = const Value.absent(),
                Value<DateTime> mealTime = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                dayPlanId: dayPlanId,
                mealType: mealType,
                mealTime: mealTime,
                recipeId: recipeId,
                isDone: isDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dayPlanId,
                required DbMealType mealType,
                required DateTime mealTime,
                required int recipeId,
                Value<bool> isDone = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                dayPlanId: dayPlanId,
                mealType: mealType,
                mealTime: mealTime,
                recipeId: recipeId,
                isDone: isDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({dayPlanId = false, recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dayPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dayPlanId,
                                referencedTable: $$MealsTableReferences
                                    ._dayPlanIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._dayPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$MealsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      MealEntry,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (MealEntry, $$MealsTableReferences),
      MealEntry,
      PrefetchHooks Function({bool dayPlanId, bool recipeId})
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      required int recipeId,
      required String name,
      required double amount,
      required String unit,
      required String category,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<String> name,
      Value<double> amount,
      Value<String> unit,
      Value<String> category,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, IngredientEntry> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.ingredients.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          IngredientEntry,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (IngredientEntry, $$IngredientsTableReferences),
          IngredientEntry,
          PrefetchHooks Function({bool recipeId})
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                recipeId: recipeId,
                name: name,
                amount: amount,
                unit: unit,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required String name,
                required double amount,
                required String unit,
                required String category,
              }) => IngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                name: name,
                amount: amount,
                unit: unit,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$IngredientsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$IngredientsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      IngredientEntry,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (IngredientEntry, $$IngredientsTableReferences),
      IngredientEntry,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$FridgeProductsTableCreateCompanionBuilder =
    FridgeProductsCompanion Function({
      Value<int> id,
      required String name,
      required double amount,
      required String unit,
      required String category,
      required DateTime addedAt,
    });
typedef $$FridgeProductsTableUpdateCompanionBuilder =
    FridgeProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> amount,
      Value<String> unit,
      Value<String> category,
      Value<DateTime> addedAt,
    });

class $$FridgeProductsTableFilterComposer
    extends Composer<_$AppDatabase, $FridgeProductsTable> {
  $$FridgeProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FridgeProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $FridgeProductsTable> {
  $$FridgeProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FridgeProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FridgeProductsTable> {
  $$FridgeProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FridgeProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FridgeProductsTable,
          FridgeProductEntry,
          $$FridgeProductsTableFilterComposer,
          $$FridgeProductsTableOrderingComposer,
          $$FridgeProductsTableAnnotationComposer,
          $$FridgeProductsTableCreateCompanionBuilder,
          $$FridgeProductsTableUpdateCompanionBuilder,
          (
            FridgeProductEntry,
            BaseReferences<
              _$AppDatabase,
              $FridgeProductsTable,
              FridgeProductEntry
            >,
          ),
          FridgeProductEntry,
          PrefetchHooks Function()
        > {
  $$FridgeProductsTableTableManager(
    _$AppDatabase db,
    $FridgeProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FridgeProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FridgeProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FridgeProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => FridgeProductsCompanion(
                id: id,
                name: name,
                amount: amount,
                unit: unit,
                category: category,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double amount,
                required String unit,
                required String category,
                required DateTime addedAt,
              }) => FridgeProductsCompanion.insert(
                id: id,
                name: name,
                amount: amount,
                unit: unit,
                category: category,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FridgeProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FridgeProductsTable,
      FridgeProductEntry,
      $$FridgeProductsTableFilterComposer,
      $$FridgeProductsTableOrderingComposer,
      $$FridgeProductsTableAnnotationComposer,
      $$FridgeProductsTableCreateCompanionBuilder,
      $$FridgeProductsTableUpdateCompanionBuilder,
      (
        FridgeProductEntry,
        BaseReferences<_$AppDatabase, $FridgeProductsTable, FridgeProductEntry>,
      ),
      FridgeProductEntry,
      PrefetchHooks Function()
    >;
typedef $$FridgeScansTableCreateCompanionBuilder =
    FridgeScansCompanion Function({
      Value<int> id,
      required String photoPath,
      required DateTime scanDate,
      Value<int> productCount,
    });
typedef $$FridgeScansTableUpdateCompanionBuilder =
    FridgeScansCompanion Function({
      Value<int> id,
      Value<String> photoPath,
      Value<DateTime> scanDate,
      Value<int> productCount,
    });

class $$FridgeScansTableFilterComposer
    extends Composer<_$AppDatabase, $FridgeScansTable> {
  $$FridgeScansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scanDate => $composableBuilder(
    column: $table.scanDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FridgeScansTableOrderingComposer
    extends Composer<_$AppDatabase, $FridgeScansTable> {
  $$FridgeScansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scanDate => $composableBuilder(
    column: $table.scanDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FridgeScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $FridgeScansTable> {
  $$FridgeScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get scanDate =>
      $composableBuilder(column: $table.scanDate, builder: (column) => column);

  GeneratedColumn<int> get productCount => $composableBuilder(
    column: $table.productCount,
    builder: (column) => column,
  );
}

class $$FridgeScansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FridgeScansTable,
          FridgeScanEntry,
          $$FridgeScansTableFilterComposer,
          $$FridgeScansTableOrderingComposer,
          $$FridgeScansTableAnnotationComposer,
          $$FridgeScansTableCreateCompanionBuilder,
          $$FridgeScansTableUpdateCompanionBuilder,
          (
            FridgeScanEntry,
            BaseReferences<_$AppDatabase, $FridgeScansTable, FridgeScanEntry>,
          ),
          FridgeScanEntry,
          PrefetchHooks Function()
        > {
  $$FridgeScansTableTableManager(_$AppDatabase db, $FridgeScansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FridgeScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FridgeScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FridgeScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<DateTime> scanDate = const Value.absent(),
                Value<int> productCount = const Value.absent(),
              }) => FridgeScansCompanion(
                id: id,
                photoPath: photoPath,
                scanDate: scanDate,
                productCount: productCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String photoPath,
                required DateTime scanDate,
                Value<int> productCount = const Value.absent(),
              }) => FridgeScansCompanion.insert(
                id: id,
                photoPath: photoPath,
                scanDate: scanDate,
                productCount: productCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FridgeScansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FridgeScansTable,
      FridgeScanEntry,
      $$FridgeScansTableFilterComposer,
      $$FridgeScansTableOrderingComposer,
      $$FridgeScansTableAnnotationComposer,
      $$FridgeScansTableCreateCompanionBuilder,
      $$FridgeScansTableUpdateCompanionBuilder,
      (
        FridgeScanEntry,
        BaseReferences<_$AppDatabase, $FridgeScansTable, FridgeScanEntry>,
      ),
      FridgeScanEntry,
      PrefetchHooks Function()
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      required int mealPlanId,
      required String name,
      required double amount,
      required String unit,
      required String category,
      Value<bool> purchased,
      Value<bool> inFridge,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      Value<int> mealPlanId,
      Value<String> name,
      Value<double> amount,
      Value<String> unit,
      Value<String> category,
      Value<bool> purchased,
      Value<bool> inFridge,
    });

final class $$ShoppingItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingListEntry> {
  $$ShoppingItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealPlansTable _mealPlanIdTable(_$AppDatabase db) =>
      db.mealPlans.createAlias(
        $_aliasNameGenerator(db.shoppingItems.mealPlanId, db.mealPlans.id),
      );

  $$MealPlansTableProcessedTableManager get mealPlanId {
    final $_column = $_itemColumn<int>('meal_plan_id')!;

    final manager = $$MealPlansTableTableManager(
      $_db,
      $_db.mealPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get purchased => $composableBuilder(
    column: $table.purchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inFridge => $composableBuilder(
    column: $table.inFridge,
    builder: (column) => ColumnFilters(column),
  );

  $$MealPlansTableFilterComposer get mealPlanId {
    final $$MealPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableFilterComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get purchased => $composableBuilder(
    column: $table.purchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inFridge => $composableBuilder(
    column: $table.inFridge,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealPlansTableOrderingComposer get mealPlanId {
    final $$MealPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableOrderingComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get purchased =>
      $composableBuilder(column: $table.purchased, builder: (column) => column);

  GeneratedColumn<bool> get inFridge =>
      $composableBuilder(column: $table.inFridge, builder: (column) => column);

  $$MealPlansTableAnnotationComposer get mealPlanId {
    final $$MealPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealPlanId,
      referencedTable: $db.mealPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.mealPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemsTable,
          ShoppingListEntry,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (ShoppingListEntry, $$ShoppingItemsTableReferences),
          ShoppingListEntry,
          PrefetchHooks Function({bool mealPlanId})
        > {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealPlanId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> purchased = const Value.absent(),
                Value<bool> inFridge = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                mealPlanId: mealPlanId,
                name: name,
                amount: amount,
                unit: unit,
                category: category,
                purchased: purchased,
                inFridge: inFridge,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealPlanId,
                required String name,
                required double amount,
                required String unit,
                required String category,
                Value<bool> purchased = const Value.absent(),
                Value<bool> inFridge = const Value.absent(),
              }) => ShoppingItemsCompanion.insert(
                id: id,
                mealPlanId: mealPlanId,
                name: name,
                amount: amount,
                unit: unit,
                category: category,
                purchased: purchased,
                inFridge: inFridge,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShoppingItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealPlanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealPlanId,
                                referencedTable: $$ShoppingItemsTableReferences
                                    ._mealPlanIdTable(db),
                                referencedColumn: $$ShoppingItemsTableReferences
                                    ._mealPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemsTable,
      ShoppingListEntry,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (ShoppingListEntry, $$ShoppingItemsTableReferences),
      ShoppingListEntry,
      PrefetchHooks Function({bool mealPlanId})
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<int> id,
      required double weightKg,
      required DateTime entryDate,
    });
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
      Value<int> id,
      Value<double> weightKg,
      Value<DateTime> entryDate,
    });

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          BodyWeightEntry,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (
            BodyWeightEntry,
            BaseReferences<_$AppDatabase, $WeightEntriesTable, BodyWeightEntry>,
          ),
          BodyWeightEntry,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
              }) => WeightEntriesCompanion(
                id: id,
                weightKg: weightKg,
                entryDate: entryDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double weightKg,
                required DateTime entryDate,
              }) => WeightEntriesCompanion.insert(
                id: id,
                weightKg: weightKg,
                entryDate: entryDate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      BodyWeightEntry,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (
        BodyWeightEntry,
        BaseReferences<_$AppDatabase, $WeightEntriesTable, BodyWeightEntry>,
      ),
      BodyWeightEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db, _db.mealPlans);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$DayPlansTableTableManager get dayPlans =>
      $$DayPlansTableTableManager(_db, _db.dayPlans);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$FridgeProductsTableTableManager get fridgeProducts =>
      $$FridgeProductsTableTableManager(_db, _db.fridgeProducts);
  $$FridgeScansTableTableManager get fridgeScans =>
      $$FridgeScansTableTableManager(_db, _db.fridgeScans);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
}

mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProfilesTable get profiles => attachedDatabase.profiles;
  $PreferencesTable get preferences => attachedDatabase.preferences;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db.attachedDatabase, _db.profiles);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db.attachedDatabase, _db.preferences);
}

mixin _$MealPlanDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealPlansTable get mealPlans => attachedDatabase.mealPlans;
  $DayPlansTable get dayPlans => attachedDatabase.dayPlans;
  $RecipesTable get recipes => attachedDatabase.recipes;
  $MealsTable get meals => attachedDatabase.meals;
  MealPlanDaoManager get managers => MealPlanDaoManager(this);
}

class MealPlanDaoManager {
  final _$MealPlanDaoMixin _db;
  MealPlanDaoManager(this._db);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db.attachedDatabase, _db.mealPlans);
  $$DayPlansTableTableManager get dayPlans =>
      $$DayPlansTableTableManager(_db.attachedDatabase, _db.dayPlans);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db.attachedDatabase, _db.recipes);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db.attachedDatabase, _db.meals);
}

mixin _$RecipeDaoMixin on DatabaseAccessor<AppDatabase> {
  $RecipesTable get recipes => attachedDatabase.recipes;
  $IngredientsTable get ingredients => attachedDatabase.ingredients;
  RecipeDaoManager get managers => RecipeDaoManager(this);
}

class RecipeDaoManager {
  final _$RecipeDaoMixin _db;
  RecipeDaoManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db.attachedDatabase, _db.recipes);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db.attachedDatabase, _db.ingredients);
}

mixin _$FridgeDaoMixin on DatabaseAccessor<AppDatabase> {
  $FridgeProductsTable get fridgeProducts => attachedDatabase.fridgeProducts;
  $FridgeScansTable get fridgeScans => attachedDatabase.fridgeScans;
  FridgeDaoManager get managers => FridgeDaoManager(this);
}

class FridgeDaoManager {
  final _$FridgeDaoMixin _db;
  FridgeDaoManager(this._db);
  $$FridgeProductsTableTableManager get fridgeProducts =>
      $$FridgeProductsTableTableManager(
        _db.attachedDatabase,
        _db.fridgeProducts,
      );
  $$FridgeScansTableTableManager get fridgeScans =>
      $$FridgeScansTableTableManager(_db.attachedDatabase, _db.fridgeScans);
}

mixin _$ShoppingListDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealPlansTable get mealPlans => attachedDatabase.mealPlans;
  $ShoppingItemsTable get shoppingItems => attachedDatabase.shoppingItems;
  ShoppingListDaoManager get managers => ShoppingListDaoManager(this);
}

class ShoppingListDaoManager {
  final _$ShoppingListDaoMixin _db;
  ShoppingListDaoManager(this._db);
  $$MealPlansTableTableManager get mealPlans =>
      $$MealPlansTableTableManager(_db.attachedDatabase, _db.mealPlans);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db.attachedDatabase, _db.shoppingItems);
}

mixin _$ProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $WeightEntriesTable get weightEntries => attachedDatabase.weightEntries;
  ProgressDaoManager get managers => ProgressDaoManager(this);
}

class ProgressDaoManager {
  final _$ProgressDaoMixin _db;
  ProgressDaoManager(this._db);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db.attachedDatabase, _db.weightEntries);
}
