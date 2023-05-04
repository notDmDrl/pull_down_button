import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// The default font family of pull-down menu items.
///
/// The font name was retrieved using one of the constants in
/// [CupertinoTextThemeData] file. This means that for iOS menus will use an
/// already existing font. For any other platform, this means going through
/// [kFontFallbacks] for any possible different naming of SF Pro font family or
/// defaulting to the platform's default font family if no fallback family name
/// matches.
///
/// See also:
///
/// * [CupertinoTextThemeData] for origins of this font family name.
@internal
const String kFontFamily = '.SF Pro Text';

/// List of different font family name variations of Apple San Francisco.
///
/// Font name variations starting with `.` are the ones already defined in other
/// cupertino widgets.
///
/// If you want to use SF Pro in the menu items but your app might be launched
/// from a different platform other than iOS, add the downloaded SF Pro `.ttf`
/// to your pubspec.yaml and name it with one of the names defined in
/// [kFontFallbacks].
///
/// See also:
///
/// * [TextStyle.fontFamilyFallback].
/// * [Typography.blackCupertino] and [Typography.whiteCupertino] for origins
/// of "UI" "dotted" name variations.
@internal
const List<String> kFontFallbacks = [
  '.SF Pro Display',
  '.SF UI Text',
  '.SF UI Display',
  'SF Pro',
  'SF Pro Text',
  'SF Pro Regular',
  'SF Pro Text Regular',
];
