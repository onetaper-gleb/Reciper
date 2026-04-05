// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fridge_scan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FridgeScan {

 int get id; String get photoPath; DateTime get scanDate; int get productCount;
/// Create a copy of FridgeScan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FridgeScanCopyWith<FridgeScan> get copyWith => _$FridgeScanCopyWithImpl<FridgeScan>(this as FridgeScan, _$identity);

  /// Serializes this FridgeScan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FridgeScan&&(identical(other.id, id) || other.id == id)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.scanDate, scanDate) || other.scanDate == scanDate)&&(identical(other.productCount, productCount) || other.productCount == productCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,photoPath,scanDate,productCount);

@override
String toString() {
  return 'FridgeScan(id: $id, photoPath: $photoPath, scanDate: $scanDate, productCount: $productCount)';
}


}

/// @nodoc
abstract mixin class $FridgeScanCopyWith<$Res>  {
  factory $FridgeScanCopyWith(FridgeScan value, $Res Function(FridgeScan) _then) = _$FridgeScanCopyWithImpl;
@useResult
$Res call({
 int id, String photoPath, DateTime scanDate, int productCount
});




}
/// @nodoc
class _$FridgeScanCopyWithImpl<$Res>
    implements $FridgeScanCopyWith<$Res> {
  _$FridgeScanCopyWithImpl(this._self, this._then);

  final FridgeScan _self;
  final $Res Function(FridgeScan) _then;

/// Create a copy of FridgeScan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? photoPath = null,Object? scanDate = null,Object? productCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,scanDate: null == scanDate ? _self.scanDate : scanDate // ignore: cast_nullable_to_non_nullable
as DateTime,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FridgeScan].
extension FridgeScanPatterns on FridgeScan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FridgeScan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FridgeScan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FridgeScan value)  $default,){
final _that = this;
switch (_that) {
case _FridgeScan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FridgeScan value)?  $default,){
final _that = this;
switch (_that) {
case _FridgeScan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String photoPath,  DateTime scanDate,  int productCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FridgeScan() when $default != null:
return $default(_that.id,_that.photoPath,_that.scanDate,_that.productCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String photoPath,  DateTime scanDate,  int productCount)  $default,) {final _that = this;
switch (_that) {
case _FridgeScan():
return $default(_that.id,_that.photoPath,_that.scanDate,_that.productCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String photoPath,  DateTime scanDate,  int productCount)?  $default,) {final _that = this;
switch (_that) {
case _FridgeScan() when $default != null:
return $default(_that.id,_that.photoPath,_that.scanDate,_that.productCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _FridgeScan implements FridgeScan {
  const _FridgeScan({required this.id, required this.photoPath, required this.scanDate, required this.productCount});
  factory _FridgeScan.fromJson(Map<String, dynamic> json) => _$FridgeScanFromJson(json);

@override final  int id;
@override final  String photoPath;
@override final  DateTime scanDate;
@override final  int productCount;

/// Create a copy of FridgeScan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FridgeScanCopyWith<_FridgeScan> get copyWith => __$FridgeScanCopyWithImpl<_FridgeScan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FridgeScanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FridgeScan&&(identical(other.id, id) || other.id == id)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.scanDate, scanDate) || other.scanDate == scanDate)&&(identical(other.productCount, productCount) || other.productCount == productCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,photoPath,scanDate,productCount);

@override
String toString() {
  return 'FridgeScan(id: $id, photoPath: $photoPath, scanDate: $scanDate, productCount: $productCount)';
}


}

/// @nodoc
abstract mixin class _$FridgeScanCopyWith<$Res> implements $FridgeScanCopyWith<$Res> {
  factory _$FridgeScanCopyWith(_FridgeScan value, $Res Function(_FridgeScan) _then) = __$FridgeScanCopyWithImpl;
@override @useResult
$Res call({
 int id, String photoPath, DateTime scanDate, int productCount
});




}
/// @nodoc
class __$FridgeScanCopyWithImpl<$Res>
    implements _$FridgeScanCopyWith<$Res> {
  __$FridgeScanCopyWithImpl(this._self, this._then);

  final _FridgeScan _self;
  final $Res Function(_FridgeScan) _then;

/// Create a copy of FridgeScan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? photoPath = null,Object? scanDate = null,Object? productCount = null,}) {
  return _then(_FridgeScan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,scanDate: null == scanDate ? _self.scanDate : scanDate // ignore: cast_nullable_to_non_nullable
as DateTime,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
