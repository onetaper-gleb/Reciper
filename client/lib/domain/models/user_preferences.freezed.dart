// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreferences {

 int get id; List<String> get allergies; List<String> get dislikedProducts; List<String> get likedProducts; int get maxCookingMinutes; BudgetLevel get budget; DietType get dietType;
/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<UserPreferences> get copyWith => _$UserPreferencesCopyWithImpl<UserPreferences>(this as UserPreferences, _$identity);

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferences&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.allergies, allergies)&&const DeepCollectionEquality().equals(other.dislikedProducts, dislikedProducts)&&const DeepCollectionEquality().equals(other.likedProducts, likedProducts)&&(identical(other.maxCookingMinutes, maxCookingMinutes) || other.maxCookingMinutes == maxCookingMinutes)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.dietType, dietType) || other.dietType == dietType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(allergies),const DeepCollectionEquality().hash(dislikedProducts),const DeepCollectionEquality().hash(likedProducts),maxCookingMinutes,budget,dietType);

@override
String toString() {
  return 'UserPreferences(id: $id, allergies: $allergies, dislikedProducts: $dislikedProducts, likedProducts: $likedProducts, maxCookingMinutes: $maxCookingMinutes, budget: $budget, dietType: $dietType)';
}


}

/// @nodoc
abstract mixin class $UserPreferencesCopyWith<$Res>  {
  factory $UserPreferencesCopyWith(UserPreferences value, $Res Function(UserPreferences) _then) = _$UserPreferencesCopyWithImpl;
@useResult
$Res call({
 int id, List<String> allergies, List<String> dislikedProducts, List<String> likedProducts, int maxCookingMinutes, BudgetLevel budget, DietType dietType
});




}
/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._self, this._then);

  final UserPreferences _self;
  final $Res Function(UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? allergies = null,Object? dislikedProducts = null,Object? likedProducts = null,Object? maxCookingMinutes = null,Object? budget = null,Object? dietType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,dislikedProducts: null == dislikedProducts ? _self.dislikedProducts : dislikedProducts // ignore: cast_nullable_to_non_nullable
as List<String>,likedProducts: null == likedProducts ? _self.likedProducts : likedProducts // ignore: cast_nullable_to_non_nullable
as List<String>,maxCookingMinutes: null == maxCookingMinutes ? _self.maxCookingMinutes : maxCookingMinutes // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as BudgetLevel,dietType: null == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as DietType,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferences].
extension UserPreferencesPatterns on UserPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferences value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  List<String> allergies,  List<String> dislikedProducts,  List<String> likedProducts,  int maxCookingMinutes,  BudgetLevel budget,  DietType dietType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.id,_that.allergies,_that.dislikedProducts,_that.likedProducts,_that.maxCookingMinutes,_that.budget,_that.dietType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  List<String> allergies,  List<String> dislikedProducts,  List<String> likedProducts,  int maxCookingMinutes,  BudgetLevel budget,  DietType dietType)  $default,) {final _that = this;
switch (_that) {
case _UserPreferences():
return $default(_that.id,_that.allergies,_that.dislikedProducts,_that.likedProducts,_that.maxCookingMinutes,_that.budget,_that.dietType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  List<String> allergies,  List<String> dislikedProducts,  List<String> likedProducts,  int maxCookingMinutes,  BudgetLevel budget,  DietType dietType)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferences() when $default != null:
return $default(_that.id,_that.allergies,_that.dislikedProducts,_that.likedProducts,_that.maxCookingMinutes,_that.budget,_that.dietType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UserPreferences implements UserPreferences {
  const _UserPreferences({required this.id, final  List<String> allergies = const <String>[], final  List<String> dislikedProducts = const <String>[], final  List<String> likedProducts = const <String>[], required this.maxCookingMinutes, required this.budget, required this.dietType}): _allergies = allergies,_dislikedProducts = dislikedProducts,_likedProducts = likedProducts;
  factory _UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);

@override final  int id;
 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<String> _dislikedProducts;
@override@JsonKey() List<String> get dislikedProducts {
  if (_dislikedProducts is EqualUnmodifiableListView) return _dislikedProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dislikedProducts);
}

 final  List<String> _likedProducts;
@override@JsonKey() List<String> get likedProducts {
  if (_likedProducts is EqualUnmodifiableListView) return _likedProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likedProducts);
}

@override final  int maxCookingMinutes;
@override final  BudgetLevel budget;
@override final  DietType dietType;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferencesCopyWith<_UserPreferences> get copyWith => __$UserPreferencesCopyWithImpl<_UserPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferences&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._allergies, _allergies)&&const DeepCollectionEquality().equals(other._dislikedProducts, _dislikedProducts)&&const DeepCollectionEquality().equals(other._likedProducts, _likedProducts)&&(identical(other.maxCookingMinutes, maxCookingMinutes) || other.maxCookingMinutes == maxCookingMinutes)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.dietType, dietType) || other.dietType == dietType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_dislikedProducts),const DeepCollectionEquality().hash(_likedProducts),maxCookingMinutes,budget,dietType);

@override
String toString() {
  return 'UserPreferences(id: $id, allergies: $allergies, dislikedProducts: $dislikedProducts, likedProducts: $likedProducts, maxCookingMinutes: $maxCookingMinutes, budget: $budget, dietType: $dietType)';
}


}

/// @nodoc
abstract mixin class _$UserPreferencesCopyWith<$Res> implements $UserPreferencesCopyWith<$Res> {
  factory _$UserPreferencesCopyWith(_UserPreferences value, $Res Function(_UserPreferences) _then) = __$UserPreferencesCopyWithImpl;
@override @useResult
$Res call({
 int id, List<String> allergies, List<String> dislikedProducts, List<String> likedProducts, int maxCookingMinutes, BudgetLevel budget, DietType dietType
});




}
/// @nodoc
class __$UserPreferencesCopyWithImpl<$Res>
    implements _$UserPreferencesCopyWith<$Res> {
  __$UserPreferencesCopyWithImpl(this._self, this._then);

  final _UserPreferences _self;
  final $Res Function(_UserPreferences) _then;

/// Create a copy of UserPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? allergies = null,Object? dislikedProducts = null,Object? likedProducts = null,Object? maxCookingMinutes = null,Object? budget = null,Object? dietType = null,}) {
  return _then(_UserPreferences(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,dislikedProducts: null == dislikedProducts ? _self._dislikedProducts : dislikedProducts // ignore: cast_nullable_to_non_nullable
as List<String>,likedProducts: null == likedProducts ? _self._likedProducts : likedProducts // ignore: cast_nullable_to_non_nullable
as List<String>,maxCookingMinutes: null == maxCookingMinutes ? _self.maxCookingMinutes : maxCookingMinutes // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as BudgetLevel,dietType: null == dietType ? _self.dietType : dietType // ignore: cast_nullable_to_non_nullable
as DietType,
  ));
}


}

// dart format on
