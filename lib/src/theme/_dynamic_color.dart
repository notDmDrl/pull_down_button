import 'package:flutter/cupertino.dart';

import '/src/internals/brightness.dart';

/// Simplified copy of [CupertinoDynamicColor] used to hold two [Color] values,
/// one for light and one dark themes, instead of 8 [Color] values.
@immutable
final class SimpleDynamicColor {
  /// Creates [SimpleDynamicColor].
  const SimpleDynamicColor({
    required this.color,
    required this.darkColor,
  });

  /// The color to use when the [BuildContext] implies a light mode.
  final Color color;

  /// The color to use when the [BuildContext] implies a dark mode.
  final Color darkColor;

  /// Resolves this [SimpleDynamicColor] using the provided [BuildContext].
  Color resolveFrom(
    BuildContext context,
  ) => switch (menuBrightnessOf(context)) {
    Brightness.light => color,
    Brightness.dark => darkColor,
  };
}
