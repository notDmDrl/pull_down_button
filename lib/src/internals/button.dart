/// @docImport '/src/items/header.dart';
/// @docImport '/src/items/item.dart';
library;

import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'continuous_swipe.dart';
import 'extensions.dart';

/// Default menu gesture detector for applying on-pressed or on-hover colors,
/// and providing builder method that exposes the `isHovered` state to
/// descendant widgets.
@immutable
class MenuActionButton extends StatefulWidget {
  /// Creates [MenuActionButton].
  const MenuActionButton({
    super.key,
    required this.onTap,
    required this.pressedColor,
    required this.hoverColor,
    required this.child,
  });

  /// Called when the menu item is tapped.
  final GestureTapCallback? onTap;

  /// Color of container during a press event.
  final Color pressedColor;

  /// Color of container during a hover event.
  final Color hoverColor;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<MenuActionButton> createState() => _MenuActionButtonState();
}

class _MenuActionButtonState extends State<MenuActionButton> {
  var _isPressed = false;
  var _isHovered = false;

  late final enabled = widget.onTap != null;

  Offset get _currentPosition =>
      context.currentRenderBox.localToGlobal(Offset.zero);

  Size get _currentSize => context.currentRenderBox.size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final SwipeState? swipeState = SwipeState.maybeOf(context);

    if (swipeState != null) {
      swipeStateListener(swipeState);
    }
  }

  void swipeStateListener(SwipeState state) {
    if (state is SwipeInProcessState && enabled) {
      final bool isWithinMenuItem = state.isWithinMenuItem(
        itemPosition: _currentPosition,
        itemSize: _currentSize,
      );

      if (isWithinMenuItem && !_isPressed) {
        unawaited(HapticFeedback.selectionClick());
      }

      setState(() => _isPressed = isWithinMenuItem);
    }

    if (state is SwipeCompleteState && _isPressed) {
      onTap();
    }
  }

  void onTap() {
    if (!enabled) {
      return;
    }

    widget.onTap!();

    if (mounted) {
      setState(() {
        _isPressed = false;
        _isHovered = false;
      });
    }
  }

  void onEnter(PointerEnterEvent _) {
    if (enabled && !_isHovered) {
      setState(() => _isHovered = true);
    }
  }

  void onExit(PointerExitEvent _) {
    if (enabled && _isHovered) {
      setState(() => _isHovered = false);
    }
  }

  void onTapDown(TapDownDetails _) {
    if (enabled && !_isPressed) {
      setState(() => _isPressed = true);
    }
  }

  void onTapUp(TapUpDetails _) {
    if (enabled && _isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void onTapCancel() {
    if (enabled && _isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: enabled && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
    onEnter: onEnter,
    onExit: onExit,
    hitTestBehavior: HitTestBehavior.opaque,
    child: GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              _isPressed
                  ? widget.pressedColor
                  : _isHovered
                  ? widget.hoverColor
                  : null,
        ),
        child: MenuActionButtonHoverState(
          isHovered: _isHovered && !_isPressed,
          child: widget.child,
        ),
      ),
    ),
  );
}

/// An inherited widget used to indicate if [PullDownMenuItem] is currently
/// hovered.
///
/// Is internally used by [MenuActionButton] to provide on-hover state to all
/// possible configurations of [PullDownMenuItem] and [PullDownMenuHeader].
@immutable
class MenuActionButtonHoverState extends InheritedWidget {
  /// Creates [MenuActionButtonHoverState].
  const MenuActionButtonHoverState({
    super.key,
    required this.isHovered,
    required super.child,
  });

  /// Whether a [PullDownMenuItem] is currently hovered.
  final bool isHovered;

  /// Returns the current hover state from the closest
  /// [MenuActionButtonHoverState] ancestor.
  static bool of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<MenuActionButtonHoverState>()!
          .isHovered;

  @override
  bool updateShouldNotify(MenuActionButtonHoverState oldWidget) =>
      isHovered != oldWidget.isHovered;
}
