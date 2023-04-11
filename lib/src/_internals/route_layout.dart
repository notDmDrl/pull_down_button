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
  });

  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Rect buttonRect;
  final PullDownMenuPosition menuPosition;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final biggest = constraints.biggest;

    final constraintsHeight = biggest.height;
    final double height;

    // TODO(notDmDrl): final height = switch (menuPosition) {
    switch (menuPosition) {
      case PullDownMenuPosition.over:
        height = buttonRect.center.dy >= constraintsHeight / 2
            ? buttonRect.bottom - padding.top
            : constraintsHeight - buttonRect.top - padding.bottom;
        break;
      case PullDownMenuPosition.automatic:
        height = buttonRect.center.dy >= constraintsHeight / 2
            ? buttonRect.top - padding.top
            : constraintsHeight - buttonRect.bottom - padding.bottom;
    }

    return BoxConstraints.loose(
      Size(biggest.width, height),
    ).deflate(
      const EdgeInsets.symmetric(horizontal: _kMenuScreenPadding),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final childWidth = childSize.width;

    // Additionally moves desired `x` by 16px left or right if menu's alignment
    // is not considered "centered".
    // Based on native comparison with iOS 16 Simulator.
    const additionalX = 16;

    final horizontalPosition = _MenuHorizontalPosition.get(size, buttonRect);

    // TODO(notDmDrl): final x = switch (horizontalPosition) {
    final double x;
    switch (horizontalPosition) {
      case _MenuHorizontalPosition.right:
        x = buttonRect.right - childWidth + additionalX;
        break;
      case _MenuHorizontalPosition.left:
        x = buttonRect.left - additionalX;
        break;
      case _MenuHorizontalPosition.center:
        x = buttonRect.left + buttonRect.width / 2 - childWidth / 2;
    }

    final originCenter = buttonRect.center;
    final rect = Offset.zero & size;
    final subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(rect, avoidBounds);
    final subScreen = _PositionUtils.closestScreen(subScreens, originCenter);

    final dx = _PositionUtils.fitX(x, subScreen, childWidth, padding);
    final dy = _PositionUtils.fitY(
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

@immutable
abstract class _PositionUtils {
  const _PositionUtils._();

  static Rect closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }

    return closest;
  }

  static double fitY(
    Rect buttonRect,
    Rect screen,
    double childHeight,
    EdgeInsets padding,
    PullDownMenuPosition menuPosition,
  ) {
    var y = buttonRect.top;
    final buttonHeight = buttonRect.height;

    final isInBottomHalf = y + buttonHeight / 2 >= screen.height / 2;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (isInBottomHalf) {
          y -= childHeight - buttonHeight;
        }
        break;
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

  static double fitX(
    double wantedX,
    Rect screen,
    double childWidth,
    EdgeInsets padding,
  ) {
    final leftSafeArea = screen.left + _kMenuScreenPadding + padding.left;
    final rightSafeArea = screen.right - _kMenuScreenPadding - padding.right;

    if (wantedX < leftSafeArea) {
      return leftSafeArea;
    } else if (wantedX + childWidth > rightSafeArea) {
      return rightSafeArea - childWidth;
    }

    return wantedX;
  }
}
