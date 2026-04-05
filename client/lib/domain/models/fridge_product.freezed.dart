// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fridge_product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FridgeProduct {

 int get id; String get name; double get amount; String get unit; String get category; DateTime? get addedAt;
/// Create a copy of FridgeProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FridgeProductCopyWith<FridgeProduct> get copyWith => _$FridgeProductCopyWithImpl<FridgeProduct>(this as FridgeProduct, _$identity);

  /// Serializes this FridgeProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FridgeProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,unit,category,addedAt);

@override
String toString() {
  return 'FridgeProduct(id: $id, name: $name, amount: $amount, unit: $unit, category: $category, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $FridgeProductCopyWith<$Res>  {
  factory $FridgeProductCopyWith(FridgeProduct value, $Res Function(FridgeProduct) _then) = _$FridgeProductCopyWithImpl;
@useResult
$Res call({
 int id, String name, double amount, String unit, String category, DateTime? addedAt
});




}
/// @nodoc
class _$FridgeProductCopyWithImpl<$Res>
    implements $FridgeProductCopyWith<$Res> {
  _$FridgeProductCopyWithImpl(this._self, this._then);

  final FridgeProduct _self;
  final $Res Function(FridgeProduct) _then;

/// Create a copy of FridgeProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? unit = null,Object? category = null,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FridgeProduct].
extension FridgeProductPatterns on FridgeProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FridgeProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FridgeProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FridgeProduct value)  $default,){
final _that = this;
switch (_that) {
case _FridgeProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FridgeProduct value)?  $default,){
final _that = this;
switch (_that) {
case _FridgeProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  double amount,  String unit,  String category,  DateTime? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FridgeProduct() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.unit,_that.category,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  double amount,  String unit,  String category,  DateTime? addedAt)  $default,) {final _that = this;
switch (_that) {
case _FridgeProduct():
return $default(_that.id,_that.name,_that.amount,_that.unit,_that.category,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  double amount,  String unit,  String category,  DateTime? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _FridgeProduct() when $default != null:
return $default(_that.id,_that.name,_that.amount,_that.unit,_that.category,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FridgeProduct implements FridgeProduct {
  const _FridgeProduct({required this.id, required this.name, required this.amount, required this.unit, required this.category, this.addedAt});
  factory _FridgeProduct.fromJson(Map<String, dynamic> json) => _$FridgeProductFromJson(json);

@override final  int id;
@override final  String name;
@override final  double amount;
@override final  String unit;
@override final  String category;
@override final  DateTime? addedAt;

/// Create a copy of FridgeProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FridgeProductCopyWith<_FridgeProduct> get copyWith => __$FridgeProductCopyWithImpl<_FridgeProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FridgeProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FridgeProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,amount,unit,category,addedAt);

@override
String toString() {
  return 'FridgeProduct(id: $id, name: $name, amount: $amount, unit: $unit, category: $category, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$FridgeProductCopyWith<$Res> implements $FridgeProductCopyWith<$Res> {
  factory _$FridgeProductCopyWith(_FridgeProduct value, $Res Function(_FridgeProduct) _then) = __$FridgeProductCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, double amount, String unit, String category, DateTime? addedAt
});




}
/// @nodoc
class __$FridgeProductCopyWithImpl<$Res>
    implements _$FridgeProductCopyWith<$Res> {
  __$FridgeProductCopyWithImpl(this._self, this._then);

  final _FridgeProduct _self;
  final $Res Function(_FridgeProduct) _then;

/// Create a copy of FridgeProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? amount = null,Object? unit = null,Object? category = null,Object? addedAt = freezed,}) {
  return _then(_FridgeProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
