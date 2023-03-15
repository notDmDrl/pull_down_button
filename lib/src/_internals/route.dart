import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'animation.dart';
import 'menu_config.dart';
import 'route_menu.dart';

part 'route_layout.dart';

/// Route used by [PullDownButton] or [showPullDownMenu] to display
/// [RoutePullDownMenu].
@internal
class PullDownMenuRoute<VoidCallback> extends PopupRoute<VoidCallback> {
  /// Creates [PullDownMenuRoute].
  PullDownMenuRoute({
    required this.position,
    required this.items,
    required this.barrierLabel,
    required this.routeTheme,
    required this.buttonSize,
    required this.menuPosition,
    required this.capturedThemes,
    required this.hasLeading,
    required this.itemsOrder,
  }) : _menuAlignmentNotifier = ValueNotifier(Alignment.topRight);

  /// Items to show in the [RoutePullDownMenu] created by this route.
  final List<PullDownMenuEntry> items;

  /// Captured inherited themes, specifically [PullDownButtonInheritedTheme] to
  /// pass to [RoutePullDownMenu] and all its [items];
  final CapturedThemes capturedThemes;

  /// The custom route theme to be used by [RoutePullDownMenu].
  final PullDownMenuRouteTheme? routeTheme;

  /// Whether menu has any [PullDownMenuItem]s with leading widget such as
  /// chevron.
  final bool hasLeading;

  /// Desired menu's on-screen position.
  ///
  /// Is used to calculate final menu's position.
  final RelativeRect position;

  /// Size of a button used to open pull-down menu.
  ///
  /// Is used to calculate final menu's position.
  final Size buttonSize;

  /// Is used to define whether the popup menu is positioned above, over or
  /// under the calculated menu's position.
  final PullDownMenuPosition menuPosition;

  /// Is used to define how menu will order its [items] depending on
  /// calculated menu's position.
  final PullDownMenuItemsOrder itemsOrder;

  @override
  final String barrierLabel;

  @override
  Animation<double> createAnimation() => CurvedAnimation(
        parent: super.createAnimation(),
        curve: kCurve,
        reverseCurve: kCurveReverse,
      );

  @override
  Duration get transitionDuration => kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  final ValueNotifier<Alignment> _menuAlignmentNotifier;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget menu = MenuConfig(
      hasLeading: hasLeading,
      child: ValueListenableBuilder<Alignment>(
        valueListenable: _menuAlignmentNotifier,
        builder: (_, alignment, __) {
          final Iterable<PullDownMenuEntry> orderedItems;

          switch (itemsOrder) {
            case PullDownMenuItemsOrder.downwards:
              orderedItems = items;
              break;
            case PullDownMenuItemsOrder.upwards:
              orderedItems = items.reversed;
              break;
            case PullDownMenuItemsOrder.automatic:
              orderedItems = alignment.y == -1 ? items : items.reversed;
              break;
          }

          return RoutePullDownMenu(
            items: orderedItems.toList(),
            routeTheme: routeTheme,
            animation: animation,
            alignment: alignment,
          );
        },
      ),
    );

    final mediaQuery = MediaQuery.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (context) => CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            position: position,
            textDirection: Directionality.of(context),
            padding: mediaQuery.padding,
            avoidBounds: _avoidBounds(mediaQuery),
            buttonSize: buttonSize,
            menuPosition: menuPosition,
            onChangeMenuAlignment: _onChangeMenuAlignment,
          ),
          child: capturedThemes.wrap(menu),
        ),
      ),
    );
  }

  static Set<Rect> _avoidBounds(MediaQueryData mediaQuery) =>
      DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

  void _onChangeMenuAlignment(
    bool? isInRightHalf,
    bool isInBottomHalf,
  ) {
    final Alignment alignment;

    if (isInRightHalf == null) {
      alignment = isInBottomHalf ? Alignment.bottomCenter : Alignment.topCenter;
    } else {
      if (isInRightHalf && !isInBottomHalf) {
        alignment = Alignment.topRight;
      } else if (!isInRightHalf && !isInBottomHalf) {
        alignment = Alignment.topLeft;
      } else if (isInRightHalf && isInBottomHalf) {
        alignment = Alignment.bottomRight;
      } else if (!isInRightHalf && isInBottomHalf) {
        alignment = Alignment.bottomLeft;
      } else {
        alignment = Alignment.topCenter;
      }
    }

    WidgetsBinding.instance.scheduleFrameCallback(
      (_) => _menuAlignmentNotifier.value = alignment,
    );
  }
}
