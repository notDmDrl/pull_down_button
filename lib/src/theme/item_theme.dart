/// @docImport '/pull_down_button.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '_dynamic_color.dart';
import '_fonts.dart';

/// Defines the visual properties of the items in pull-down menus.
///
/// Is used by [PullDownMenuItem], [PullDownMenuItem.selectable] and
/// [PullDownMenuHeader].
///
/// Typically a [PullDownMenuItemTheme] is specified as part of the overall
/// [PullDownMenuItemTheme] with [PullDownButtonTheme.itemTheme].
///
/// All [PullDownMenuItemTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
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
  /// Default properties were taken from the Apple Design Resources Sketch and
  /// Figma libraries for iOS 18 and iPadOS 18.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  @internal
  const factory PullDownMenuItemTheme.defaults(BuildContext context) =
      _Defaults;

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

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuItemTheme copyWith({
    Color? destructiveColor,
    IconData? checkmark,
    TextStyle? textStyle,
    TextStyle? subtitleStyle,
    TextStyle? iconActionTextStyle,
    Color? onHoverBackgroundColor,
    Color? onPressedBackgroundColor,
    Color? onHoverTextColor,
  }) => PullDownMenuItemTheme(
    destructiveColor: destructiveColor ?? this.destructiveColor,
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
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuItemTheme(
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
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
    destructiveColor,
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
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuItemTheme &&
        other.destructiveColor == destructiveColor &&
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
        ColorProperty(
          'destructiveColor',
          destructiveColor,
          defaultValue: destructiveColor,
        ),
      )
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
class _Defaults extends PullDownMenuItemTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context)
    : super(
        checkmark: CupertinoIcons.checkmark,
      );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  @override
  Color get destructiveColor => CupertinoColors.systemRed.resolveFrom(context);

  Color get _labelColor => CupertinoColors.label.resolveFrom(context);

  /// The [PullDownMenuItemTheme.textStyle] before applying
  /// [CupertinoColors.label].
  static const kTextStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  @override
  TextStyle get textStyle => kTextStyle.copyWith(color: _labelColor);

  /// The [PullDownMenuItemTheme.subtitleStyle] before applying
  /// [CupertinoColors.label].
  static const kSubtitleStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
  );

  /// The light and dark colors of [PullDownMenuItem.subtitle].
  static const kSubtitleColor = SimpleDynamicColor(
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  @override
  TextStyle get subtitleStyle => kSubtitleStyle.copyWith(
    color: kSubtitleColor.resolveFrom(context),
  );

  /// The [PullDownMenuItemTheme.iconActionTextStyle] before applying
  /// [CupertinoColors.label].
  static const kIconActionTextStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: -0.43,
  );

  @override
  TextStyle get iconActionTextStyle =>
      kIconActionTextStyle.copyWith(color: _labelColor);

  /// The light and dark on pressed/on hover colors of [PullDownMenuItem].
  static const kOnPressedColor = SimpleDynamicColor(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    darkColor: Color.fromRGBO(255, 255, 255, 0.135),
  );

  @override
  Color get onPressedBackgroundColor => kOnPressedColor.resolveFrom(context);

  @override
  Color get onHoverBackgroundColor => kOnPressedColor.resolveFrom(context);

  @override
  Color get onHoverTextColor => _labelColor;
}
