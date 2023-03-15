import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Pull-down menu animation duration.
@internal
const Duration kMenuDuration = Duration(milliseconds: 300);

/// Pull-down menu animation curve.
@internal
const Curve kCurve = Cubic(0.075, 0.82, 0.4, 1.065);

/// Pull-down menu reverse animation curve.
@internal
const Curve kCurveReverse = Curves.easeIn;

/// Since [kCurve] has an overshoot at the end and only [ScaleTransition]
/// requires it, [ClampedAnimation] is introduced for every other
/// *Transition* widget.
@internal
class ClampedAnimation extends Animation<double> {
  /// Creates [ClampedAnimation].
  ClampedAnimation(this.parent);

  /// The curve to clamp.
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
