import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import '_fonts.dart';

/// Defines the visual properties of the items in pull-down menus.
///
/// Is used by [PullDownMenuItem], [PullDownMenuItem.selectable] and
/// [PullDownMenuHeader].
///
/// All [PullDownMenuItemTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PullDownMenuItemTheme.defaults].
@immutable
class PullDownMenuItemTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuItemTheme].
  const PullDownMenuItemTheme({
    this.destructiveColor,
    this.checkmark,
    this.textStyle,
    this.subtitleStyle,
    this.iconActionTextStyle,
    this.onHoverBackgroundColor,
    this.onPressedBackgroundColor,
    this.onHoverTextColor,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuTitleTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch file.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch file:
  ///   https://developer.apple.com/design/resources/
  @internal
  const factory PullDownMenuItemTheme.defaults(BuildContext context) =
      _PullDownMenuItemThemeDefaults;

  /// The destructive color of items in the pull-down menu.
  ///
  /// [destructiveColor] will be applied to [textStyle] and
  /// [iconActionTextStyle].
  final Color? destructiveColor;

  /// The selection icon for selected [PullDownMenuItem.selectable].
  ///
  /// These value is ignored for [PullDownMenuItem].
  final IconData? checkmark;

  /// The text style of item's titles in the pull-down menu.
  ///
  /// These value is ignored for [PullDownMenuItem]s inside
  /// [PullDownMenuActionsRow].
  final TextStyle? textStyle;

  /// The text style of item's subtitles in the pull-down menu.
  ///
  /// These value is ignored for [PullDownMenuItem]s inside
  /// [PullDownMenuActionsRow].
  final TextStyle? subtitleStyle;

  /// The text style of [PullDownMenuItem] items inside
  /// [PullDownMenuActionsRow] in the pull-down menu.
  ///
  /// These value is ignored for any other [PullDownMenuItem] and
  /// [PullDownMenuItem.selectable].
  final TextStyle? iconActionTextStyle;

  /// The background color of [PullDownMenuItem] during hover interaction.
  final Color? onHoverBackgroundColor;

  /// The background color of [PullDownMenuItem] during press interaction.
  final Color? onPressedBackgroundColor;

  /// The text color of [PullDownMenuItem] during hover interaction.
  ///
  /// [onHoverTextColor] will be applied to [textStyle] and
  /// [iconActionTextStyle].
  final Color? onHoverTextColor;

  /// The [PullDownButtonTheme.itemTheme] property of the ambient
  /// [PullDownButtonTheme].
  static PullDownMenuItemTheme? maybeOf(BuildContext context) =>
      PullDownButtonTheme.maybeOf(context)?.itemTheme;

  /// Returns an opacity level for disabled state for specific [Brightness].
  ///
  /// Opacity values were based on a direct pixel-to-pixel comparison with the
  /// native variant.
  @internal
  static double disabledOpacity(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return switch (brightness) {
      Brightness.dark => 0.55,
      Brightness.light => 0.45
    };
  }

  /// The helper method to quickly resolve [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] or [PullDownMenuItemTheme.defaults]
  /// as well as from theme data from [PullDownMenuItem].
  @internal
  static PullDownMenuItemTheme resolve(
    BuildContext context, {
    required PullDownMenuItemTheme? itemTheme,
  }) {
    final theme = PullDownMenuItemTheme.maybeOf(context);
    final defaults = PullDownMenuItemTheme.defaults(context);

    return PullDownMenuItemTheme(
      destructiveColor: itemTheme?.destructiveColor ??
          theme?.destructiveColor ??
          defaults.destructiveColor!,
      checkmark:
          itemTheme?.checkmark ?? theme?.checkmark ?? defaults.checkmark!,
      textStyle: defaults.textStyle!
          .merge(theme?.textStyle)
          .merge(itemTheme?.textStyle),
      subtitleStyle: defaults.subtitleStyle!
          .merge(theme?.subtitleStyle)
          .merge(itemTheme?.subtitleStyle),
      iconActionTextStyle: defaults.iconActionTextStyle!
          .merge(theme?.iconActionTextStyle)
          .merge(itemTheme?.iconActionTextStyle),
      onHoverBackgroundColor: itemTheme?.onHoverBackgroundColor ??
          theme?.onHoverBackgroundColor ??
          defaults.onHoverBackgroundColor!,
      onPressedBackgroundColor: itemTheme?.onPressedBackgroundColor ??
          theme?.onPressedBackgroundColor ??
          defaults.onPressedBackgroundColor!,
      onHoverTextColor: itemTheme?.onHoverTextColor ??
          theme?.onHoverTextColor ??
          defaults.onHoverTextColor,
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuItemTheme copyWith({
    IconData? checkmark,
    TextStyle? textStyle,
    TextStyle? subtitleStyle,
    TextStyle? iconActionTextStyle,
    Color? onHoverBackgroundColor,
    Color? onPressedBackgroundColor,
    Color? onHoverTextColor,
  }) =>
      PullDownMenuItemTheme(
        checkmark: checkmark ?? this.checkmark,
        textStyle: textStyle ?? this.textStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        iconActionTextStyle: iconActionTextStyle ?? this.iconActionTextStyle,
        onHoverBackgroundColor:
            onHoverBackgroundColor ?? this.onHoverBackgroundColor,
        onPressedBackgroundColor:
            onPressedBackgroundColor ?? this.onPressedBackgroundColor,
        onHoverTextColor: onHoverTextColor ?? this.onHoverTextColor,
      );

  /// Linearly interpolate between two themes.
  static PullDownMenuItemTheme lerp(
    PullDownMenuItemTheme? a,
    PullDownMenuItemTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PullDownMenuItemTheme(
      checkmark: _lerpIconData(a?.checkmark, b?.checkmark, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      subtitleStyle: TextStyle.lerp(a?.subtitleStyle, b?.subtitleStyle, t),
      iconActionTextStyle: TextStyle.lerp(
        a?.iconActionTextStyle,
        b?.iconActionTextStyle,
        t,
      ),
      onHoverBackgroundColor: Color.lerp(
        a?.onHoverBackgroundColor,
        b?.onHoverBackgroundColor,
        t,
      ),
      onPressedBackgroundColor: Color.lerp(
        a?.onPressedBackgroundColor,
        b?.onPressedBackgroundColor,
        t,
      ),
      onHoverTextColor: Color.lerp(a?.onHoverTextColor, b?.onHoverTextColor, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        checkmark,
        textStyle,
        subtitleStyle,
        iconActionTextStyle,
        onHoverBackgroundColor,
        onPressedBackgroundColor,
        onHoverTextColor,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownMenuItemTheme &&
        other.checkmark == checkmark &&
        other.textStyle == textStyle &&
        other.subtitleStyle == subtitleStyle &&
        other.iconActionTextStyle == iconActionTextStyle &&
        other.onHoverBackgroundColor == onHoverBackgroundColor &&
        other.onPressedBackgroundColor == onPressedBackgroundColor &&
        other.onHoverTextColor == onHoverTextColor;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty('checkmark', checkmark, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('textStyle', textStyle, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('subtitleStyle', subtitleStyle, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty(
          'iconActionTextStyle',
          iconActionTextStyle,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty(
          'onHoverBackgroundColor',
          onHoverBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty(
          'onPressedBackgroundColor',
          onPressedBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty('onHoverTextColor', onHoverTextColor, defaultValue: null),
      );
  }
}

IconData? _lerpIconData(IconData? a, IconData? b, double t) => t < 0.5 ? a : b;

/// A set of default values for [PullDownMenuItemTheme].
@immutable
class _PullDownMenuItemThemeDefaults extends PullDownMenuItemTheme {
  /// Creates [_PullDownMenuItemThemeDefaults].
  const _PullDownMenuItemThemeDefaults(this.context)
      : super(
          checkmark: CupertinoIcons.checkmark,
        );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  @override
  Color get destructiveColor => CupertinoColors.systemRed.resolveFrom(context);

  /// The [PullDownMenuItemTheme.textStyle] as a constant.
  ///
  /// [textStyle] will resolve [kTextStyle] with [CupertinoColors.label]
  /// applied.
  static const kTextStyle = TextStyle(
    inherit: false,
    fontFamily: kFontFamily,
    fontFamilyFallback: kFontFallbacks,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.41,
  );

  @override
  TextStyle get textStyle => kTextStyle.copyWith(
        color: CupertinoColors.label.resolveFrom(context),
      );

  /// The [PullDownMenuItemTheme.subtitleStyle] as a constant.
  ///
  /// [subtitleStyle] will resolve [kSubtitleStyle] with [kSubtitleColor]
  /// applied.
  static const kSubtitleStyle = TextStyle(
    inherit: false,
    fontFamily: kFontFamily,
    fontFamilyFallback: kFontFallbacks,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.41,
  );

  /// The light and dark colors of [PullDownMenuItem.subtitle].
  static const kSubtitleColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  @override
  TextStyle get subtitleStyle => kSubtitleStyle.copyWith(
        color: kSubtitleColor.resolveFrom(context),
      );

  /// The [PullDownMenuItemTheme.iconActionTextStyle] as a constant.
  ///
  /// [iconActionTextStyle] will resolve [kIconActionTextStyle] with
  /// [CupertinoColors.label] applied.
  static const kIconActionTextStyle = TextStyle(
    inherit: false,
    fontFamily: kFontFamily,
    fontFamilyFallback: kFontFallbacks,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.41,
  );

  @override
  TextStyle get iconActionTextStyle => kIconActionTextStyle.copyWith(
        color: CupertinoColors.label.resolveFrom(context),
      );

  /// The light and dark on pressed/on hover colors of [PullDownMenuItem].
  static const kOnPressedColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    darkColor: Color.fromRGBO(255, 255, 255, 0.135),
  );

  @override
  Color get onPressedBackgroundColor => kOnPressedColor.resolveFrom(context);

  @override
  Color get onHoverBackgroundColor => kOnPressedColor.resolveFrom(context);

  @override
  Color get onHoverTextColor => CupertinoColors.label.resolveFrom(context);
}
