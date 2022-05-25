import 'package:flutter/cupertino.dart';

import 'theme.dart';

const _kDividerColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(60, 60, 67, 0.36),
  darkColor: Color.fromRGBO(84, 84, 88, 0.65),
);

const _kLargeDividerColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(20, 20, 20, 0.15),
  darkColor: Color.fromRGBO(0, 0, 0, 0.7),
);

const _kBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(237, 237, 237, 0.8),
  darkColor: Color.fromRGBO(30, 30, 30, 0.75),
);

const _kTitleColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(60, 60, 60, 0.6),
  darkColor: Color.fromRGBO(235, 235, 245, 0.6),
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
  TextStyle get titleStyle => TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(_kTitleColor, context),
        height: 1.3,
        textBaseline: TextBaseline.alphabetic,
      );
}
