/// @docImport '/pull_down_button.dart';
/// @docImport '/src/items/divider.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '_dynamic_color.dart';
import 'theme.dart';

/// Defines the visual properties of the dividers in pull-down menus.
///
/// Is used by [PullDownMenuDivider] and [PullDownMenuSeparator].
///
/// Typically a [PullDownMenuDividerTheme] is specified as part of the overall
/// [PullDownButtonTheme] with [PullDownButtonTheme.dividerTheme].
///
/// All [PullDownMenuDividerTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuDividerTheme.defaults].
@immutable
final class PullDownMenuDividerTheme with Diagnosticable {
  /// Creates the set of properties used to configure
  /// [PullDownMenuDividerTheme].
  const PullDownMenuDividerTheme({
    this.dividerColor,
    this.largeDividerColor,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch and
  /// Figma libraries for iOS 18 and iPadOS 18.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  @internal
  const factory PullDownMenuDividerTheme.defaults(BuildContext context) =
      _Defaults;

  /// The color of the [PullDownMenuSeparator].
  final Color? dividerColor;

  /// The color of the [PullDownMenuDivider].
  final Color? largeDividerColor;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuDividerTheme copyWith({
    Color? dividerColor,
    Color? largeDividerColor,
  }) => PullDownMenuDividerTheme(
    dividerColor: dividerColor ?? this.dividerColor,
    largeDividerColor: largeDividerColor ?? this.largeDividerColor,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuDividerTheme lerp(
    PullDownMenuDividerTheme? a,
    PullDownMenuDividerTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuDividerTheme(
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      largeDividerColor: Color.lerp(
        a?.largeDividerColor,
        b?.largeDividerColor,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hash(dividerColor, largeDividerColor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuDividerTheme &&
        other.dividerColor == dividerColor &&
        other.largeDividerColor == largeDividerColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('dividerColor', dividerColor, defaultValue: null))
      ..add(
        ColorProperty(
          'largeDividerColor',
          largeDividerColor,
          defaultValue: null,
        ),
      );
  }
}

/// A set of default values for [PullDownMenuDividerTheme].
@immutable
final class _Defaults extends PullDownMenuDividerTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context);

  /// A build context used to resolve [SimpleDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark colors of the [PullDownMenuSeparator].
  static const kDividerColor = SimpleDynamicColor(
    color: Color.fromRGBO(128, 128, 128, 0.55),
    darkColor: Color.fromRGBO(128, 128, 128, 0.7),
  );

  /// The light and dark colors of the [PullDownMenuDivider].
  static const kLargeDividerColor = SimpleDynamicColor(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    darkColor: Color.fromRGBO(0, 0, 0, 0.16),
  );

  @override
  Color get dividerColor => kDividerColor.resolveFrom(context);

  @override
  Color get largeDividerColor => kLargeDividerColor.resolveFrom(context);
}
