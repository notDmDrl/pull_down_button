import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'gesture_detector.dart';

/// A widget that tracks an [SwipeState] of current global "pan" offset.
///
/// [SwipeRegion] is used to track and provide said [SwipeState] to all
/// descendants in [child] widget.
///
/// To provide [SwipeState] updates to descendants an [InheritedNotifier] is
/// used.
///
/// Descendants listen to [SwipeState] changes using [SwipeState.maybeOf].
@immutable
@internal
class SwipeRegion extends StatefulWidget {
  /// Creates [SwipeRegion].
  const SwipeRegion({
    super.key,
    required this.child,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<SwipeRegion> createState() => _SwipeRegionState();
}

class _SwipeRegionState extends State<SwipeRegion> {
  late final _state = ValueNotifier<SwipeState>(const SwipeInitState._());

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) =>
      _state.value = SwipeInProcessState._(
        offset: details.globalPosition,
      );

  void _onPanEnd(DragEndDetails _) =>
      _state.value = const SwipeCompleteState._();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: _SwipeState(
          notifier: _state,
          child: widget.child,
        ),
      );
}

/// Is internally used to provide [SwipeState] to
/// [MenuActionGestureDetector] of each "button" action item in the pull-down
/// menu.
@immutable
class _SwipeState extends InheritedNotifier<ValueNotifier<SwipeState>> {
  const _SwipeState({
    required super.notifier,
    required super.child,
  });

  /// The closest nullable instance of this class that encloses the given
  /// context.
  static SwipeState? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_SwipeState>()
      ?.notifier
      ?.value;
}

/// Basic continuous swipe state class.
@immutable
@internal
@sealed
abstract class SwipeState {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const SwipeState._();

  /// The closest nullable instance of this class that encloses the given
  /// context.
  static SwipeState? maybeOf(BuildContext context) =>
      _SwipeState.maybeOf(context);
}

/// Initial continuous swipe state, the user has not yet initiated the movement.
@immutable
@internal
class SwipeInitState implements SwipeState {
  const SwipeInitState._();
}

/// The coordinates of the movement are transmitted, the user in the process of
/// selecting the menu item.
@immutable
@internal
class SwipeInProcessState implements SwipeState {
  const SwipeInProcessState._({
    required this.offset,
  });

  /// The offset of the current global "pan".
  final Offset offset;

  /// Determines whether a menu item is selected based on the current finger
  /// position ([offset]), menu [itemSize] and [itemPosition].
  bool isWithinMenuItem({
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
class SwipeCompleteState implements SwipeState {
  const SwipeCompleteState._();
}
