import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'constants.dart';
import 'route.dart';

// ignore_for_file: public_member_api_docs, comment_references

/// Copy of [_PopupMenu] from [PopupMenuButton] implementation since it's
/// private there.
@immutable
@internal
class PullDownMenu extends StatelessWidget {
  const PullDownMenu({
    super.key,
    required this.route,
  });

  final PullDownMenuRoute route;

  static DecorationTween _decorationTween(BoxShadow begin, BoxShadow end) =>
      DecorationTween(
        begin: BoxDecoration(boxShadow: [begin]),
        end: BoxDecoration(boxShadow: [end]),
      );

  static final opacityCurve = CurveTween(curve: const Interval(0, 1 / 3));

  @override
  Widget build(BuildContext context) {
    final routeTheme = route.routeTheme;

    final theme = PullDownMenuRouteTheme.of(context);
    final defaults = PullDownMenuRouteTheme.defaults(context);

    final beginShadow =
        routeTheme?.beginShadow ?? theme?.beginShadow ?? defaults.beginShadow!;
    final endShadow =
        routeTheme?.endShadow ?? theme?.endShadow ?? defaults.endShadow!;

    final shadowTween = _decorationTween(beginShadow, endShadow);

    // split open/close animation into to parts to remove unnecessary rebuilds.
    // animation for menu content.
    final innerAnimation = AnimatedBuilder(
      animation: route.animation!,
      builder: (_, child) {
        final animate = route.animation!;
        final evaluate = animate.value;

        return Center(
          widthFactor: evaluate,
          heightFactor: evaluate,
          child: FadeTransition(
            opacity: animate,
            child: child,
          ),
        );
      },
      child: _MenuBody(
        width: routeTheme?.width,
        children: route.items,
      ),
    );

    // Animation for menu decoration.
    return AnimatedBuilder(
      animation: route.animation!,
      builder: (_, child) {
        final animate = route.animation!;

        return FadeTransition(
          opacity: opacityCurve.animate(animate),
          child: DecoratedBoxTransition(
            decoration: shadowTween.animate(animate),
            child: child!,
          ),
        );
      },
      child: _Decoration(
        backgroundColor: routeTheme?.backgroundColor,
        borderRadius: routeTheme?.borderRadius,
        child: innerAnimation,
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
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  /// Check if the menu's background color is not fully opaque.
  ///
  /// Returns false if [color] has no transparency. If so, [BackdropFilter] will
  /// not be used, since it will be redundant. Also in some cases this might
  /// help with performance and/or visual bugs;
  static bool useBackdropFilter(Color color) => color.alpha != 0xFF;

  /// Blur used by [BackdropFilter] if [useBackdropFilter] is `true`.
  static final blur =
      ui.ImageFilter.blur(sigmaX: kBlurAmount, sigmaY: kBlurAmount);

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuRouteTheme.of(context);
    final defaults = PullDownMenuRouteTheme.defaults(context);

    final color =
        backgroundColor ?? theme?.backgroundColor ?? defaults.backgroundColor!;

    final radius =
        borderRadius ?? theme?.borderRadius ?? defaults.borderRadius!;

    Widget box = ColoredBox(
      color: color,
      child: child,
    );

    if (useBackdropFilter(color)) {
      box = BackdropFilter(
        filter: blur,
        child: box,
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: box,
    );
  }
}

/// Menu body - constrained width, scrollbar, list of [PullDownMenuEntry].
@immutable
class _MenuBody extends StatelessWidget {
  const _MenuBody({required this.children, required this.width});

  final List<Widget> children;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuRouteTheme.of(context);
    final defaults = PullDownMenuRouteTheme.defaults(context);

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: width ?? theme?.width ?? defaults.width!,
      ),
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: 'Pull-Down menu',
        child: CupertinoUserInterfaceLevel(
          data: CupertinoUserInterfaceLevelData.elevated,
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: ListBody(children: children),
            ),
          ),
        ),
      ),
    );
  }
}
