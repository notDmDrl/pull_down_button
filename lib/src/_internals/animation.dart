import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

/// A set of animation utils.
@internal
abstract class AnimationUtils {
  // TODO(notDmdrl): if it ever be decided to bump minimum dart version to 3.0
  // migrate to class modifiers
  // `abstract final class AnimationUtils` and remove this constructor.
  const AnimationUtils._();

  /// Pull-down menu animation duration.
  static const Duration kMenuDuration = Duration(milliseconds: 300);

  /// Pull-down menu animation curve.
  static const Curve kCurve = Cubic(0.075, 0.82, 0.4, 1.065);

  /// Pull-down menu reverse animation curve.
  static const Curve kCurveReverse = Curves.easeIn;

  /// A shadow tween for [PullDownMenuRouteTheme.beginShadow] and
  /// [PullDownMenuRouteTheme.endShadow].
  static final CurveTween shadowTween = CurveTween(
    curve: const Interval(1 / 3, 1),
  );
}

/// Since [AnimationUtils.kCurve] has an overshoot at the end and only
/// [ScaleTransition] requires it, [ClampedAnimation] is introduced for every
/// other *Transition* widget.
@internal
class ClampedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  /// Creates [ClampedAnimation].
  ClampedAnimation(this.parent);

  /// The curve to clamp.
  @override
  final Animation<double> parent;

  @override
  double get value => parent.value.clamp(0, 1);
}
