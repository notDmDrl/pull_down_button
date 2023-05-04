import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

const double _kMenuDividerHeight = 0;
const double _kMenuLargeDividerHeight = 8;

/// A horizontal divider for a cupertino style pull-down menu.
///
/// This widget adapts the [Divider] for use in pull-down menus.
@immutable
class PullDownMenuDivider extends StatelessWidget implements PullDownMenuEntry {
  /// Creates a horizontal divider for a pull-down menu.
  @Deprecated(
    'Can be safely removed as the pull-down menu now automatically '
    'inserts dividers when needed. '
    'This feature was deprecated after v0.9.0.',
  )
  const PullDownMenuDivider({
    super.key,
    this.color,
  }) : _isLarge = false;

  /// Creates a large horizontal divider for a pull-down menu.
  const PullDownMenuDivider.large({
    super.key,
    this.color,
  }) : _isLarge = true;

  /// The color of the divider.
  ///
  /// If this property is null, then, depending on the constructor,
  /// [PullDownMenuDividerTheme.dividerColor] or
  /// [PullDownMenuDividerTheme.largeDividerColor] from
  /// [PullDownButtonTheme.dividerTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuDividerTheme.defaults] are
  /// used.
  final Color? color;

  /// Whether this [PullDownMenuDivider] is large or not.
  final bool _isLarge;

  /// The height and thickness of the divider entry.
  ///
  /// Can be 0 pixels ([PullDownMenuDivider]) or 8 pixels
  /// ([PullDownMenuDivider.large]) depending on the constructor.
  double get height =>
      _isLarge ? _kMenuLargeDividerHeight : _kMenuDividerHeight;

  /// Helper method that simplifies separation of pull-down menu items.
  @Deprecated(
    'Can be safely removed as the pull-down menu now automatically '
    'inserts dividers when needed. '
    'This feature was deprecated after v0.9.0.',
  )
  static List<PullDownMenuEntry> wrapWithDivider(
    List<PullDownMenuEntry> items,
  ) =>
      items;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuDividerTheme.resolve(context);

    final divider =
        color ?? (_isLarge ? theme.largeDividerColor : theme.dividerColor)!;

    return Divider(
      height: height,
      thickness: height,
      color: divider,
    );
  }
}

/// A small divider for a cupertino style pull-down menu.
///
/// This widget adapts the [Divider] and [VerticalDivider] for use in pull-down
/// menus.
@immutable
@internal
class MenuSeparator extends StatelessWidget implements PullDownMenuEntry {
  /// Creates a small divider for a pull-down menu.
  ///
  /// Divider has a height/width and thickness of 0 logical pixels.
  const MenuSeparator._({
    required this.axis,
  });

  /// The direction along which the divider is rendered.
  final Axis axis;

  /// Helper method that simplifies separation of pull-down menu items.
  static List<PullDownMenuEntry> wrapVerticalList(
    List<PullDownMenuEntry> items,
  ) {
    if (items.isEmpty || items.length == 1) {
      return items;
    }

    const divider = MenuSeparator._(axis: Axis.horizontal);

    final list = <PullDownMenuEntry>[];

    for (var i = 0; i < items.length - 1; i++) {
      final item = items[i];

      if (item is PullDownMenuDivider || items[i + 1] is PullDownMenuDivider) {
        list.add(item);
      } else {
        list.addAll([item, divider]);
      }
    }

    list.add(items.last);

    return list;
  }

  /// Helper method that simplifies separation of side-by-side appearance row
  /// items.
  static List<Widget> wrapSideBySide(
    List<PullDownMenuItem> items,
  ) {
    if (items.isEmpty) {
      return items;
    } else if (items.length == 1) {
      return [Expanded(child: items.single)];
    }

    const divider = MenuSeparator._(axis: Axis.vertical);

    return [
      for (final i in items.take(items.length - 1)) ...[
        Expanded(child: i),
        divider,
      ],
      Expanded(child: items.last),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuDividerTheme.resolve(context);

    switch (axis) {
      case Axis.horizontal:
        return Divider(
          height: _kMenuDividerHeight,
          thickness: _kMenuDividerHeight,
          color: theme.dividerColor,
        );
      case Axis.vertical:
        return VerticalDivider(
          width: _kMenuDividerHeight,
          thickness: _kMenuDividerHeight,
          color: theme.dividerColor,
        );
    }
  }
}
