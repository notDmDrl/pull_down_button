import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../items/entry.dart';
import 'constants.dart';
import 'menu.dart';

// ignore_for_file: public_member_api_docs

// ignore: comment_references
/// Copy of [_PopupMenuRoute] from [PopupMenuButton] implementation since it's
/// private there.
@protected
class PullDownMenuRoute extends PopupRoute<void> {
  PullDownMenuRoute({
    required this.position,
    required this.items,
    required this.barrierLabel,
    required this.capturedThemes,
    required this.backgroundColor,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect position;
  final List<PullDownMenuEntry> items;
  final List<Size?> itemSizes;
  final CapturedThemes capturedThemes;
  final Color? backgroundColor;

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
            position,
            itemSizes,
            Directionality.of(context),
            mediaQuery.padding,
            _avoidBounds(mediaQuery),
          ),
          child: capturedThemes.wrap(menu),
        ),
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) =>
      DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
}

@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.textDirection,
    this.padding,
    this.avoidBounds,
  );

  final RelativeRect position;
  final List<Size?> itemSizes;
  final TextDirection textDirection;
  final EdgeInsets padding;
  final Set<Rect> avoidBounds;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest).deflate(
        const EdgeInsets.all(kMenuScreenPadding) + padding,
      );

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
    var x = wantedPosition.dx;
    var y = wantedPosition.dy;

    if (x < screen.left + kMenuScreenPadding + padding.left) {
      x = screen.left + kMenuScreenPadding + padding.left;
    } else if (x + childSize.width >
        screen.right - kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + kMenuScreenPadding + padding.top) {
      y = kMenuScreenPadding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - kMenuScreenPadding - padding.bottom) {
      y = screen.bottom -
          childSize.height -
          kMenuScreenPadding -
          padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      position != oldDelegate.position ||
      textDirection != oldDelegate.textDirection ||
      !listEquals(itemSizes, oldDelegate.itemSizes) ||
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds);
}
