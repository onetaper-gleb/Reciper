// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meal {

 int get id; int get dayPlanId; MealType get mealType; DateTime get mealTime; int get recipeId; bool get isDone; ReplaceReason? get replaceReason;
/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealCopyWith<Meal> get copyWith => _$MealCopyWithImpl<Meal>(this as Meal, _$identity);

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meal&&(identical(other.id, id) || other.id == id)&&(identical(other.dayPlanId, dayPlanId) || other.dayPlanId == dayPlanId)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.mealTime, mealTime) || other.mealTime == mealTime)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.replaceReason, replaceReason) || other.replaceReason == replaceReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dayPlanId,mealType,mealTime,recipeId,isDone,replaceReason);

@override
String toString() {
  return 'Meal(id: $id, dayPlanId: $dayPlanId, mealType: $mealType, mealTime: $mealTime, recipeId: $recipeId, isDone: $isDone, replaceReason: $replaceReason)';
}


}

/// @nodoc
abstract mixin class $MealCopyWith<$Res>  {
  factory $MealCopyWith(Meal value, $Res Function(Meal) _then) = _$MealCopyWithImpl;
@useResult
$Res call({
 int id, int dayPlanId, MealType mealType, DateTime mealTime, int recipeId, bool isDone, ReplaceReason? replaceReason
});




}
/// @nodoc
class _$MealCopyWithImpl<$Res>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._self, this._then);

  final Meal _self;
  final $Res Function(Meal) _then;

/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dayPlanId = null,Object? mealType = null,Object? mealTime = null,Object? recipeId = null,Object? isDone = null,Object? replaceReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,dayPlanId: null == dayPlanId ? _self.dayPlanId : dayPlanId // ignore: cast_nullable_to_non_nullable
as int,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as MealType,mealTime: null == mealTime ? _self.mealTime : mealTime // ignore: cast_nullable_to_non_nullable
as DateTime,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,replaceReason: freezed == replaceReason ? _self.replaceReason : replaceReason // ignore: cast_nullable_to_non_nullable
as ReplaceReason?,
  ));
}

}


/// Adds pattern-matching-related methods to [Meal].
extension MealPatterns on Meal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meal value)  $default,){
final _that = this;
switch (_that) {
case _Meal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meal value)?  $default,){
final _that = this;
switch (_that) {
case _Meal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int dayPlanId,  MealType mealType,  DateTime mealTime,  int recipeId,  bool isDone,  ReplaceReason? replaceReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meal() when $default != null:
return $default(_that.id,_that.dayPlanId,_that.mealType,_that.mealTime,_that.recipeId,_that.isDone,_that.replaceReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int dayPlanId,  MealType mealType,  DateTime mealTime,  int recipeId,  bool isDone,  ReplaceReason? replaceReason)  $default,) {final _that = this;
switch (_that) {
case _Meal():
return $default(_that.id,_that.dayPlanId,_that.mealType,_that.mealTime,_that.recipeId,_that.isDone,_that.replaceReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int dayPlanId,  MealType mealType,  DateTime mealTime,  int recipeId,  bool isDone,  ReplaceReason? replaceReason)?  $default,) {final _that = this;
switch (_that) {
case _Meal() when $default != null:
return $default(_that.id,_that.dayPlanId,_that.mealType,_that.mealTime,_that.recipeId,_that.isDone,_that.replaceReason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Meal implements Meal {
  const _Meal({required this.id, required this.dayPlanId, required this.mealType, required this.mealTime, required this.recipeId, required this.isDone, this.replaceReason});
  factory _Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

@override final  int id;
@override final  int dayPlanId;
@override final  MealType mealType;
@override final  DateTime mealTime;
@override final  int recipeId;
@override final  bool isDone;
@override final  ReplaceReason? replaceReason;

/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealCopyWith<_Meal> get copyWith => __$MealCopyWithImpl<_Meal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meal&&(identical(other.id, id) || other.id == id)&&(identical(other.dayPlanId, dayPlanId) || other.dayPlanId == dayPlanId)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.mealTime, mealTime) || other.mealTime == mealTime)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.replaceReason, replaceReason) || other.replaceReason == replaceReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dayPlanId,mealType,mealTime,recipeId,isDone,replaceReason);

@override
String toString() {
  return 'Meal(id: $id, dayPlanId: $dayPlanId, mealType: $mealType, mealTime: $mealTime, recipeId: $recipeId, isDone: $isDone, replaceReason: $replaceReason)';
}


}

/// @nodoc
abstract mixin class _$MealCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$MealCopyWith(_Meal value, $Res Function(_Meal) _then) = __$MealCopyWithImpl;
@override @useResult
$Res call({
 int id, int dayPlanId, MealType mealType, DateTime mealTime, int recipeId, bool isDone, ReplaceReason? replaceReason
});




}
/// @nodoc
class __$MealCopyWithImpl<$Res>
    implements _$MealCopyWith<$Res> {
  __$MealCopyWithImpl(this._self, this._then);

  final _Meal _self;
  final $Res Function(_Meal) _then;

/// Create a copy of Meal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dayPlanId = null,Object? mealType = null,Object? mealTime = null,Object? recipeId = null,Object? isDone = null,Object? replaceReason = freezed,}) {
  return _then(_Meal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,dayPlanId: null == dayPlanId ? _self.dayPlanId : dayPlanId // ignore: cast_nullable_to_non_nullable
as int,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as MealType,mealTime: null == mealTime ? _self.mealTime : mealTime // ignore: cast_nullable_to_non_nullable
as DateTime,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,replaceReason: freezed == replaceReason ? _self.replaceReason : replaceReason // ignore: cast_nullable_to_non_nullable
as ReplaceReason?,
  ));
}


}

// dart format on
