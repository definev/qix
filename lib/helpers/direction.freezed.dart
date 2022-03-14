// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'direction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DirectionTearOff {
  const _$DirectionTearOff();

  DirectionUp up() {
    return const DirectionUp();
  }

  DirectionDown down() {
    return const DirectionDown();
  }

  DirectionLeft left() {
    return const DirectionLeft();
  }

  DirectionRight right() {
    return const DirectionRight();
  }

  DirectionNone none([Direction? boundaryDirection]) {
    return DirectionNone(
      boundaryDirection,
    );
  }
}

/// @nodoc
const $Direction = _$DirectionTearOff();

/// @nodoc
mixin _$Direction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() up,
    required TResult Function() down,
    required TResult Function() left,
    required TResult Function() right,
    required TResult Function(Direction? boundaryDirection) none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DirectionUp value) up,
    required TResult Function(DirectionDown value) down,
    required TResult Function(DirectionLeft value) left,
    required TResult Function(DirectionRight value) right,
    required TResult Function(DirectionNone value) none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DirectionCopyWith<$Res> {
  factory $DirectionCopyWith(Direction value, $Res Function(Direction) then) =
      _$DirectionCopyWithImpl<$Res>;
}

/// @nodoc
class _$DirectionCopyWithImpl<$Res> implements $DirectionCopyWith<$Res> {
  _$DirectionCopyWithImpl(this._value, this._then);

  final Direction _value;
  // ignore: unused_field
  final $Res Function(Direction) _then;
}

/// @nodoc
abstract class $DirectionUpCopyWith<$Res> {
  factory $DirectionUpCopyWith(
          DirectionUp value, $Res Function(DirectionUp) then) =
      _$DirectionUpCopyWithImpl<$Res>;
}

/// @nodoc
class _$DirectionUpCopyWithImpl<$Res> extends _$DirectionCopyWithImpl<$Res>
    implements $DirectionUpCopyWith<$Res> {
  _$DirectionUpCopyWithImpl(
      DirectionUp _value, $Res Function(DirectionUp) _then)
      : super(_value, (v) => _then(v as DirectionUp));

  @override
  DirectionUp get _value => super._value as DirectionUp;
}

/// @nodoc

class _$DirectionUp implements DirectionUp {
  const _$DirectionUp();

  @override
  String toString() {
    return 'Direction.up()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DirectionUp);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() up,
    required TResult Function() down,
    required TResult Function() left,
    required TResult Function() right,
    required TResult Function(Direction? boundaryDirection) none,
  }) {
    return up();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
  }) {
    return up?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
    required TResult orElse(),
  }) {
    if (up != null) {
      return up();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DirectionUp value) up,
    required TResult Function(DirectionDown value) down,
    required TResult Function(DirectionLeft value) left,
    required TResult Function(DirectionRight value) right,
    required TResult Function(DirectionNone value) none,
  }) {
    return up(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
  }) {
    return up?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
    required TResult orElse(),
  }) {
    if (up != null) {
      return up(this);
    }
    return orElse();
  }
}

abstract class DirectionUp implements Direction {
  const factory DirectionUp() = _$DirectionUp;
}

/// @nodoc
abstract class $DirectionDownCopyWith<$Res> {
  factory $DirectionDownCopyWith(
          DirectionDown value, $Res Function(DirectionDown) then) =
      _$DirectionDownCopyWithImpl<$Res>;
}

/// @nodoc
class _$DirectionDownCopyWithImpl<$Res> extends _$DirectionCopyWithImpl<$Res>
    implements $DirectionDownCopyWith<$Res> {
  _$DirectionDownCopyWithImpl(
      DirectionDown _value, $Res Function(DirectionDown) _then)
      : super(_value, (v) => _then(v as DirectionDown));

  @override
  DirectionDown get _value => super._value as DirectionDown;
}

/// @nodoc

class _$DirectionDown implements DirectionDown {
  const _$DirectionDown();

  @override
  String toString() {
    return 'Direction.down()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DirectionDown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() up,
    required TResult Function() down,
    required TResult Function() left,
    required TResult Function() right,
    required TResult Function(Direction? boundaryDirection) none,
  }) {
    return down();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
  }) {
    return down?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
    required TResult orElse(),
  }) {
    if (down != null) {
      return down();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DirectionUp value) up,
    required TResult Function(DirectionDown value) down,
    required TResult Function(DirectionLeft value) left,
    required TResult Function(DirectionRight value) right,
    required TResult Function(DirectionNone value) none,
  }) {
    return down(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
  }) {
    return down?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
    required TResult orElse(),
  }) {
    if (down != null) {
      return down(this);
    }
    return orElse();
  }
}

abstract class DirectionDown implements Direction {
  const factory DirectionDown() = _$DirectionDown;
}

/// @nodoc
abstract class $DirectionLeftCopyWith<$Res> {
  factory $DirectionLeftCopyWith(
          DirectionLeft value, $Res Function(DirectionLeft) then) =
      _$DirectionLeftCopyWithImpl<$Res>;
}

/// @nodoc
class _$DirectionLeftCopyWithImpl<$Res> extends _$DirectionCopyWithImpl<$Res>
    implements $DirectionLeftCopyWith<$Res> {
  _$DirectionLeftCopyWithImpl(
      DirectionLeft _value, $Res Function(DirectionLeft) _then)
      : super(_value, (v) => _then(v as DirectionLeft));

  @override
  DirectionLeft get _value => super._value as DirectionLeft;
}

/// @nodoc

class _$DirectionLeft implements DirectionLeft {
  const _$DirectionLeft();

