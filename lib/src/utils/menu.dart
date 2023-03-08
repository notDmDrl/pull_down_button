import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'constants.dart';
import 'route.dart';

/// Pull-down menu background blur.
const double _kBlurAmount = 50;

/// Pull-down menu displayed by [PullDownButton] or [showPullDownMenu].
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

  /// Items to show in the menu.
  final List<PullDownMenuEntry> items;

  /// A per menu custom theme.
  ///
  /// Final theme is resolved using [PullDownMenuRouteTheme.resolve].
  final PullDownMenuRouteTheme? routeTheme;

  /// An animation provided by [PullDownMenuRoute] for scale, fade and size
  /// transitions.
  final Animation<double> animation;

  /// The point menu scales from.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme =
        PullDownMenuRouteTheme.resolve(context, routeTheme: routeTheme);

    final shadowTween = DecorationTween(
      begin: BoxDecoration(boxShadow: [theme.beginShadow!]),
      end: BoxDecoration(boxShadow: [theme.endShadow!]),
    );

    // Since [kCurve] has an overshoot at the end and only [ScaleTransition]
    // requires it, [_ClampedAnimation] is introduced for every other
    // *Transition* widget.
    final clampedAnimation = _ClampedAnimation(animation);

    final shadow = CurveTween(curve: const Interval(1 / 3, 1));

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: DecoratedBoxTransition(
        decoration: shadow.animate(clampedAnimation).drive(shadowTween),
        child: FadeTransition(
          opacity: clampedAnimation,
          child: _Decoration(
            backgroundColor: theme.backgroundColor!,
            borderRadius: theme.borderRadius!,
            child: FadeTransition(
              opacity: clampedAnimation,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: theme.width,
                ),
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: clampedAnimation,
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
  /// Creates [_Decoration].
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

/// Menu body - scrollbar, list of [PullDownMenuEntry].
@immutable
class _MenuBody extends StatefulWidget {
  /// Creates [_MenuBody].
  const _MenuBody({
    required this.children,
  });

  final List<PullDownMenuEntry> children;

  @override
  State<_MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<_MenuBody> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: 'Pull-Down menu',
        child: CupertinoScrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            primary: false,
            controller: scrollController,
            child: ListBody(children: widget.children),
          ),
        ),
      );
}

/// Since [kCurve] has an overshoot at the end and only [ScaleTransition]
/// requires it, [_ClampedAnimation] is introduced for every other
/// *Transition* widget.
class _ClampedAnimation extends Animation<double> {
  /// Creates [_ClampedAnimation].
  _ClampedAnimation(this.parent);

  final Animation<double> parent;

  @override
  void addListener(VoidCallback listener) => parent.addListener(listener);

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      parent.addStatusListener(listener);

  @override
  void removeListener(VoidCallback listener) => parent.removeListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      parent.removeStatusListener(listener);

  @override
  AnimationStatus get status => parent.status;

  @override
  double get value => parent.value.clamp(0, 1);
}
