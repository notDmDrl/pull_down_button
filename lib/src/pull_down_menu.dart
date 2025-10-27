import 'package:flutter/material.dart';

import '../pull_down_button.dart';
import 'internals/content_size_category.dart';
import 'internals/continuous_swipe.dart';
import 'internals/item_layout.dart';
import 'internals/menu.dart';
import 'internals/menu_config.dart';

/// Displays a pull-down menu as a simple widget without animations or adding
/// routes to the navigation stack.
///
/// This is an alternative way of displaying a pull-down menu, [PullDownButton]
/// should be enough for most cases.
///
/// See also:
///
/// * [PullDownMenuItem], a pull-down menu entry for a simple action.
/// * [PullDownMenuItem.selectable], a pull-down menu entry for a selection
///   action.
/// * [PullDownMenuDivider], a pull-down menu entry that is a large
///   divider
/// * [PullDownMenuTitle], a pull-down menu entry for a menu title.
/// * [PullDownMenuActionsRow], a more compact way to show multiple pull-down
///   menu entries for a simple action.
/// * [PullDownButtonTheme], a pull-down button and menu theme configuration.
/// * [PullDownButton], a default way of displaying a pull-down menu.
/// * [showPullDownMenu], another alternative way of displaying a pull-down
///   menu.
@immutable
class PullDownMenu extends StatelessWidget {
  /// Creates a pull-down menu.
  const PullDownMenu({
    super.key,
    required this.items,
    this.scrollController,
    this.routeTheme,
  });

  /// Items to show in the menu.
  ///
  /// If items contain at least one tappable menu item of type
  /// [PullDownMenuItem.selectable] all of [PullDownMenuItem]s should also be of
  /// type [PullDownMenuItem.selectable].
  ///
  /// See https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons
  ///
  /// In order to achieve it all [PullDownMenuItem]s will automatically switch
  /// to the "selectable" view.
  final List<Widget> items;

  /// A scroll controller that can be used to control the scrolling of the
  /// [items] in the menu.
  ///
  /// If `null`, uses an internally created [ScrollController].
  final ScrollController? scrollController;

  /// The theme of this [PullDownMenu].
  ///
  /// If this property is null, then [PullDownMenuRouteTheme] from
  /// [PullDownButtonTheme.routeTheme] is used.
  ///
  /// If that's null, then [PullDownMenuRouteTheme.defaults] is used.
  final PullDownMenuRouteTheme? routeTheme;

  @override
  Widget build(BuildContext context) {
    final PullDownButtonTheme ambientOf = PullDownButtonTheme.ambientOf(
      context,
    );
    final PullDownMenuRouteTheme theme = ambientOf.routeTheme;

    final bool hasLeading = MenuConfig.menuHasLeading(items);

    final bool isInAccessibilityMode =
        ContentSizeCategory.isInAccessibilityMode(context);

    return MenuConfig(
      hasLeading: hasLeading,
      ambientTheme: ambientOf,
      contentSizeCategory: ContentSizeCategory.of(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [theme.shadow!],
        ),
        child: MenuDecoration(
          backgroundColor: theme.backgroundColor!,
          borderRadius: theme.borderRadius!,
          borderClipper: theme.borderClipper!,
          child: AnimatedMenuContainer(
            constraints: BoxConstraints.tightFor(
              width:
                  isInAccessibilityMode
                      ? theme.accessibilityWidth
                      : theme.width,
            ),
            child: SwipeRegion(
              child: MenuBody(
                scrollController: scrollController,
                items: items,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
