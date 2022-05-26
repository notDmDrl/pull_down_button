import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Minimum space from screen edges for pull-down menu to be rendered from.
@internal
const double kMenuScreenPadding = 8;

/// Intrinsic width step
@internal
const double kMenuWidthStep = 250;

/// Pull-down menu animation duration.
@internal
const Duration kMenuDuration = Duration(milliseconds: 335);

/// Pull-down menu animation curve (slightly modified [Curves.easeOutBack]).
@internal
const Curve kCurve = Cubic(0.175, 0.885, 0.265, 1.175);

/// Pull-down menu close animation curve.
@internal
const Curve kCloseCurve = Curves.linearToEaseOut;

/// Pull-down menu border radius.
@internal
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(12));

/// Pull-down menu size constraints.
@internal
const BoxConstraints kPopupMenuConstraints =
    BoxConstraints.tightFor(width: 250);

/// Pull-down menu background blur.
@internal
const double kBlurAmount = 50;
