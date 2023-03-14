import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pull_down_button/src/utils/glide_state.dart';

import 'menu_config.dart';

// ignore_for_file: avoid_positional_boolean_parameters

/// Default menu gesture detector for applying on pressed color and / or on
/// hover color, and providing builder method that exposes `isHovered` state to
/// descendant widgets.
@immutable
@internal
class MenuActionGestureDetector extends StatefulWidget {
  /// Creates default menu gesture detector.
  const MenuActionGestureDetector({
    super.key,
    required this.onTap,
    required this.pressedColor,
    required this.hoverColor,
    required this.builder,
  });

  /// Called when the menu item is tapped.
  final FutureOr<void> Function()? onTap;

  /// Color of container during press event.
  final Color pressedColor;

  /// Color of container during hover event.
  final Color hoverColor;

  /// Builder that exposes `isHovered` state to descendant widgets.
  final Widget Function(BuildContext context, bool isHovered) builder;

  @override
  State<MenuActionGestureDetector> createState() =>
      _MenuActionGestureDetectorState();
}

class _MenuActionGestureDetectorState extends State<MenuActionGestureDetector> {
  bool isPressed = false;
  bool isHovered = false;

  late final enabled = widget.onTap != null;

  late final ValueNotifier<MenuGlideState> glideState;

  Offset get _currentPosition {
    final box = context.findRenderObject() as RenderBox;

    return box.localToGlobal(Offset.zero);
  }

  Size get _currentSize {
    final box = context.findRenderObject() as RenderBox;

    return box.size;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    glideState = MenuConfig.of(context).glideState;
    glideState.addListener(glideHandler);
  }

  void glideHandler() {
    if (glideState.value is MenuGlideInProcessState) {
      final dragState = glideState.value as MenuGlideInProcessState;

      final isInsideDy = dragState.dy >= _currentPosition.dy &&
          (_currentPosition.dy + _currentSize.height) > dragState.dy;

      final isInsideDx = dragState.dx >= _currentPosition.dx &&
          (_currentPosition.dx + _currentSize.width) > dragState.dx;

      if (isInsideDy && isInsideDx && enabled) {
        setState(() => isPressed = true);
      } else {
        setState(() => isPressed = false);
      }
    }

    if (glideState.value is MenuGlideCompleteState) {
      if (isPressed) onTap();
    }
  }

  Future<void> onTap() async {
    if (!enabled) return;

    await widget.onTap!();

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

  void onTapCancel() {
    if (enabled && isPressed) setState(() => isPressed = false);
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
          onTapCancel: onTapCancel,
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
            child: widget.builder(context, isHovered && !isPressed),
          ),
        ),
      );
}
