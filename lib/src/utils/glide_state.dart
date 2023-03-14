import 'package:meta/meta.dart';

///
// TODO(salvatore): need doc
@immutable
@internal
abstract class MenuGlideState {}

///
// TODO(salvatore): need doc
@immutable
@internal
class MenuGlideInitState implements MenuGlideState {}

///
// TODO(salvatore): need doc
@immutable
@internal
class MenuGlideCompleteState implements MenuGlideState {}

///
// TODO(salvatore): need doc
@immutable
@internal
class MenuGlideInProcessState implements MenuGlideState {
  ///
  // TODO(salvatore): need doc
  const MenuGlideInProcessState({
    required this.dy,
    required this.dx,
  });

  ///
  // TODO(salvatore): need doc
  final double dy;

  ///
  // TODO(salvatore): need doc
  final double dx;
}
