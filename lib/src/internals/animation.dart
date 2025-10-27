/// @docImport 'package:flutter/material.dart';
/// @docImport '/src/theme/route_theme.dart';
library;

import 'package:flutter/animation.dart';

/// A set of animation utils.
///
/// All of the values were eyeballed using the iOS 16 Simulator.
abstract final class AnimationUtils {
  /// Pull-down menu open / close animation duration.
  ///
  /// The value was deducted using comparison with native variant.
  static const kMenuDuration = Duration(milliseconds: 300);

  /// Pull-down menu animation curve on size change (ex. on text scale change).
  ///
  /// Eyeballed by comparison with native variant.
  static const Curve kOnSizeChangeCurve = Curves.fastOutSlowIn;

  /// Pull-down menu animation curve used on menu open.
  ///
  /// A cubic animation curve that starts slowly and ends with an overshoot of
  /// its bounds before reaching its end.
  static const Curve kCurve = Cubic(0.075, 0.82, 0.4, 1.065);

  /// Pull-down menu animation curve used when closing a menu.
  static const Curve kCurveReverse = Curves.easeIn;

  /// A curve tween for [PullDownMenuRouteTheme.shadow].
  static final shadowTween = CurveTween(curve: const Interval(1 / 3, 1));
}

/// An animation that clamps its parent value between `0` and `1`.
///
/// Since [AnimationUtils.kCurve] has an overshoot at the end and only
/// [ScaleTransition] requires it, [ClampedAnimation] is introduced for every
/// other *Transition* widget.
final class ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  /// Creates [ClampedAnimation].
  ClampedAnimation(this.parent);

  @override
  final Animation<double> parent;

  @override
  double get value => parent.value.clamp(0, 1);
}
