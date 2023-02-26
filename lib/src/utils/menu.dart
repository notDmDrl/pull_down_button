import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

// ignore_for_file: public_member_api_docs, comment_references

/// Pull-down menu background blur.
const double _kBlurAmount = 50;

/// Copy of [_PopupMenu] from [PopupMenuButton] implementation since it's
/// private there.
@immutable
@internal
class PullDownMenu extends StatelessWidget {
  /// Creates [PullDownMenu].
  const PullDownMenu({
    super.key,
    required this.items,
    required this.routeTheme,
    required this.alignment,
    required this.animation,
  });

  final List<PullDownMenuEntry> items;
  final PullDownMenuRouteTheme? routeTheme;
  final Animation<double> animation;
  final Alignment alignment;

  static DecorationTween _decorationTween(BoxShadow begin, BoxShadow end) =>
      DecorationTween(
        begin: BoxDecoration(boxShadow: [begin]),
        end: BoxDecoration(boxShadow: [end]),
      );

  @override
  Widget build(BuildContext context) {
    final theme =
        PullDownMenuRouteTheme.resolve(context, routeTheme: routeTheme);

    final shadowTween = _decorationTween(theme.beginShadow!, theme.endShadow!);

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: DecoratedBoxTransition(
        decoration: animation.drive(shadowTween),
        child: FadeTransition(
          opacity: animation,
          child: _Decoration(
            backgroundColor: theme.backgroundColor!,
            borderRadius: theme.borderRadius!,
            child: FadeTransition(
              opacity: animation,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: theme.width,
                ),
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: animation,
                  child: _MenuBody(
                    children: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu container - shape, blur, color.
@immutable
class _Decoration extends StatelessWidget {
  const _Decoration({
    required this.child,
    required this.backgroundColor,
    required this.borderRadius,
  });

  final Widget child;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  /// Check if the menu's background color is not fully opaque.
  ///
  /// Returns false if [color] has no transparency. If so, [BackdropFilter] will
  /// not be used, since it will be redundant. Also in some cases this might
  /// help with performance and/or visual bugs;
  static bool useBackdropFilter(Color color) => color.alpha != 0xFF;

  /// Blur used by [BackdropFilter] if [useBackdropFilter] is `true`.
  static final blur =
      ui.ImageFilter.blur(sigmaX: _kBlurAmount, sigmaY: _kBlurAmount);

  @override
  Widget build(BuildContext context) {
    Widget box = ColoredBox(
      color: backgroundColor,
      child: child,
    );

    if (useBackdropFilter(backgroundColor)) {
      box = BackdropFilter(
        filter: blur,
        child: box,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: box,
    );
  }
}

/// Menu body - constrained width, scrollbar, list of [PullDownMenuEntry].
@immutable
class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.children,
  });

  final List<PullDownMenuEntry> children;

  @override
  Widget build(BuildContext context) => Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: 'Pull-Down menu',
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            child: ListBody(children: children),
          ),
        ),
      );
}
