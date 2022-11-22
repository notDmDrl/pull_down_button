import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

const double _kMenuDividerHeight = 0;
const double _kMenuLargeDividerHeight = 8;

/// A horizontal divider for cupertino style pull-down menu.
///
/// This widget adapts the [Divider] for use in pull-down menus.
///
/// See also:
///
/// * [PullDownMenuItem], a pull-down menu entry for a simple action.
/// * [PullDownMenuItem.selectable], a pull-down menu entry for a selection
///   action.
/// * [PullDownMenuTitle], a pull-down menu entry for a menu title.
@immutable
class PullDownMenuDivider extends PullDownMenuEntry {
  /// Creates a horizontal divider for a pull-down menu.
  ///
  /// Divider has height and thickness of 0 logical pixels.
  const PullDownMenuDivider({
    super.key,
    this.color,
  }) : _isLarge = false;

  /// Creates a large horizontal divider for a pull-down menu.
  ///
  /// Divider has height and thickness of 8 logical pixels.
  const PullDownMenuDivider.large({
    super.key,
    this.color,
  }) : _isLarge = true;

  /// The color of divider.
  ///
  /// If this property is null then, depending on constructor,
  /// [PullDownMenuDividerTheme.dividerColor] or
  /// [PullDownMenuDividerTheme.largeDividerColor] from
  /// [PullDownButtonTheme.dividerTheme] is used.
  ///
  /// If that's null then defaults from [PullDownMenuDividerTheme] are used.
  final Color? color;

  /// Whether this [PullDownMenuDivider] is large or not.
  final bool _isLarge;

  /// The height and thickness of the divider entry.
  ///
  /// Can be 0 pixels ([PullDownMenuDivider]) or 8 pixels
  /// ([PullDownMenuDivider.large]) depending on the constructor.
  @override
  double get height =>
      _isLarge ? _kMenuLargeDividerHeight : _kMenuDividerHeight;

  @override
  bool get represents => false;

  @override
  bool get isDestructive => false;

  /// Helper method that simplifies separation of pull-down menu items.
  static List<PullDownMenuEntry> wrapWithDivider(
    List<PullDownMenuEntry> items,
  ) {
    if (items.isEmpty || items.length == 1) {
      return items;
    }

    return [
      for (final i in items.take(items.length - 1)) ...[
        i,
        const PullDownMenuDivider()
      ],
      items.last,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuDividerTheme.of(context);
    final defaults = PullDownMenuDividerTheme.defaults(context);

    final divider = color ??
        (_isLarge
            ? (theme ?? defaults).largeDividerColor
            : (theme ?? defaults).dividerColor)!;

    return Divider(
      height: height,
      thickness: height,
      color: divider,
    );
  }
}

/// A vertical divider for cupertino style side-by-side appearance row.
///
/// This widget adapts the [VerticalDivider] for use in pull-down side-by-side
/// appearance row.
///
/// This widget should not be used outside of [PullDownMenuActionsRow].
@immutable
@internal
class PullDownMenuVerticalDivider extends PullDownMenuEntry {
  /// Creates a vertical divider for a side-by-side appearance row.
  ///
  /// Divider has width and thickness of 0 logical pixels.
  const PullDownMenuVerticalDivider({
    super.key,
    this.color,
    required this.height,
  });

  /// The color of divider.
  ///
  /// If this property is null then [PullDownMenuDividerTheme.dividerColor] from
  /// [PullDownButtonTheme.dividerTheme] is used.
  ///
  /// If that's null then defaults from [PullDownMenuDividerTheme] are used.
  final Color? color;

  @override
  final double height;

  @override
  bool get represents => false;

  @override
  bool get isDestructive => false;

  /// Helper method that simplifies separation of side-by-side appearance row
  /// items.
  @internal
  static List<Widget> wrapWithDivider(
    List<PullDownMenuItem> items, {
    required double height,
    Color? color,
  }) {
    if (items.isEmpty) {
      return items;
    }

    if (items.length == 1) {
      return [Expanded(child: items.single)];
    }

    return [
      for (final i in items.take(items.length - 1)) ...[
        Expanded(child: i),
        PullDownMenuVerticalDivider(height: height, color: color),
      ],
      Expanded(child: items.last),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuDividerTheme.of(context);
    final defaults = PullDownMenuDividerTheme.defaults(context);

    final divider = color ?? theme?.dividerColor ?? defaults.dividerColor!;

    return SizedBox(
      height: height,
      child: VerticalDivider(
        thickness: 0,
        width: 0,
        color: divider,
      ),
    );
  }
}