  @override
  String toString() {
    return 'Direction.left()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DirectionLeft);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() up,
    required TResult Function() down,
    required TResult Function() left,
    required TResult Function() right,
    required TResult Function(Direction? boundaryDirection) none,
  }) {
    return left();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
  }) {
    return left?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
    required TResult orElse(),
  }) {
    if (left != null) {
      return left();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DirectionUp value) up,
    required TResult Function(DirectionDown value) down,
    required TResult Function(DirectionLeft value) left,
    required TResult Function(DirectionRight value) right,
    required TResult Function(DirectionNone value) none,
  }) {
    return left(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
  }) {
    return left?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
    required TResult orElse(),
  }) {
    if (left != null) {
      return left(this);
    }
    return orElse();
  }
}

abstract class DirectionLeft implements Direction {
  const factory DirectionLeft() = _$DirectionLeft;
}

/// @nodoc
abstract class $DirectionRightCopyWith<$Res> {
  factory $DirectionRightCopyWith(
          DirectionRight value, $Res Function(DirectionRight) then) =
      _$DirectionRightCopyWithImpl<$Res>;
}

/// @nodoc
class _$DirectionRightCopyWithImpl<$Res> extends _$DirectionCopyWithImpl<$Res>
    implements $DirectionRightCopyWith<$Res> {
  _$DirectionRightCopyWithImpl(
      DirectionRight _value, $Res Function(DirectionRight) _then)
      : super(_value, (v) => _then(v as DirectionRight));

  @override
  DirectionRight get _value => super._value as DirectionRight;
}

/// @nodoc

class _$DirectionRight implements DirectionRight {
  const _$DirectionRight();

  @override
  String toString() {
    return 'Direction.right()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DirectionRight);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() up,
    required TResult Function() down,
    required TResult Function() left,
    required TResult Function() right,
    required TResult Function(Direction? boundaryDirection) none,
  }) {
    return right();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
  }) {
    return right?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
    required TResult orElse(),
  }) {
    if (right != null) {
      return right();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DirectionUp value) up,
    required TResult Function(DirectionDown value) down,
    required TResult Function(DirectionLeft value) left,
    required TResult Function(DirectionRight value) right,
    required TResult Function(DirectionNone value) none,
  }) {
    return right(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
  }) {
    return right?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
    required TResult orElse(),
  }) {
    if (right != null) {
      return right(this);
    }
    return orElse();
  }
}

abstract class DirectionRight implements Direction {
  const factory DirectionRight() = _$DirectionRight;
}

/// @nodoc
abstract class $DirectionNoneCopyWith<$Res> {
  factory $DirectionNoneCopyWith(
          DirectionNone value, $Res Function(DirectionNone) then) =
      _$DirectionNoneCopyWithImpl<$Res>;
  $Res call({Direction? boundaryDirection});

  $DirectionCopyWith<$Res>? get boundaryDirection;
}

/// @nodoc
class _$DirectionNoneCopyWithImpl<$Res> extends _$DirectionCopyWithImpl<$Res>
    implements $DirectionNoneCopyWith<$Res> {
  _$DirectionNoneCopyWithImpl(
      DirectionNone _value, $Res Function(DirectionNone) _then)
      : super(_value, (v) => _then(v as DirectionNone));

  @override
  DirectionNone get _value => super._value as DirectionNone;

  @override
  $Res call({
    Object? boundaryDirection = freezed,
  }) {
    return _then(DirectionNone(
      boundaryDirection == freezed
          ? _value.boundaryDirection
          : boundaryDirection // ignore: cast_nullable_to_non_nullable
              as Direction?,
    ));
  }

  @override
  $DirectionCopyWith<$Res>? get boundaryDirection {
    if (_value.boundaryDirection == null) {
      return null;
    }

    return $DirectionCopyWith<$Res>(_value.boundaryDirection!, (value) {
      return _then(_value.copyWith(boundaryDirection: value));
    });
  }
}

/// @nodoc

class _$DirectionNone implements DirectionNone {
  const _$DirectionNone([this.boundaryDirection]);

  @override
  final Direction? boundaryDirection;

  @override
  String toString() {
    return 'Direction.none(boundaryDirection: $boundaryDirection)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DirectionNone &&
            const DeepCollectionEquality()
                .equals(other.boundaryDirection, boundaryDirection));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(boundaryDirection));

  @JsonKey(ignore: true)
  @override
  $DirectionNoneCopyWith<DirectionNone> get copyWith =>
      _$DirectionNoneCopyWithImpl<DirectionNone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() up,
    required TResult Function() down,
    required TResult Function() left,
    required TResult Function() right,
    required TResult Function(Direction? boundaryDirection) none,
  }) {
    return none(boundaryDirection);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
  }) {
    return none?.call(boundaryDirection);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? up,
    TResult Function()? down,
    TResult Function()? left,
    TResult Function()? right,
    TResult Function(Direction? boundaryDirection)? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(boundaryDirection);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DirectionUp value) up,
    required TResult Function(DirectionDown value) down,
    required TResult Function(DirectionLeft value) left,
    required TResult Function(DirectionRight value) right,
    required TResult Function(DirectionNone value) none,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DirectionUp value)? up,
    TResult Function(DirectionDown value)? down,
    TResult Function(DirectionLeft value)? left,
    TResult Function(DirectionRight value)? right,
    TResult Function(DirectionNone value)? none,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class DirectionNone implements Direction {
  const factory DirectionNone([Direction? boundaryDirection]) = _$DirectionNone;

  Direction? get boundaryDirection;
  @JsonKey(ignore: true)
  $DirectionNoneCopyWith<DirectionNone> get copyWith =>
      throw _privateConstructorUsedError;
}
