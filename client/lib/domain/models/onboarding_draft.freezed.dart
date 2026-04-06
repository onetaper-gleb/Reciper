// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingDraft {

 String get name; Gender? get gender; int? get age; double? get heightCm; double? get weightKg; Goal? get goal; ActivityLevel? get activityLevel; List<String> get allergyTags; String get allergiesOther;
/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDraftCopyWith<OnboardingDraft> get copyWith => _$OnboardingDraftCopyWithImpl<OnboardingDraft>(this as OnboardingDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.age, age) || other.age == age)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&const DeepCollectionEquality().equals(other.allergyTags, allergyTags)&&(identical(other.allergiesOther, allergiesOther) || other.allergiesOther == allergiesOther));
}


@override
int get hashCode => Object.hash(runtimeType,name,gender,age,heightCm,weightKg,goal,activityLevel,const DeepCollectionEquality().hash(allergyTags),allergiesOther);

@override
String toString() {
  return 'OnboardingDraft(name: $name, gender: $gender, age: $age, heightCm: $heightCm, weightKg: $weightKg, goal: $goal, activityLevel: $activityLevel, allergyTags: $allergyTags, allergiesOther: $allergiesOther)';
}


}

/// @nodoc
abstract mixin class $OnboardingDraftCopyWith<$Res>  {
  factory $OnboardingDraftCopyWith(OnboardingDraft value, $Res Function(OnboardingDraft) _then) = _$OnboardingDraftCopyWithImpl;
@useResult
$Res call({
 String name, Gender? gender, int? age, double? heightCm, double? weightKg, Goal? goal, ActivityLevel? activityLevel, List<String> allergyTags, String allergiesOther
});




}
/// @nodoc
class _$OnboardingDraftCopyWithImpl<$Res>
    implements $OnboardingDraftCopyWith<$Res> {
  _$OnboardingDraftCopyWithImpl(this._self, this._then);

  final OnboardingDraft _self;
  final $Res Function(OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? gender = freezed,Object? age = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? goal = freezed,Object? activityLevel = freezed,Object? allergyTags = null,Object? allergiesOther = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,allergyTags: null == allergyTags ? _self.allergyTags : allergyTags // ignore: cast_nullable_to_non_nullable
as List<String>,allergiesOther: null == allergiesOther ? _self.allergiesOther : allergiesOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingDraft].
extension OnboardingDraftPatterns on OnboardingDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingDraft value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Gender? gender,  int? age,  double? heightCm,  double? weightKg,  Goal? goal,  ActivityLevel? activityLevel,  List<String> allergyTags,  String allergiesOther)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.name,_that.gender,_that.age,_that.heightCm,_that.weightKg,_that.goal,_that.activityLevel,_that.allergyTags,_that.allergiesOther);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Gender? gender,  int? age,  double? heightCm,  double? weightKg,  Goal? goal,  ActivityLevel? activityLevel,  List<String> allergyTags,  String allergiesOther)  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft():
return $default(_that.name,_that.gender,_that.age,_that.heightCm,_that.weightKg,_that.goal,_that.activityLevel,_that.allergyTags,_that.allergiesOther);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Gender? gender,  int? age,  double? heightCm,  double? weightKg,  Goal? goal,  ActivityLevel? activityLevel,  List<String> allergyTags,  String allergiesOther)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.name,_that.gender,_that.age,_that.heightCm,_that.weightKg,_that.goal,_that.activityLevel,_that.allergyTags,_that.allergiesOther);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingDraft implements OnboardingDraft {
  const _OnboardingDraft({this.name = '', this.gender, this.age, this.heightCm, this.weightKg, this.goal, this.activityLevel, final  List<String> allergyTags = const <String>[], this.allergiesOther = ''}): _allergyTags = allergyTags;
  

@override@JsonKey() final  String name;
@override final  Gender? gender;
@override final  int? age;
@override final  double? heightCm;
@override final  double? weightKg;
@override final  Goal? goal;
@override final  ActivityLevel? activityLevel;
 final  List<String> _allergyTags;
@override@JsonKey() List<String> get allergyTags {
  if (_allergyTags is EqualUnmodifiableListView) return _allergyTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergyTags);
}

@override@JsonKey() final  String allergiesOther;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDraftCopyWith<_OnboardingDraft> get copyWith => __$OnboardingDraftCopyWithImpl<_OnboardingDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.age, age) || other.age == age)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&const DeepCollectionEquality().equals(other._allergyTags, _allergyTags)&&(identical(other.allergiesOther, allergiesOther) || other.allergiesOther == allergiesOther));
}


@override
int get hashCode => Object.hash(runtimeType,name,gender,age,heightCm,weightKg,goal,activityLevel,const DeepCollectionEquality().hash(_allergyTags),allergiesOther);

@override
String toString() {
  return 'OnboardingDraft(name: $name, gender: $gender, age: $age, heightCm: $heightCm, weightKg: $weightKg, goal: $goal, activityLevel: $activityLevel, allergyTags: $allergyTags, allergiesOther: $allergiesOther)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDraftCopyWith<$Res> implements $OnboardingDraftCopyWith<$Res> {
  factory _$OnboardingDraftCopyWith(_OnboardingDraft value, $Res Function(_OnboardingDraft) _then) = __$OnboardingDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, Gender? gender, int? age, double? heightCm, double? weightKg, Goal? goal, ActivityLevel? activityLevel, List<String> allergyTags, String allergiesOther
});




}
/// @nodoc
class __$OnboardingDraftCopyWithImpl<$Res>
    implements _$OnboardingDraftCopyWith<$Res> {
  __$OnboardingDraftCopyWithImpl(this._self, this._then);

  final _OnboardingDraft _self;
  final $Res Function(_OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? gender = freezed,Object? age = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? goal = freezed,Object? activityLevel = freezed,Object? allergyTags = null,Object? allergiesOther = null,}) {
  return _then(_OnboardingDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as Goal?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as ActivityLevel?,allergyTags: null == allergyTags ? _self._allergyTags : allergyTags // ignore: cast_nullable_to_non_nullable
as List<String>,allergiesOther: null == allergiesOther ? _self.allergiesOther : allergiesOther // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
