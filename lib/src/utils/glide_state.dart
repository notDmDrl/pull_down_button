import 'package:meta/meta.dart';

/// Basic glide state class
@immutable
@internal
abstract class MenuGlideState {}

/// Initial glide state, the user has not yet initiated the movement
@immutable
@internal
class MenuGlideInitState implements MenuGlideState {}

/// The coordinates of the movement are transmitted,
/// the user in the process of selecting the menu item
@immutable
@internal
class MenuGlideInProcessState implements MenuGlideState {
  /// Creates [MenuGlideInProcessState].
  const MenuGlideInProcessState({
    required this.dx,
    required this.dy,
  });

  /// The x component of the offset.
  final double dx;

  /// The y component of the offset.
  final double dy;
}

/// The state of the completed glide, the user has selected the item
@immutable
@internal
class MenuGlideCompleteState implements MenuGlideState {}
