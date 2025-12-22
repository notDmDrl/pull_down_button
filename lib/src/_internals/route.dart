import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'animation.dart';
import 'continuous_swipe.dart';
import 'menu_config.dart';
import 'route_menu.dart';

part 'route_layout.dart';

/// Route used by [PullDownButton] or [showPullDownMenu] to display
/// [RoutePullDownMenu].
@internal
class PullDownMenuRoute<VoidCallback> extends PopupRoute<VoidCallback> {
  /// Creates [PullDownMenuRoute].
  PullDownMenuRoute({
    required this.items,
    required this.barrierLabel,
    required this.routeTheme,
    required this.buttonRect,
    required this.menuPosition,
    required this.capturedThemes,
    required this.hasLeading,
    required this.itemsOrder,
    required this.alignment,
    required this.menuOffset,
    required this.menuSpacing,
    required this.scrollController,
    required super.settings,
  });

  /// Items to show in the [RoutePullDownMenu] created by this route.
  final List<PullDownMenuEntry> items;

  /// Captured inherited themes, specifically [PullDownButtonInheritedTheme],
  /// to pass to [RoutePullDownMenu] and all its [items].
  final CapturedThemes capturedThemes;

  /// The custom route theme to be used by [RoutePullDownMenu].
  final PullDownMenuRouteTheme? routeTheme;

  /// Whether the pull-down menu has any [PullDownMenuItem]s with leading
  /// widget such as chevron.
  final bool hasLeading;

  /// Rect of a button used to open the pull-down menu.
  ///
  /// Is used to calculate the final menu's position.
  final Rect buttonRect;

  /// Is used to define whether the pull-down menu is positioned above, over or
  /// under the calculated menu's position.
  final PullDownMenuPosition menuPosition;

  /// Is used to define how the menu will order its [items] depending on
  /// calculated menu's position.
  final PullDownMenuItemsOrder itemsOrder;

  /// The point menu scales from. Generated with
  /// [PullDownMenuRoute.animationAlignment] before creating the route.
  final Alignment alignment;

  /// Is used to define additional on-side offset to the menu's final position.
  final double menuOffset;

  /// Is used to define additional vertical spacing between the button and the menu.
  final double menuSpacing;

  /// A scroll controller that can be used to control the scrolling of the
  /// [items] in the menu.
  final ScrollController? scrollController;

  @override
  final String barrierLabel;

  @override
  Animation<double> createAnimation() => CurvedAnimation(
        parent: super.createAnimation(),
        curve: AnimationUtils.kCurve,
        reverseCurve: AnimationUtils.kCurveReverse,
      );

  @override
  Duration get transitionDuration => AnimationUtils.kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final orderedItems = switch (itemsOrder) {
      PullDownMenuItemsOrder.downwards => items,
      PullDownMenuItemsOrder.upwards => items.reversed,
      PullDownMenuItemsOrder.automatic =>
        alignment.y == -1 ? items : items.reversed
    };

    return MenuConfig(
      hasLeading: hasLeading,
      child: RoutePullDownMenu(
        scrollController: scrollController,
        items: orderedItems.toList(),
        routeTheme: routeTheme,
        animation: animation,
        alignment: alignment,
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final mediaQuery = MediaQuery.of(context);

    final avoidBounds = DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

    return SwipeRegion(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            buttonRect: buttonRect,
            padding: mediaQuery.padding,
            avoidBounds: avoidBounds,
            menuPosition: menuPosition,
            menuOffset: menuOffset,
            menuSpacing: menuSpacing,
          ),
          child: capturedThemes.wrap(child),
        ),
      ),
    );
  }

  /// Attempt to predict an animation alignment for [RoutePullDownMenu] using
  /// a button's position.
  ///
  /// Uses smooth interpolation for horizontal alignment based on the button's
  /// relative position on screen.
  static Alignment animationAlignment(
    BuildContext context,
    Rect buttonRect,
  ) {
    final buttonCenter = buttonRect.center;

    final size = MediaQuery.of(context).size;

    final heightCenter = size.height / 2;

    final isInBottomHalf = buttonCenter.dy >= heightCenter;
    final y = isInBottomHalf ? 1.0 : -1.0;

    // Calculate smooth horizontal alignment based on button position
    // normalized to range [-1, 1] where:
    // -1 = left edge, 0 = center, 1 = right edge
    final normalizedX = (buttonCenter.dx - size.width / 2) / (size.width / 2);
    final x = normalizedX.clamp(-1.0, 1.0);

    return Alignment(x, y);
  }
}
