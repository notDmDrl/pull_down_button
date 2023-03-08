import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

/// Defines the visual properties of the items in pull-down menus.
///
/// Is used by [PullDownMenuItem], [PullDownMenuItem.selectable].
///
/// All [PullDownMenuItemTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PullDownMenuItemTheme.defaults].
@immutable
class PullDownMenuItemTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuItemTheme].
  const PullDownMenuItemTheme({
    this.destructiveColor,
    this.iconSize,
    this.checkmark,
    this.checkmarkWeight,
    this.checkmarkSize,
    this.textStyle,
    this.iconActionTextStyle,
    this.onHoverColor,
    this.onHoverTextStyle,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuTitleTheme].
  @internal
  const factory PullDownMenuItemTheme.defaults(BuildContext context) =
      _PullDownMenuItemThemeDefaults;

  /// The destructive color of items in the pull-down menu.
  final Color? destructiveColor;

  /// The size of trailing icons of items in the pull-down menu.
  final double? iconSize;

  /// The selection icon for selected [PullDownMenuItem.selectable]s.
  ///
  /// These value is ignored for [PullDownMenuItem].
  final IconData? checkmark;

  /// The font weight of selection icon for selected
  /// [PullDownMenuItem.selectable]s.
  ///
  /// These value is ignored for [PullDownMenuItem].
  final FontWeight? checkmarkWeight;

  /// The size of chevron icons of items in the pull-down menu.
  ///
  /// These value is ignored for [PullDownMenuItem].
  final double? checkmarkSize;

  /// The text style of items in the pull-down menu.
  ///
  /// These value is ignored for [PullDownMenuItem]s inside
  /// [PullDownMenuActionsRow].
  final TextStyle? textStyle;

  /// The text style of [PullDownMenuItem] items inside
  /// [PullDownMenuActionsRow] in the pull-down menu.
  ///
  /// These value is ignored for any other [PullDownMenuItem] and
  /// [PullDownMenuItem.selectable].
  final TextStyle? iconActionTextStyle;

  /// The on hover color of [PullDownMenuItem].
  final Color? onHoverColor;

  /// The on hover text style of [PullDownMenuItem].
  final TextStyle? onHoverTextStyle;

  /// The [PullDownButtonTheme.itemTheme] property of the ambient
  /// [PullDownButtonTheme].
  static PullDownMenuItemTheme? of(BuildContext context) =>
      PullDownButtonTheme.of(context)?.itemTheme;

  /// The helper method to quickly resolve [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] or [PullDownMenuItemTheme.defaults]
  /// as well as from theme data from [PullDownMenuItem].
  @internal
  static PullDownMenuItemTheme resolve(
    BuildContext context, {
    required PullDownMenuItemTheme? itemTheme,
    required bool enabled,
    required bool isDestructive,
  }) {
    final theme = PullDownMenuItemTheme.of(context);
    final defaults = PullDownMenuItemTheme.defaults(context);

    var resolved = PullDownMenuItemTheme(
      destructiveColor: itemTheme?.destructiveColor ??
          theme?.destructiveColor ??
          defaults.destructiveColor!,
      iconSize: itemTheme?.iconSize ?? theme?.iconSize ?? defaults.iconSize!,
      checkmark:
          itemTheme?.checkmark ?? theme?.checkmark ?? defaults.checkmark!,
      checkmarkWeight: itemTheme?.checkmarkWeight ??
          theme?.checkmarkWeight ??
          defaults.checkmarkWeight!,
      checkmarkSize: itemTheme?.checkmarkSize ??
          theme?.checkmarkSize ??
          defaults.checkmarkSize!,
      textStyle: defaults.textStyle!
          .merge(theme?.textStyle)
          .merge(itemTheme?.textStyle),
      iconActionTextStyle: defaults.iconActionTextStyle!
          .merge(theme?.iconActionTextStyle)
          .merge(itemTheme?.iconActionTextStyle),
      onHoverColor: itemTheme?.onHoverColor ??
          theme?.onHoverColor ??
          defaults.onHoverColor!,
      onHoverTextStyle: defaults.onHoverTextStyle!
          .merge(theme?.onHoverTextStyle)
          .merge(itemTheme?.onHoverTextStyle),
    );

    if (isDestructive) {
      resolved = resolved.copyWith(
        textStyle: resolved.textStyle!.copyWith(
          color: resolved.destructiveColor,
        ),
        iconActionTextStyle: resolved.iconActionTextStyle!.copyWith(
          color: resolved.destructiveColor,
        ),
      );
    }

    if (!enabled) {
      resolved = resolved.copyWith(
        textStyle: resolved.textStyle!.copyWith(
          color: resolved.textStyle!.color!.withOpacity(
            _PullDownMenuItemThemeDefaults._disabledOpacity(context),
          ),
        ),
        iconActionTextStyle: resolved.iconActionTextStyle!.copyWith(
          color: resolved.iconActionTextStyle!.color!.withOpacity(
            _PullDownMenuItemThemeDefaults._disabledOpacity(context),
          ),
        ),
      );
    }

    return resolved;
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuItemTheme copyWith({
    Color? destructiveColor,
    double? iconSize,
    IconData? checkmark,
    FontWeight? checkmarkWeight,
    double? checkmarkSize,
    TextStyle? textStyle,
    TextStyle? iconActionTextStyle,
    Color? onHoverColor,
    TextStyle? onHoverTextStyle,
  }) =>
      PullDownMenuItemTheme(
        destructiveColor: destructiveColor ?? this.destructiveColor,
        iconSize: iconSize ?? this.iconSize,
        checkmark: checkmark ?? this.checkmark,
        checkmarkWeight: checkmarkWeight ?? this.checkmarkWeight,
        checkmarkSize: checkmarkSize ?? this.checkmarkSize,
        textStyle: textStyle ?? this.textStyle,
        iconActionTextStyle: iconActionTextStyle ?? this.iconActionTextStyle,
        onHoverColor: onHoverColor ?? this.onHoverColor,
        onHoverTextStyle: onHoverTextStyle ?? this.onHoverTextStyle,
      );

  /// Linearly interpolate between two themes.
  static PullDownMenuItemTheme lerp(
    PullDownMenuItemTheme? a,
    PullDownMenuItemTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PullDownMenuItemTheme(
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
      iconSize: ui.lerpDouble(a?.iconSize, b?.iconSize, t),
      checkmark: _lerpIconData(a?.checkmark, b?.checkmark, t),
      checkmarkWeight:
          FontWeight.lerp(a?.checkmarkWeight, b?.checkmarkWeight, t),
      checkmarkSize: ui.lerpDouble(a?.checkmarkSize, b?.checkmarkSize, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      iconActionTextStyle:
          TextStyle.lerp(a?.iconActionTextStyle, b?.iconActionTextStyle, t),
      onHoverColor: Color.lerp(a?.onHoverColor, b?.onHoverColor, t),
      onHoverTextStyle:
          TextStyle.lerp(a?.onHoverTextStyle, b?.onHoverTextStyle, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        destructiveColor,
        iconSize,
        checkmark,
        checkmarkWeight,
        checkmarkSize,
        textStyle,
        iconActionTextStyle,
        onHoverColor,
        onHoverTextStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownMenuItemTheme &&
        other.destructiveColor == destructiveColor &&
        other.iconSize == iconSize &&
        other.checkmark == checkmark &&
        other.checkmarkWeight == checkmarkWeight &&
        other.checkmarkSize == checkmarkSize &&
        other.textStyle == textStyle &&
        other.iconActionTextStyle == iconActionTextStyle &&
        other.onHoverColor == onHoverColor &&
        other.onHoverTextStyle == onHoverTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('destructiveColor', destructiveColor, defaultValue: null),
      )
      ..add(
        DoubleProperty('iconSize', iconSize, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('checkmark', checkmark, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'checkmarkWeight',
          checkmarkWeight,
          defaultValue: null,
        ),
      )
      ..add(
        DoubleProperty('checkmarkSize', checkmarkSize, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('textStyle', textStyle, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'iconActionTextStyle',
          iconActionTextStyle,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty('onHoverColor', onHoverColor, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'onHoverTextStyle',
          onHoverTextStyle,
          defaultValue: null,
        ),
      );
  }
}

IconData? _lerpIconData(IconData? a, IconData? b, double t) => t < 0.5 ? a : b;

// Based on values from https://www.figma.com/community/file/1121065701252736567.
@immutable
class _PullDownMenuItemThemeDefaults extends PullDownMenuItemTheme {
  const _PullDownMenuItemThemeDefaults(this.context)
      : super(
          iconSize: 20,
          checkmark: CupertinoIcons.checkmark,
          checkmarkWeight: FontWeight.bold,
          checkmarkSize: 16,
        );

  final BuildContext context;

  // Taken from https://developer.apple.com/design/human-interface-guidelines/inputs/pointing-devices#pointer-shape-and-content-effects.
  static const kOnHoverColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(225, 226, 229, 1),
    darkColor: Color.fromRGBO(46, 45, 46, 1),
  );

  // Opacity values were based on direct pixel to pixel comparison with
  // native variant.
  static double _disabledOpacity(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    switch (brightness) {
      case Brightness.dark:
        return 0.55;
      case Brightness.light:
        return 0.45;
    }
  }

  @override
  Color get destructiveColor => CupertinoColors.systemRed.resolveFrom(context);

  @override
  TextStyle get textStyle => TextStyle(
        inherit: false,
        fontFamily: '.SF UI Text',
        fontSize: 16.8,
        height: 22 / 16.8,
        fontWeight: FontWeight.w400,
        color: CupertinoColors.label.resolveFrom(context),
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: -0.3,
      );

  @override
  TextStyle get iconActionTextStyle => TextStyle(
        inherit: false,
        fontFamily: '.SF UI Text',
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: CupertinoColors.label.resolveFrom(context),
        textBaseline: TextBaseline.alphabetic,
        letterSpacing: -0.41,
      );

  @override
  Color get onHoverColor => kOnHoverColor.resolveFrom(context);

  @override
  TextStyle get onHoverTextStyle => textStyle;
}
