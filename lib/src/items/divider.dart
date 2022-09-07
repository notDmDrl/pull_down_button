import 'package:flutter/material.dart';

import '../theme/default_theme.dart';
import '../theme/theme.dart';
import 'entry.dart';

const double _kMenuDividerHeight = 0;
const double _kMenuLargeDividerHeight = 8;

/// A horizontal divider for cupertino style pull-down menu.
///
/// This widget adapts the [Divider] for use in pull-down menus.
@immutable
class PullDownMenuDivider extends PullDownMenuEntry {
  /// Creates a horizontal divider for a pull-down menu.
  ///
  /// Divider has height and thickness of 0 logical pixels.
  const PullDownMenuDivider({super.key, this.dividerColor})
      : height = _kMenuDividerHeight,
        largeDividerColor = null;

  /// Creates a horizontal divider for a pull-down menu.
  ///
  /// Divider has height and thickness of 8 logical pixels.
  const PullDownMenuDivider.large({super.key, this.largeDividerColor})
      : height = _kMenuLargeDividerHeight,
        dividerColor = null;

  /// The color of divider.
  ///
  /// If this property is null then [PullDownButtonTheme.dividerColor] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.dividerColor] is used.
  final Color? dividerColor;

  /// The color of large divider.
  ///
  /// If this property is null then [PullDownButtonTheme.largeDividerColor]
  /// from [PullDownButtonTheme] theme extension is used. If that's null
  /// then [PullDownButtonThemeDefaults.largeDividerColor] is used.
  final Color? largeDividerColor;

  /// The height and thickness of the divider entry.
  ///
  /// Can be 0 pixels ([PullDownMenuDivider]) or 8 pixels
  /// ([PullDownMenuDivider.large]) depending on the constructor.
  @override
  final double height;

  @override
  bool get represents => false;

  @override
  bool get isDestructive => false;

  /// Helper method that simplifies separation of pull-down menu items.
  static List<PullDownMenuEntry> wrapWithDivider(
    List<PullDownMenuEntry> items,
  ) =>
      [
        for (final i in items.take(items.length - 1)) ...[
          i,
          const PullDownMenuDivider()
        ],
        items.last,
      ];

  @override
  Widget build(BuildContext context) {
    final Color color;

    if (height != 0) {
      color = PullDownButtonTheme.getProperty(
        widgetProperty: largeDividerColor,
        theme: PullDownButtonTheme.of(context),
        defaults: PullDownButtonThemeDefaults(context),
        getThemeProperty: (theme) => theme?.largeDividerColor,
      );
    } else {
      color = PullDownButtonTheme.getProperty(
        widgetProperty: dividerColor,
        theme: PullDownButtonTheme.of(context),
        defaults: PullDownButtonThemeDefaults(context),
        getThemeProperty: (theme) => theme?.dividerColor,
      );
    }

    return Divider(
      height: height,
      thickness: height,
      color: color,
    );
  }
}
