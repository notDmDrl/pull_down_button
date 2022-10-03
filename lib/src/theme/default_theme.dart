import 'package:flutter/cupertino.dart';

import 'theme.dart';

const _kDividerColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(60, 60, 67, 0.36),
  darkColor: Color.fromRGBO(84, 84, 88, 0.65),
);

const _kLargeDividerColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromARGB(190, 208, 208, 208),
  darkColor: Color.fromARGB(190, 4, 4, 4),
);

const _kBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(237, 237, 237, 0.8),
  darkColor: Color.fromRGBO(37, 37, 37, 0.5),
);

const _kTitleColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(60, 60, 60, 0.6),
  darkColor: Color.fromRGBO(235, 235, 245, 0.6),
);

/// Taken from https://developer.apple.com/design/human-interface-guidelines/inputs/pointing-devices#pointer-shape-and-content-effects
const _kOnHoverColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(225, 226, 229, 1),
  darkColor: Color.fromRGBO(46, 45, 46, 1),
);

/// Based on values from https://www.figma.com/community/file/984106517828363349
@immutable
class PullDownButtonThemeDefaults extends PullDownButtonTheme {
  /// Creates default pull-down menu theme.
  const PullDownButtonThemeDefaults(this.context);

  /// Build context required for color resolving.
  final BuildContext context;

  @override
  Color get backgroundColor =>
      CupertinoDynamicColor.resolve(_kBackgroundColor, context);

  @override
  Color get dividerColor =>
      CupertinoDynamicColor.resolve(_kDividerColor, context);

  @override
  Color get largeDividerColor =>
      CupertinoDynamicColor.resolve(_kLargeDividerColor, context);

  @override
  Color get destructiveColor =>
      CupertinoDynamicColor.resolve(CupertinoColors.destructiveRed, context);

  @override
  double get iconSize => 20;

  @override
  IconData get checkmark => CupertinoIcons.checkmark;

  @override
  FontWeight get checkmarkWeight => FontWeight.w600;

  @override
  double get checkmarkSize => 15;

  @override
  TextStyle get textStyle => TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
        height: 1.3,
        letterSpacing: -0.41,
        textBaseline: TextBaseline.alphabetic,
      );

  @override
  TextStyle get iconActionTextStyle => TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
        height: 1.3,
        letterSpacing: -0.41,
        textBaseline: TextBaseline.alphabetic,
      );

  @override
  TextStyle get titleStyle => TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(_kTitleColor, context),
        height: 1.3,
        textBaseline: TextBaseline.alphabetic,
      );

  @override
  PullDownMenuWidthConfiguration get widthConfiguration =>
      const PullDownMenuWidthConfiguration(250);

  @override
  bool get applyOpacity => true;

  @override
  Color? get onHoverColor =>
      CupertinoDynamicColor.resolve(_kOnHoverColor, context);

  @override
  TextStyle? get onHoverTextStyle => textStyle;
}
