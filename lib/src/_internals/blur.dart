import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Check if the menu's background color is not fully opaque.
///
/// Returns false if [color] has no transparency. If so, [BackdropFilter] will
/// not be used, since it will be redundant. Also in some cases this might
/// help with performance and/or visual bugs
@internal
bool useBackdropFilter(Color color) => color.alpha != 0xFF;

/// Pull-down menu background blur.
const double _kBlurAmount = 50;

/// Blur used by [BackdropFilter] if [useBackdropFilter] is `true`.
@internal
final kPullDownMenuBlur =
    ui.ImageFilter.blur(sigmaX: _kBlurAmount, sigmaY: _kBlurAmount);
