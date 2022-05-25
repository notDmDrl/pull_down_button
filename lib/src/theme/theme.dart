import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../items/divider.dart';
import '../items/entry.dart';
import '../items/item.dart';
import 'default_theme.dart';

/// Defines the visual properties of the routes used to display pull-down menus
/// as well as any widgets that extend [PullDownMenuEntry].
///
/// Widgets that extend [PullDownMenuEntry] obtain current
/// [PullDownButtonTheme] object using
/// `PullDownButtonTheme.of(context)`.
///
/// [PullDownButtonTheme] should be specified in [ThemeData.extensions].
///
/// All [PullDownButtonTheme] properties are `null` by default.
/// If any of these properties are null, the pull-down menu will use iOS 15
/// defaults specified in [PullDownButtonThemeDefaults].
@immutable
class PullDownButtonTheme extends ThemeExtension<PullDownButtonTheme>
    with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownButtonTheme].
  const PullDownButtonTheme({
    this.backgroundColor,
    this.dividerColor,
    this.largeDividerColor,
    this.destructiveColor,
    this.iconSize,
    this.checkmark,
    this.checkmarkWeight,
    this.checkmarkSize,
    this.textStyle,
    this.titleStyle,
  });

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The divider color of the pull-down menu divider [PullDownMenuDivider].
  final Color? dividerColor;

  /// The large divider color of the pull-down menu
  /// divider [PullDownMenuDivider.large].
  final Color? largeDividerColor;

  /// The destructive color of items in the pull-down menu.
  final Color? destructiveColor;

  /// The size of trailing icons of items in the pull-down menu.
  final double? iconSize;

  /// The selection icon for selected [SelectablePullDownMenuItem]s.
  final IconData? checkmark;

  /// The font weight of selection icon for selected
  /// [SelectablePullDownMenuItem]s.
  final FontWeight? checkmarkWeight;

  /// The size of chevron icons of items in the pull-down menu.
  final double? checkmarkSize;

  /// The text style of items in the pull-down menu.
  final TextStyle? textStyle;

  /// The text style of title in the pull-down menu.
  final TextStyle? titleStyle;

  /// Get [PullDownButtonTheme] from [ThemeData.extensions] property of the
  /// ambient [Theme].
  // ignore: prefer_expression_function_bodies
  static PullDownButtonTheme? of(BuildContext context) {
    // return Theme.of(context).extension<PullDownButtonTheme>();

    // todo: use this workaround since `extension<PullDownButtonTheme>()` is
    // not null safe yet
    // see https://github.com/flutter/flutter/pull/103343 for fix (not yet available in stable)

    return Theme.of(context).extensions[PullDownButtonTheme]
        as PullDownButtonTheme?;
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  @override
  PullDownButtonTheme copyWith({
    Color? backgroundColor,
    Color? dividerColor,
    Color? largeDividerColor,
    Color? destructiveColor,
    double? iconSize,
    IconData? checkmark,
    FontWeight? checkmarkWeight,
    double? checkmarkSize,
    TextStyle? textStyle,
    TextStyle? titleStyle,
  }) =>
      PullDownButtonTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        dividerColor: dividerColor ?? this.dividerColor,
        largeDividerColor: largeDividerColor ?? this.largeDividerColor,
        destructiveColor: destructiveColor ?? this.destructiveColor,
        iconSize: iconSize ?? this.iconSize,
        checkmark: checkmark ?? this.checkmark,
        checkmarkWeight: checkmarkWeight ?? this.checkmarkWeight,
        checkmarkSize: checkmarkSize ?? this.checkmarkSize,
        textStyle: textStyle ?? this.textStyle,
        titleStyle: titleStyle ?? this.titleStyle,
      );

  /// Linearly interpolate between two pull-down menu themes.
  @override
  PullDownButtonTheme lerp(
    ThemeExtension<PullDownButtonTheme>? other,
    double t,
  ) {
    if (other is! PullDownButtonTheme) {
      return this;
    }

    return PullDownButtonTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      largeDividerColor: Color.lerp(
        largeDividerColor,
        other.largeDividerColor,
        t,
      ),
      destructiveColor: Color.lerp(destructiveColor, other.destructiveColor, t),
      iconSize: ui.lerpDouble(iconSize, other.iconSize, t),
      checkmark: other.checkmark,
      checkmarkWeight: FontWeight.lerp(
        checkmarkWeight,
        other.checkmarkWeight,
        t,
      ),
      checkmarkSize: ui.lerpDouble(checkmarkSize, other.checkmarkSize, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        dividerColor,
        largeDividerColor,
        destructiveColor,
        iconSize,
        checkmark,
        checkmarkWeight,
        checkmarkSize,
        textStyle,
        titleStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownButtonTheme &&
        other.backgroundColor == backgroundColor &&
        other.dividerColor == dividerColor &&
        other.largeDividerColor == largeDividerColor &&
        other.destructiveColor == destructiveColor &&
        other.iconSize == iconSize &&
        other.checkmark == checkmark &&
        other.checkmarkWeight == checkmarkWeight &&
        other.checkmarkSize == checkmarkSize &&
        other.titleStyle == titleStyle &&
        other.textStyle == textStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        ColorProperty('dividerColor', dividerColor, defaultValue: null),
      )
      ..add(
        ColorProperty(
          'largeDividerColor',
          largeDividerColor,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty('destructiveColor', destructiveColor, defaultValue: null),
      )
      ..add(DoubleProperty('iconSize', iconSize, defaultValue: null))
      ..add(
        DiagnosticsProperty<IconData>(
          'checkmark',
          checkmark,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<FontWeight>(
          'checkmarkWeight',
          checkmarkWeight,
          defaultValue: null,
        ),
      )
      ..add(DoubleProperty('checkmarkSize', checkmarkSize, defaultValue: null))
      ..add(
        DiagnosticsProperty<TextStyle>(
          'textStyle',
          textStyle,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle>(
          'titleStyle',
          titleStyle,
          defaultValue: null,
        ),
      );
  }
}
