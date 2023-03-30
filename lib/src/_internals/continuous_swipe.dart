import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Adds continuous swipe support to menus.
@immutable
@internal
class MenuContinuousSwipe extends StatefulWidget {
  /// Creates [MenuContinuousSwipe] to support continuous swipe for menus.
  const MenuContinuousSwipe({
    super.key,
    required this.child,
  });

  /// Menu widget that requires a continuous swipe.
  final Widget child;

  @override
  State<MenuContinuousSwipe> createState() => MenuContinuousSwipeState();
}

/// The [State] for a [MenuContinuousSwipe].
///
/// Controls the state of the continuous swipe and passes it down the widget
/// tree.
@internal
class MenuContinuousSwipeState extends State<MenuContinuousSwipe> {
  late final _state = ValueNotifier<ContinuousSwipeState>(
    const ContinuousSwipeInitState._(),
  );

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) =>
      _state.value = ContinuousSwipeInProcessState._(
        offset: details.globalPosition,
      );

  void _onPanEnd(DragEndDetails _) =>
      _state.value = const ContinuousSwipeCompleteState._();

  /// The closest instance of this class that encloses the given
  /// context.
  static ValueNotifier<ContinuousSwipeState>? of(BuildContext context) =>
      context.findAncestorStateOfType<MenuContinuousSwipeState>()?._state;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: widget.child,
      );
}

/// Basic continuous swipe state class.
@immutable
@internal
@sealed
abstract class ContinuousSwipeState {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ContinuousSwipeState._();
}

/// Initial continuous swipe state, the user has not yet initiated the movement.
@immutable
@internal
class ContinuousSwipeInitState implements ContinuousSwipeState {
  /// Creates [ContinuousSwipeInitState].
  const ContinuousSwipeInitState._();
}

/// The coordinates of the movement are transmitted, the user in the process of
/// selecting the menu item.
@immutable
@internal
class ContinuousSwipeInProcessState implements ContinuousSwipeState {
  /// Creates [ContinuousSwipeInProcessState].
  const ContinuousSwipeInProcessState._({
    required this.offset,
  });

  /// The offset of current continuous swipe.
  final Offset offset;

  /// Determines whether a menu item is selected based on the current finger
  /// position ([offset]), menu [itemSize] and [itemPosition].
  bool currentPositionWithinMenuItem({
    required Offset itemPosition,
    required Size itemSize,
  }) {
    final dy = offset.dy;
    final dx = offset.dx;

    final itemDY = itemPosition.dy;
    final itemDX = itemPosition.dx;

    return (dy >= itemDY && (itemDY + itemSize.height) > dy) &&
        (dx >= itemDX && (itemDX + itemSize.width) > dx);
  }
}

/// The state of the completed continuous swipe, the user has selected the item.
@immutable
@internal
class ContinuousSwipeCompleteState implements ContinuousSwipeState {
  /// Creates [ContinuousSwipeCompleteState].
  const ContinuousSwipeCompleteState._();
}
