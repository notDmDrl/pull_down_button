/// @docImport '/pull_down_button.dart';
library;

import 'package:flutter/material.dart';

import '/src/items/item.dart';
import '/src/theme/theme.dart';
import 'content_size_category.dart';

enum _MenuConfigAspect {
  hasLeading,
  theme,
  contentSize,
}

/// An inherited widget used to provide menu configuration to all its descendant
/// widgets.
///
/// Is internally used by [PullDownButton], [showPullDownMenu], or
/// [PullDownMenu].
@immutable
class MenuConfig extends InheritedModel<_MenuConfigAspect> {
  /// Creates [MenuConfig].
  const MenuConfig({
    super.key,
    required super.child,
    required this.hasLeading,
    required this.ambientTheme,
    required this.contentSizeCategory,
  });

  /// Whether the pull-down menu has any menu items with leading widget such
  /// as chevron.
  final bool hasLeading;

  /// An ambient [PullDownButtonTheme] returned by
  /// [PullDownButtonTheme.ambientOf].
  final PullDownButtonTheme ambientTheme;

  /// Current text scale level.
  final ContentSizeCategory contentSizeCategory;

  static MenuConfig _of(BuildContext context, _MenuConfigAspect aspect) =>
      InheritedModel.inheritFrom<MenuConfig>(context, aspect: aspect)!;

  /// Returns a [bool] value indicating whether menu has any menu items with
  /// leading widget from the closest [MenuConfig] ancestor.
  static bool hasLeadingOf(BuildContext context) =>
      _of(context, _MenuConfigAspect.hasLeading).hasLeading;

  /// Returns a [PullDownButtonTheme] value from the closest [MenuConfig]
  /// ancestor.
  static PullDownButtonTheme ambientThemeOf(BuildContext context) =>
      _of(context, _MenuConfigAspect.theme).ambientTheme;

  /// Returns a [ContentSizeCategory] value from the closest [MenuConfig]
  /// ancestor.
  static ContentSizeCategory contentSizeCategoryOf(BuildContext context) =>
      _of(context, _MenuConfigAspect.contentSize).contentSizeCategory;

  /// Used to determine if the menu has any items with a leading widget.
  static bool menuHasLeading(List<Widget> items) =>
      items.whereType<PullDownMenuItem>().any(
        (element) => element.selected != null,
      );

  @override
  bool updateShouldNotify(MenuConfig oldWidget) =>
      hasLeading != oldWidget.hasLeading ||
      ambientTheme != oldWidget.ambientTheme ||
      contentSizeCategory != oldWidget.contentSizeCategory;

  @override
  bool updateShouldNotifyDependent(
    MenuConfig oldWidget,
    Set<Object> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (dependency is _MenuConfigAspect) {
        return switch (dependency) {
          _MenuConfigAspect.hasLeading => hasLeading != oldWidget.hasLeading,
          _MenuConfigAspect.theme => ambientTheme != oldWidget.ambientTheme,
          _MenuConfigAspect.contentSize =>
            contentSizeCategory != oldWidget.contentSizeCategory,
        };
      }
    }

    return false;
  }
}
