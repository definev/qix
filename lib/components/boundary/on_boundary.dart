import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_boundary.freezed.dart';

@freezed
class OnBoundary with _$OnBoundary {
  const factory OnBoundary.left() = _Left;
  const factory OnBoundary.right() = _Right;
  const factory OnBoundary.top() = _Top;
  const factory OnBoundary.bottom() = _Bottom;
  const factory OnBoundary.none() = _None;
}
