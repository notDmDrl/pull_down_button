import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../items/header.dart';
import '../items/item.dart';
import 'continuous_swipe.dart';
import 'extensions.dart';

/// Default menu gesture detector for applying on pressed color or on
/// hover color, and providing builder method that exposes the `isHovered`
/// state to descendant widgets.
@immutable
@internal
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

  /// Color of container during press event.
  final Color pressedColor;

  /// Color of container during hover event.
  final Color hoverColor;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<MenuActionButton> createState() => _MenuActionButtonState();
}

class _MenuActionButtonState extends State<MenuActionButton> {
  bool isPressed = false;
  bool isHovered = false;

  late final enabled = widget.onTap != null;

  Offset get _currentPosition =>
      context.currentRenderBox.localToGlobal(Offset.zero);

  Size get _currentSize => context.currentRenderBox.size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final swipeState = SwipeState.maybeOf(context);

    if (swipeState != null) swipeStateListener(swipeState);
  }

  void swipeStateListener(SwipeState state) {
    if (state is SwipeInProcessState && enabled) {
      final isWithinMenuItem = state.isWithinMenuItem(
        itemPosition: _currentPosition,
        itemSize: _currentSize,
      );

      if (isWithinMenuItem && !isPressed) {
        HapticFeedback.selectionClick();
      }

      setState(() => isPressed = isWithinMenuItem);
    }

    if (state is SwipeCompleteState && isPressed) {
      onTap();
    }
  }

  void onTap() {
    if (!enabled) return;

    widget.onTap!();

    if (mounted) {
      setState(() {
        isPressed = false;
        isHovered = false;
      });
    }
  }

  void onEnter(PointerEnterEvent _) {
    if (enabled && !isHovered) setState(() => isHovered = true);
  }

  void onExit(PointerExitEvent _) {
    if (enabled && isHovered) setState(() => isHovered = false);
  }

  void onTapDown(TapDownDetails _) {
    if (enabled && !isPressed) setState(() => isPressed = true);
  }

  void onTapUp(TapUpDetails _) {
    if (enabled && isPressed) setState(() => isPressed = false);
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: enabled && kIsWeb //
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: onEnter,
        onExit: onExit,
        hitTestBehavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTap: onTap,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          behavior: HitTestBehavior.opaque,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isPressed
                  ? widget.pressedColor
                  : isHovered
                      ? widget.hoverColor
                      : null,
            ),
            child: MenuActionButtonState(
              isHovered: isHovered && !isPressed,
              child: widget.child,
            ),
          ),
        ),
      );
}

/// An inherited widget used to indicate if [PullDownMenuItem] is currently
/// hovered.
///
/// Is internally used by [MenuActionButton] to provide on hover state to all
/// possible configurations of [PullDownMenuItem] and [PullDownMenuHeader].
@immutable
@internal
class MenuActionButtonState extends InheritedWidget {
  /// Creates [MenuActionButtonState].
  const MenuActionButtonState({
    super.key,
    required this.isHovered,
    required super.child,
  });

  /// Whether a [PullDownMenuItem] is currently hovered.
  final bool isHovered;

  /// Returns the current hover state from the closest [MenuActionButtonState]
  /// ancestor.
  static bool of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<MenuActionButtonState>()!
      .isHovered;

  @override
  bool updateShouldNotify(MenuActionButtonState oldWidget) =>
      isHovered != oldWidget.isHovered;
}
