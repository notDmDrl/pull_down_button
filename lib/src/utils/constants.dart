import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Minimum space from screen edges for pull-down menu to be rendered from.
@internal
const double kMenuScreenPadding = 8;

/// Pull-down menu animation duration.
@internal
const Duration kMenuDuration = Duration(milliseconds: 335);

/// Pull-down menu  animation curve.
@internal
const Curve kCurve = Curves.linearToEaseOut;

/// Pull-down menu border radius.
@internal
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(12));

/// Pull-down menu background blur.
@internal
const double kBlurAmount = 50;
