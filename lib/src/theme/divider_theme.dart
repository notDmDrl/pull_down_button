import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

/// Defines the visual properties of the dividers in pull-down menus.
///
/// Is used by [PullDownMenuDivider] and vertical dividers in
/// [PullDownMenuActionsRow].
///
/// All [PullDownMenuDividerTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PullDownMenuDividerTheme.defaults].
@immutable
class PullDownMenuDividerTheme with Diagnosticable {
  /// Creates the set of properties used to configure
  /// [PullDownMenuDividerTheme].
  const PullDownMenuDividerTheme({
    this.dividerColor,
    this.largeDividerColor,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  @internal
  const factory PullDownMenuDividerTheme.defaults(BuildContext context) =
      _PullDownMenuDividerDefaults;

  /// The divider color of the pull-down menu divider [PullDownMenuDivider].
  final Color? dividerColor;

  /// The large divider color of the pull-down menu
  /// divider [PullDownMenuDivider.large].
  final Color? largeDividerColor;

  /// The [PullDownButtonTheme.dividerTheme] property of the ambient
  /// [PullDownButtonTheme].
  static PullDownMenuDividerTheme? of(BuildContext context) =>
      PullDownButtonTheme.of(context)?.dividerTheme;

  /// The helper method to quickly resolve [PullDownMenuDividerTheme] from
  /// [PullDownButtonTheme.dividerTheme] or [PullDownMenuDividerTheme.defaults].
  @internal
  static PullDownMenuDividerTheme resolve(BuildContext context) {
    final theme = PullDownMenuDividerTheme.of(context);
    final defaults = PullDownMenuDividerTheme.defaults(context);

    return theme ?? defaults;
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuDividerTheme copyWith({
    Color? dividerColor,
    Color? largeDividerColor,
  }) =>
      PullDownMenuDividerTheme(
        dividerColor: dividerColor ?? this.dividerColor,
        largeDividerColor: largeDividerColor ?? this.largeDividerColor,
      );

  /// Linearly interpolate between two themes.
  static PullDownMenuDividerTheme lerp(
    PullDownMenuDividerTheme? a,
    PullDownMenuDividerTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PullDownMenuDividerTheme(
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      largeDividerColor:
          Color.lerp(a?.largeDividerColor, b?.largeDividerColor, t),
    );
  }

  @override
  int get hashCode => Object.hash(dividerColor, largeDividerColor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownMenuDividerTheme &&
        other.dividerColor == dividerColor &&
        other.largeDividerColor == largeDividerColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('dividerColor', dividerColor, defaultValue: null),
      )
      ..add(
        ColorProperty(
          'largeDividerColor',
          largeDividerColor,
          defaultValue: null,
        ),
      );
  }
}

// Based on values from https://www.figma.com/community/file/1121065701252736567,
// https://www.figma.com/community/file/1172051389106515682 and direct
// color compare with native variant.
@immutable
class _PullDownMenuDividerDefaults extends PullDownMenuDividerTheme {
  const _PullDownMenuDividerDefaults(this.context);

  final BuildContext context;

  static const kDividerColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.25),
    darkColor: Color.fromRGBO(255, 255, 255, 0.3),
  );

  static const kLargeDividerColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(140, 140, 140, 0.18),
    darkColor: Color.fromRGBO(0, 0, 0, 0.15),
  );

  @override
  Color get dividerColor => kDividerColor.resolveFrom(context);

  @override
  Color get largeDividerColor => kLargeDividerColor.resolveFrom(context);
}
