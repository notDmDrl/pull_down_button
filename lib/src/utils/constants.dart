import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Pull-down menu animation duration.
@internal
const Duration kMenuDuration = Duration(milliseconds: 300);

/// Pull-down menu animation curve.
@internal
const Curve kCurve = Cubic(0.075, 0.82, 0.185, 1.065);

/// Pull-down menu reverse animation curve.
@internal
const Curve kCurveReverse = Curves.easeIn;
