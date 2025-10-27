/// @docImport '/src/items/item.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '/src/pull_down_button.dart';
import '/src/theme/route_theme.dart';
import '/src/theme/theme.dart';
import 'animation.dart';
import 'content_size_category.dart';
import 'continuous_swipe.dart';
import 'menu_config.dart';
import 'route_menu.dart';

part 'route_layout.dart';

/// Route used by [PullDownButton] or [showPullDownMenu] to display
/// [RoutePullDownMenu].
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
    required this.scrollController,
    required super.settings,
  });

  /// Items to show in the [RoutePullDownMenu] created by this route.
  final List<Widget> items;

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
    final Iterable<Widget> orderedItems = switch (itemsOrder) {
      PullDownMenuItemsOrder.downwards => items,
      PullDownMenuItemsOrder.upwards => items.reversed,
      PullDownMenuItemsOrder.automatic =>
        alignment.y == -1 ? items : items.reversed,
    };

    return MenuConfig(
      hasLeading: hasLeading,
      ambientTheme: PullDownButtonTheme.ambientOf(context),
      contentSizeCategory: ContentSizeCategory.of(context),
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
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final Set<Rect> avoidBounds =
        DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

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
          ),
          child: capturedThemes.wrap(child),
        ),
      ),
    );
  }

  /// Attempt to predict an animation alignment for [RoutePullDownMenu] using
  /// a button's position.
  static Alignment animationAlignment(
    BuildContext context,
    Rect buttonRect,
  ) {
    final Offset buttonCenter = buttonRect.center;

    final Size size = MediaQuery.of(context).size;

    final double heightCenter = size.height / 2;

    final bool isInBottomHalf = buttonCenter.dy >= heightCenter;

    final _MenuHorizontalPosition horizontalPosition =
        _MenuHorizontalPosition.get(size, buttonRect);

    return switch (horizontalPosition) {
      _MenuHorizontalPosition.right when isInBottomHalf =>
        Alignment.bottomRight,
      _MenuHorizontalPosition.right => Alignment.topRight,
      _MenuHorizontalPosition.left when isInBottomHalf => Alignment.bottomLeft,
      _MenuHorizontalPosition.left => Alignment.topLeft,
      _MenuHorizontalPosition.center when isInBottomHalf =>
        Alignment.bottomCenter,
      _MenuHorizontalPosition.center => Alignment.topCenter,
    };
  }
}

/// A predicted menu's horizontal position.
///
/// Is used by [PullDownMenuRoute.animationAlignment]
enum _MenuHorizontalPosition {
  /// The button's left side is located closer to the left side of the screen
  /// than the button's right side to the right side of the screen.
  left,

  /// The button's right side is located closer to the right side of the screen
  /// than the button's left side to the left side of the screen.
  right,

  /// Both horizontal button's sides are located in an allowed screen zone
  /// around center.
  center;

  /// Returns a [_MenuHorizontalPosition] for provided screen [size] and a
  /// [buttonRect].
  static _MenuHorizontalPosition get(
    Size size,
    Rect buttonRect,
  ) {
    final double leftPosition = buttonRect.left;
    final double rightPosition = buttonRect.right;

    final double width = size.width;
    final double widthCenter = width / 2;

    // Allowed threshold of screen side (left / right) for the menu to be opened
    // using "centered" alignment.
    // Based on native comparison with iOS 16 Simulator.
    const threshold = 0.2744;

    final double leftCenteredThreshold = widthCenter * (1 - threshold);
    final double rightCenteredThreshold = widthCenter * threshold + widthCenter;

    if (buttonRect.center.dx == widthCenter ||
        (leftPosition >= leftCenteredThreshold &&
            rightPosition <= rightCenteredThreshold)) {
      return _MenuHorizontalPosition.center;
    } else if (leftPosition < width - rightPosition) {
      return _MenuHorizontalPosition.left;
    } else {
      return _MenuHorizontalPosition.right;
    }
  }
}
