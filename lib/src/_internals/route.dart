import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'animation.dart';
import 'extensions.dart';
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
  });

  /// Items to show in the [RoutePullDownMenu] created by this route.
  final List<PullDownMenuEntry> items;

  /// Captured inherited themes, specifically [PullDownButtonInheritedTheme] to
  /// pass to [RoutePullDownMenu] and all its [items].
  final CapturedThemes capturedThemes;

  /// The custom route theme to be used by [RoutePullDownMenu].
  final PullDownMenuRouteTheme? routeTheme;

  /// Whether menu has any [PullDownMenuItem]s with leading widget such as
  /// chevron.
  final bool hasLeading;

  /// Rect of a button used to open pull-down menu.
  ///
  /// Is used to calculate final menu's position.
  final Rect buttonRect;

  /// Is used to define whether the popup menu is positioned above, over or
  /// under the calculated menu's position.
  final PullDownMenuPosition menuPosition;

  /// Is used to define how menu will order its [items] depending on
  /// calculated menu's position.
  final PullDownMenuItemsOrder itemsOrder;

  /// The point menu scales from. Generated with
  /// [PullDownMenuRoute.predictedAnimationAlignment] before creating the route.
  final Alignment alignment;

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

    final Widget menu = MenuConfig(
      hasLeading: hasLeading,
      child: RoutePullDownMenu(
        items: orderedItems.toList(),
        routeTheme: routeTheme,
        animation: animation,
        alignment: alignment,
      ),
    );

    final mediaQuery = MediaQuery.of(context);

    final avoidBounds = DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (context) => CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            buttonRect: buttonRect,
            padding: mediaQuery.padding,
            avoidBounds: avoidBounds,
            menuPosition: menuPosition,
          ),
          child: capturedThemes.wrap(menu),
        ),
      ),
    );
  }

  /// Attempt to predict an animation alignment for [RoutePullDownMenu] using
  /// a button's position.
  static Alignment predictedAnimationAlignment(
    BuildContext context,
    Rect buttonRect,
  ) {
    final buttonCenter = buttonRect.center;

    final size = MediaQuery.of(context).size;

    final heightCenter = size.height / 2;

    final isInBottomHalf = buttonCenter.dy >= heightCenter;

    final horizontalPosition = _MenuHorizontalPosition.get(size, buttonRect);

    switch (horizontalPosition) {
      case _MenuHorizontalPosition.right:
        return isInBottomHalf ? Alignment.bottomRight : Alignment.topRight;
      case _MenuHorizontalPosition.left:
        return isInBottomHalf ? Alignment.bottomLeft : Alignment.topLeft;
      case _MenuHorizontalPosition.center:
        return isInBottomHalf ? Alignment.bottomCenter : Alignment.topCenter;
    }
  }

  /// Given a [BuildContext], return the Rect of the corresponding [RenderBox]'s
  /// paintBounds in global coordinates.
  static Rect getRect(BuildContext context) {
    final renderBoxContainer = context.currentRenderBox;

    return Rect.fromPoints(
      renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
      ),
      renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.bottomRight,
      ),
    );
  }
}

enum _MenuHorizontalPosition {
  left,
  right,
  center;

  static _MenuHorizontalPosition get(
    Size size,
    Rect buttonRect,
  ) {
    final leftPosition = buttonRect.left;
    final rightPosition = buttonRect.right;

    final width = size.width;
    final widthCenter = width / 2;

    // Allowed threshold of screen side (left / right) for menu to be opened
    // using "centered" alignment.
    // Based on native compare with iOS 16 Simulator.
    const threshold = 0.2744;

    final leftCenteredThreshold = widthCenter * (1 - threshold);
    final rightCenteredThreshold = widthCenter * threshold + widthCenter;

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
