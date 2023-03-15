import 'package:flutter/material.dart';
import 'package:pull_down_button/src/_internals/menu.dart';
import 'package:pull_down_button/src/_internals/menu_config.dart';

import '../pull_down_button.dart';
import '_internals/continuous_swipe.dart';

/// Displays a pull-down menu as a simple widget, with no animations or adding
/// routes to navigation stack.
///
/// This is an alternative way of displaying pull-down menu, [PullDownButton]
/// should be enough for most cases.
///
/// See also:
///
/// * [PullDownMenuItem], a pull-down menu entry for a simple action.
/// * [PullDownMenuItem.selectable], a pull-down menu entry for a selection
///   action.
/// * [PullDownMenuDivider], a pull-down menu entry for a divider.
/// * [PullDownMenuDivider.large], a pull-down menu entry that is a large
///   divider.
/// * [PullDownMenuTitle], a pull-down menu entry for a menu title.
/// * [PullDownMenuActionsRow], a more compact way to show multiple pull-down
///   menu entries for a simple action.
/// * [PullDownButtonTheme], a pull-down button and menu theme configuration.
/// * [PullDownButton], a default way of displaying a pull-down menu.
/// * [showPullDownMenu], an another alternative way of displaying a pull-down
/// menu.
@immutable
class PullDownMenu extends StatelessWidget {
  /// Creates a pull-down menu.
  const PullDownMenu({
    super.key,
    required this.items,
    this.routeTheme,
  });

  /// Items to show in the menu.
  ///
  /// If items contains at least one tappable menu item of type
  /// [PullDownMenuItem.selectable] all of [PullDownMenuItem]s should also be of
  /// type [PullDownMenuItem.selectable].
  ///
  /// See https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons
  ///
  /// In order to achieve it all [PullDownMenuItem]s will automatically switch
  /// to "selectable" view.
  final List<PullDownMenuEntry> items;

  /// Theme of route used to display pull-down menu launched from this
  /// [PullDownMenu].
  ///
  /// If this property is null then [PullDownMenuRouteTheme] from
  /// [PullDownButtonTheme.routeTheme] is used.
  ///
  /// If that's null then [PullDownMenuRouteTheme.defaults] is used.
  final PullDownMenuRouteTheme? routeTheme;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuRouteTheme.resolve(
      context,
      routeTheme: routeTheme,
    );

    final hasLeading = MenuConfig.menuHasLeading(items);

    return MenuConfig(
      hasLeading: hasLeading,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [theme.endShadow!],
        ),
        child: MenuDecoration(
          backgroundColor: theme.backgroundColor!,
          borderRadius: theme.borderRadius!,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: theme.width,
            ),
            child: MenuContinuousSwipe(
              child: MenuBody(items: items),
            ),
          ),
        ),
      ),
    );
  }
}
