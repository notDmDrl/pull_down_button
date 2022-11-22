import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

/// Defines the visual properties of the dividers in pull-down menus.
///
/// Is used by [PullDownMenuDivider] and vertical dividers in
/// [PullDownMenuActionsRow].
///
/// All [PullDownMenuDividerTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [_PullDownMenuDividerDefaults].
@immutable
class PullDownMenuDividerTheme {
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
  ) =>
      PullDownMenuDividerTheme(
        dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
        largeDividerColor:
            Color.lerp(a?.largeDividerColor, b?.largeDividerColor, t),
      );

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
}

// Based on values from https://www.figma.com/community/file/1121065701252736567.
@immutable
class _PullDownMenuDividerDefaults extends PullDownMenuDividerTheme {
  const _PullDownMenuDividerDefaults(this.context);

  final BuildContext context;

  static const kDividerColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(60, 60, 67, 0.36),
    darkColor: Color.fromRGBO(84, 84, 88, 0.65),
  );

  static const kLargeDividerColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromARGB(190, 208, 208, 208),
    darkColor: Color.fromARGB(190, 4, 4, 4),
  );

  @override
  Color get dividerColor => kDividerColor.resolveFrom(context);

  @override
  Color get largeDividerColor => kLargeDividerColor.resolveFrom(context);
}
