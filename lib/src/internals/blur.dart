import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

import 'brightness.dart';

/// A set of blur utils.
///
/// All of the values were eyeballed using the iOS 16 Simulator.
abstract final class BlurUtils {
  /// Check if the menu's background color is not fully opaque.
  ///
  /// Returns false if [color] has no transparency. If so, [BackdropFilter] will
  /// not be used since it will be redundant. Also, in some cases, this might
  /// help with performance or visual bugs.
  static bool useBackdropFilter(Color color) => color.a != 1;

  /// Menu background blur.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  static const double _kBlurSigma = 30;

  /// Blur used by [ImageFilter.compose] as an outer filter.
  static final _menuBlur = ImageFilter.blur(
    sigmaX: _kBlurSigma,
    sigmaY: _kBlurSigma,
  );

  /// Blur used by [BackdropFilter] if [BlurUtils.useBackdropFilter] is `true`.
  static ImageFilter menuBlur(BuildContext context) {
    // Reasoning https://github.com/flutter/flutter/pull/121829#issuecomment-1494714917.
    if (kIsWeb) {
      return _menuBlur;
    }

    final Brightness brightness = menuBrightnessOf(context);

    return ImageFilter.compose(
      inner: switch (brightness) {
        Brightness.dark => _darkSaturationMatrix,
        Brightness.light => _lightSaturationMatrix,
      },
      outer: _menuBlur,
    );
  }
}

// Taken from [CupertinoPopupSurface]
// dart format off
const _lightSaturationMatrix = ColorFilter.matrix(<double>[
  1.74, -0.40, -0.17, 0, 0,
  -0.26, 1.60, -0.17, 0, 0,
  -0.26, -0.40, 1.83, 0, 0,
  0, 0, 0, 1, 0,
]);

const _darkSaturationMatrix = ColorFilter.matrix(<double>[
  1.39, -0.56, -0.11, 0, 0.30,
  -0.32, 1.14, -0.11, 0, 0.30,
  -0.32, -0.56, 1.59, 0, 0.30,
  0, 0, 0, 1, 0,
]);
// dart format on
