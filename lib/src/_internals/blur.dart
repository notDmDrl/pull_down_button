import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// A set of blur utils.
@internal
abstract class BlurUtils {
  // TODO(notDmdrl): if it ever be decided to bump minimum dart version to 3.0
  // migrate to class modifiers
  // `abstract final class BlurUtils` and remove this constructor.
  const BlurUtils._();

  /// Check if the menu's background color is not fully opaque.
  ///
  /// Returns false if [color] has no transparency. If so, [BackdropFilter] will
  /// not be used, since it will be redundant. Also in some cases this might
  /// help with performance and/or visual bugs.
  static bool useBackdropFilter(Color color) => color.alpha != 0xFF;

  /// Pull-down menu background blur.
  ///
  /// Derived from iOS Sketch Library. See https://developer.apple.com/design/resources/
  static const double _kBlurAmount = 50;

  /// Blur used by [BackdropFilter] if [BlurUtils.useBackdropFilter] is `true`.
  static final pullDownMenuBlur =
      ui.ImageFilter.blur(sigmaX: _kBlurAmount, sigmaY: _kBlurAmount);
}
