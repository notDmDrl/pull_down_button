/// @docImport '/src/theme/divider_theme.dart';
/// @docImport 'actions_row.dart';
library;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '/src/internals/menu_config.dart';

// The values were taken from the Apple Design Resources iOS 18 Figma file.
const _kSeparatorHeight = 0.5;
const double _kDividerHeight = 8;

/// A horizontal divider for a cupertino style pull-down menu.
///
/// Divider is always 8px in height.
@immutable
class PullDownMenuDivider extends StatelessWidget {
  /// Creates a large horizontal divider for a pull-down menu.
  const PullDownMenuDivider({
    super.key,
    this.color,
  });

  /// The color of the divider.
  ///
  /// If this property is null, then the value from the ambient
  /// [PullDownMenuDividerTheme] is used.
  final Color? color;

  @override
  Widget build(BuildContext context) => Divider(
    height: _kDividerHeight,
    thickness: _kDividerHeight,
    color:
        color ??
        MenuConfig.ambientThemeOf(context).dividerTheme.largeDividerColor!,
  );
}

/// A small divider for a cupertino style pull-down menu.
///
/// Divider is always 0.5px in height.
@immutable
@internal
class PullDownMenuSeparator extends StatelessWidget {
  /// Creates a small divider for a pull-down menu.
  const PullDownMenuSeparator._({
    required this.axis,
  });

  /// The direction along which the divider is rendered.
  final Axis axis;

  /// Helper method that simplifies separation of pull-down menu items.
  static List<Widget> wrapVerticalList(
    List<Widget> items,
  ) {
    if (items.isEmpty || items.length == 1) {
      return items;
    }

    const divider = PullDownMenuSeparator._(axis: Axis.horizontal);

    final list = <Widget>[];

    for (var i = 0; i < items.length - 1; i++) {
      final Widget item = items[i];

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
  /// items for [PullDownMenuActionsRow].
  static List<Widget> wrapSideBySide(
    List<Widget> items,
  ) {
    if (items.isEmpty) {
      return items;
    } else if (items.length == 1) {
      return [Expanded(child: items.single)];
    }

    const divider = PullDownMenuSeparator._(axis: Axis.vertical);

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
    final Color color =
        MenuConfig.ambientThemeOf(context).dividerTheme.dividerColor!;

    return switch (axis) {
      Axis.horizontal => Divider(
        height: _kSeparatorHeight,
        thickness: _kSeparatorHeight,
        color: color,
      ),
      Axis.vertical => VerticalDivider(
        width: _kSeparatorHeight,
        thickness: _kSeparatorHeight,
        color: color,
      ),
    };
  }
}
