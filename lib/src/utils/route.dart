import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'constants.dart';
import 'menu.dart';

// ignore_for_file: public_member_api_docs, comment_references

/// Copy of [_PopupMenuRoute] from [PopupMenuButton] implementation since it's
/// private there.
@protected
class PullDownMenuRoute extends PopupRoute<VoidCallback> {
  PullDownMenuRoute({
    required this.position,
    required this.items,
    required this.barrierLabel,
    required this.backgroundColor,
    required this.buttonSize,
    required this.menuPosition,
    required this.capturedThemes,
    required this.widthConfiguration,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final List<PullDownMenuEntry> items;
  final List<Size?> itemSizes;
  final Color? backgroundColor;
  final CapturedThemes capturedThemes;
  final PullDownMenuWidthConfiguration? widthConfiguration;

  @protected
  final RelativeRect position;

  @protected
  final Size buttonSize;

  @protected
  final PullDownMenuPosition menuPosition;

  @override
  Animation<double> createAnimation() => CurvedAnimation(
        parent: super.createAnimation(),
        curve: kCurve,
        reverseCurve: kCurve.flipped,
      );

  @override
  Duration get transitionDuration => kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget menu = PullDownMenu(route: this);

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
            itemSizes: itemSizes,
            textDirection: Directionality.of(context),
            padding: mediaQuery.padding,
            avoidBounds: _avoidBounds(mediaQuery),
            buttonSize: buttonSize,
            menuPosition: menuPosition,
          ),
          child: capturedThemes.wrap(menu),
        ),
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) =>
      DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
}

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.position,
    required this.itemSizes,
    required this.textDirection,
    required this.padding,
    required this.avoidBounds,
    required this.buttonSize,
    required this.menuPosition,
  });

  final RelativeRect position;
  final List<Size?> itemSizes;
  final TextDirection textDirection;
  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Size buttonSize;
  final PullDownMenuPosition menuPosition;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double height;

    switch (menuPosition) {
      case PullDownMenuPosition.under:
        height = _getHeightForUnder(constraints);
        break;
      case PullDownMenuPosition.above:
        height = _getHeightForAbove(constraints);
        break;
      case PullDownMenuPosition.over:
        height = _getHeightForOver(constraints);
        break;
      case PullDownMenuPosition.automatic:
        height = _getHeightForAutomatic(constraints);
    }

    return BoxConstraints.loose(
      Size(constraints.biggest.width, height),
    ).deflate(
      const EdgeInsets.symmetric(horizontal: kMenuScreenPadding),
    );
  }

  double _getHeightForUnder(BoxConstraints constraints) {
    final constraintsHeight = constraints.biggest.height;
    final availableHeight =
        constraintsHeight - position.top - buttonSize.height;

    if (availableHeight <
        kMinInteractiveDimensionCupertino * 2 + padding.bottom) {
      return constraintsHeight -
          buttonSize.height -
          padding.top -
          kMenuScreenPadding -
          position.bottom;
    } else {
      return availableHeight - padding.bottom - kMenuScreenPadding;
    }
  }

  double _getHeightForAbove(BoxConstraints constraints) {
    final constraintsHeight = constraints.biggest.height;
    final availableHeight =
        constraintsHeight - position.bottom - buttonSize.height;

    if (availableHeight < kMinInteractiveDimensionCupertino * 2 + padding.top) {
      return constraintsHeight -
          buttonSize.height -
          padding.bottom -
          kMenuScreenPadding -
          position.top;
    } else {
      return availableHeight - padding.top - kMenuScreenPadding;
    }
  }

  double _getHeightForOver(BoxConstraints constraints) {
    final constraintsHeight = constraints.biggest.height;
    final availableHeight = constraintsHeight - position.top;

    if (availableHeight < kMinInteractiveDimensionCupertino * 2) {
      return constraintsHeight - padding.top - position.bottom;
    } else {
      return availableHeight - padding.bottom - kMenuScreenPadding;
    }
  }

  double _getHeightForAutomatic(BoxConstraints constraints) {
    final constraintsHeight = constraints.biggest.height;

    if (position.top > constraintsHeight / 2) {
      return constraintsHeight -
          position.bottom -
          buttonSize.height -
          padding.top -
          kMenuScreenPadding;
    } else {
      return constraintsHeight -
          position.top -
          buttonSize.height -
          padding.bottom -
          kMenuScreenPadding;
    }
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final y = position.top;

    double x;
    if (position.left > position.right) {
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      x = position.left;
    } else {
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }
    final wantedPosition = Offset(x, y);
    final originCenter = position.toRect(Offset.zero & size).center;
    final subScreens = DisplayFeatureSubScreen.subScreensInBounds(
      Offset.zero & size,
      avoidBounds,
    );
    final subScreen = _closestScreen(subScreens, originCenter);

    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }

    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    final x = _fitX(wantedPosition.dx, screen, childSize.width);
    // y is uppermost position of button
    var y = wantedPosition.dy;

    final childHeight = childSize.height;
    final buttonHeight = buttonSize.height;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (y + childHeight > screen.bottom) {
          y -= childHeight - buttonHeight;
        }
        break;
      case PullDownMenuPosition.under:
        if (y + buttonHeight + childHeight > screen.bottom) {
          y -= childHeight;
        } else {
          y += buttonHeight;
        }
        break;
      case PullDownMenuPosition.above:
        if (y - buttonHeight > screen.top + padding.top) {
          y -= childHeight;
        } else {
          y += buttonHeight;
        }
        break;
      case PullDownMenuPosition.automatic:
        if (y > screen.height / 2) {
          y -= childHeight;
        } else {
          y += buttonHeight;
        }
    }

    return Offset(x, y);
  }

  double _fitX(double wantedX, Rect screen, double childWidth) {
    final fitLeft = screen.left + kMenuScreenPadding + padding.left;
    final fitRight = screen.right - kMenuScreenPadding - padding.right;

    if (wantedX < fitLeft) {
      return fitLeft;
    } else if (wantedX + childWidth > fitRight) {
      return fitRight - childWidth;
    }

    return wantedX;
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      position != oldDelegate.position ||
      textDirection != oldDelegate.textDirection ||
      !listEquals(itemSizes, oldDelegate.itemSizes) ||
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds) ||
      buttonSize != oldDelegate.buttonSize ||
      menuPosition != oldDelegate.menuPosition;
}
