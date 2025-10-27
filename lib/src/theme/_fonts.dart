/// @docImport 'package:flutter/cupertino.dart';
library;

/// The default font family of pull-down menu items.
///
/// The font name was retrieved using one of the constants in
/// [CupertinoTextThemeData] file. This means that for iOS menus will use an
/// already existing font. For any other platform, this means going through
/// [kPullDownMenuEntryFontFallbacks] for any possible different naming of
/// SF Pro font family or defaulting to the platform's default font family,
/// if no fallback family name matches.
///
/// See also:
///
/// * [CupertinoTextThemeData] for origins of this font family name.
const kPullDownMenuEntryFontFamily = 'CupertinoSystemText';

/// List of different font family name variations of Apple San Francisco.
///
/// If you want to use SF Pro in the menu items but your app might be launched
/// from a different platform other than iOS, add the downloaded SF Pro font
/// file to your pubspec.yaml and name it with one of the names defined in
/// [kPullDownMenuEntryFontFallbacks].
///
/// See also:
///
/// * [TextStyle.fontFamilyFallback].
const kPullDownMenuEntryFontFallbacks = <String>[
  '.SF Pro Text',
  '.SF Pro Display',
  '.SF UI Text',
  '.SF UI Display',
  'SF Pro',
  'SF Pro Text',
  'SF Pro Regular',
  'SF Pro Text Regular',
];
