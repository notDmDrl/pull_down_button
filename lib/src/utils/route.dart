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
  /// Copy of [_PopupMenuRoute] from [PopupMenuButton] implementation since it's
  /// private there.
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
            position,
            itemSizes,
            Directionality.of(context),
            mediaQuery.padding,
            _avoidBounds(mediaQuery),
            buttonSize,
            menuPosition,
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
    this.buttonSize,
    this.menuPosition,
  );

  final RelativeRect position;
  final List<Size?> itemSizes;
  final TextDirection textDirection;
  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Size buttonSize;
  final PullDownMenuPosition menuPosition;

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

    // Subtract from `y` to fit all of a menu above wanted position.
    if (menuPosition == PullDownMenuPosition.above) {
      y -= childSize.height;
    }
    // Add to `y` to fit all of a menu under wanted position.
    else if (menuPosition == PullDownMenuPosition.under) {
      y += buttonSize.height;
    }

    // Check for available space at the top of the screen.

    // Never triggers if `menuPosition` == [PullDownMenuPosition.under] since
    // we already apply correct offset in `showButtonMenu()`.
    if (y < screen.top + kMenuScreenPadding + padding.top) {
      // Threat [PullDownMenuPosition.over] and [PullDownMenuPosition.above]
      // as same.

      y = padding.top;
    }
    // Check for available space at the bottom of the screen.
    else if (y + childSize.height >
        screen.bottom - kMenuScreenPadding - padding.bottom) {
      // Threat [PullDownMenuPosition.over] and [PullDownMenuPosition.under]
      // as same.
      y = screen.bottom - childSize.height - padding.bottom;
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
