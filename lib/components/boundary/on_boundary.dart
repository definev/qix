import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boundary.freezed.dart';

@freezed
class Boundary with _$Boundary {
  const factory Boundary.left() = _Left;
  const factory Boundary.right() = _Right;
  const factory Boundary.top() = _Top;
  const factory Boundary.bottom() = _Bottom;
  const factory Boundary.none() = _None;
}
