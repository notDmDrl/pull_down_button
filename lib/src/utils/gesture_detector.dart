import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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

  Future<void> onTap() async {
    await widget.onTap!();

    if (mounted) {
      setState(() {
        isPressed = false;
        isHovered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: enabled && kIsWeb //
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: enabled ? (_) => setState(() => isHovered = true) : null,
        onExit: enabled ? (_) => setState(() => isHovered = false) : null,
        hitTestBehavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          onTapDown: enabled ? (_) => setState(() => isPressed = true) : null,
          onTapCancel: enabled ? () => setState(() => isPressed = false) : null,
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
