part of 'route.dart';

/// Minimum space from horizontal screen edges for the pull-down menu to be
/// rendered from.
const double _kMenuScreenPadding = 8;

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.padding,
    required this.avoidBounds,
    required this.buttonRect,
    required this.menuPosition,
    required this.menuOffset,
  });

  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Rect buttonRect;
  final PullDownMenuPosition menuPosition;
  final double menuOffset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final Size biggest = constraints.biggest;

    final double constraintsHeight = biggest.height;

    final bool check = buttonRect.center.dy >= constraintsHeight / 2;

    final double height = switch (menuPosition) {
      PullDownMenuPosition.over when check => buttonRect.bottom - padding.top,
      PullDownMenuPosition.over =>
        constraintsHeight - buttonRect.top - padding.bottom,
      PullDownMenuPosition.automatic when check => buttonRect.top - padding.top,
      PullDownMenuPosition.automatic =>
        constraintsHeight - buttonRect.bottom - padding.bottom,
    };

    return BoxConstraints.loose(
      Size(biggest.width, height),
    ).deflate(
      const EdgeInsets.symmetric(horizontal: _kMenuScreenPadding),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double childWidth = childSize.width;

    final _MenuHorizontalPosition horizontalPosition =
        _MenuHorizontalPosition.get(size, buttonRect);

    final double x = switch (horizontalPosition) {
      _MenuHorizontalPosition.right =>
        buttonRect.right - childWidth + menuOffset,
      _MenuHorizontalPosition.left => buttonRect.left - menuOffset,
      _MenuHorizontalPosition.center =>
        buttonRect.left + buttonRect.width / 2 - childWidth / 2,
    };

    final Offset originCenter = buttonRect.center;
    final Rect rect = Offset.zero & size;
    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(rect, avoidBounds);
    final Rect subScreen = _PositionUtils.closestScreen(
      subScreens,
      originCenter,
    );

    final double dx = _PositionUtils.fitX(x, subScreen, childWidth, padding);
    final double dy = _PositionUtils.fitY(
      buttonRect,
      subScreen,
      childSize.height,
      padding,
      menuPosition,
    );

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds) ||
      buttonRect != oldDelegate.buttonRect ||
      menuPosition != oldDelegate.menuPosition;
}

/// A set of utils to help calculating menu's position on screen.
@immutable
abstract class _PositionUtils {
  const _PositionUtils._();

  /// Returns closest screen for specific [point].
  static Rect closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }

    return closest;
  }

  /// Returns the `y` a top left offset point for menu's container.
  static double fitY(
    Rect buttonRect,
    Rect screen,
    double childHeight,
    EdgeInsets padding,
    PullDownMenuPosition menuPosition,
  ) {
    double y = buttonRect.top;
    final double buttonHeight = buttonRect.height;

    final bool isInBottomHalf = y + buttonHeight / 2 >= screen.height / 2;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (isInBottomHalf) {
          y -= childHeight - buttonHeight;
        }
      case PullDownMenuPosition.automatic:
        // Native variant applies additional 5px of padding to menu if
        // [buttonHeight] is smaller than 44px.
        final padding =
            buttonHeight < kMinInteractiveDimensionCupertino ? 5 : 0;

        isInBottomHalf
            ? y -= childHeight + padding
            : y += buttonHeight + padding;
    }

    return y;
  }

  /// Returns the `x` a top left offset point for menu's container.
  static double fitX(
    double wantedX,
    Rect screen,
    double childWidth,
    EdgeInsets padding,
  ) {
    final double leftSafeArea =
        screen.left + _kMenuScreenPadding + padding.left;
    final double rightSafeArea =
        screen.right - _kMenuScreenPadding - padding.right;

    if (wantedX < leftSafeArea) {
      return leftSafeArea;
    } else if (wantedX + childWidth > rightSafeArea) {
      return rightSafeArea - childWidth;
    }

    return wantedX;
  }
}
