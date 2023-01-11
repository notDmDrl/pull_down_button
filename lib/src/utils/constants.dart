import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Pull-down menu animation duration.
@internal
const Duration kMenuDuration = Duration(milliseconds: 335);

/// Pull-down menu animation curve.
@internal
const Curve kCurve = Curves.linearToEaseOut;

/// Pull-down menu reverse animation curve.
@internal
const Curve kCurveReverse = Curves.easeInToLinear;
