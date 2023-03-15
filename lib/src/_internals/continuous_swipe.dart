import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Adds continuous swipe support to menus
@immutable
@internal
class MenuContinuousSwipe extends StatefulWidget {
  /// Creates [MenuContinuousSwipe] to support continuous swipe for menus
  const MenuContinuousSwipe({
    required this.child,
    super.key,
  });

  /// Menu widget that requires a continuous swipe
  final Widget child;

  @override
  State<MenuContinuousSwipe> createState() => MenuContinuousSwipeState();
}

/// Controls the state of the continuous swipe
/// and passes it down the widget tree
class MenuContinuousSwipeState extends State<MenuContinuousSwipe> {
  late final ValueNotifier<ContinuousSwipeState> _state;

  @override
  void initState() {
    _state = ValueNotifier<ContinuousSwipeState>(
      ContinuousSwipeInitState(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _state.dispose();

    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _state.value = ContinuousSwipeInProcessState(
      dy: details.globalPosition.dy,
      dx: details.globalPosition.dx,
    );
  }

  void _onPanEnd(DragEndDetails details) {
    _state.value = ContinuousSwipeCompleteState();
  }

  /// The closest instance of this class that encloses the given
  /// context.
  static ValueNotifier<ContinuousSwipeState>? of(BuildContext context) {
    return context.findAncestorStateOfType<MenuContinuousSwipeState>()?._state;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}

/// Basic continuous swipe state class
@immutable
@internal
abstract class ContinuousSwipeState {}

/// Initial continuous swipe state, the user has not yet initiated the movement
@immutable
@internal
class ContinuousSwipeInitState implements ContinuousSwipeState {}

/// The coordinates of the movement are transmitted,
/// the user in the process of selecting the menu item
@immutable
@internal
class ContinuousSwipeInProcessState implements ContinuousSwipeState {
  /// Creates [ContinuousSwipeInProcessState].
  const ContinuousSwipeInProcessState({
    required this.dx,
    required this.dy,
  });

  /// The x component of the offset.
  final double dx;

  /// The y component of the offset.
  final double dy;
}

/// The state of the completed continuous swipe, the user has selected the item
@immutable
@internal
class ContinuousSwipeCompleteState implements ContinuousSwipeState {}

/// Extension for the state when the user slides his finger over the menu,
/// needed to determine which menu item his finger is now on
extension CurrentPositionWithinMenuItemExt on ContinuousSwipeInProcessState {
  /// Determines whether a menu item is selected based on
  /// the current finger position ([dx]&[dy]),
  /// menu [itemSize] and [itemPosition]
  bool currentPositionWithinMenuItem({
    required Offset itemPosition,
    required Size itemSize,
  }) =>
      (dy >= itemPosition.dy && (itemPosition.dy + itemSize.height) > dy) &&
      (dx >= itemPosition.dx && (itemPosition.dx + itemSize.width) > dx);
}
