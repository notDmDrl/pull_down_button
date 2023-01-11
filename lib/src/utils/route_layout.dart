part of 'route.dart';

/// Minimum space from screen edges for pull-down menu to be rendered from.
const double _kMenuScreenPadding = 8;

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.position,
    required this.textDirection,
    required this.padding,
    required this.avoidBounds,
    required this.buttonSize,
    required this.menuPosition,
  });

  final RelativeRect position;
  final TextDirection textDirection;
  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Size buttonSize;
  final PullDownMenuPosition menuPosition;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final biggest = constraints.biggest;

    final double height;

    switch (menuPosition) {
      case PullDownMenuPosition.under:
        height = _HeightFor.under(
          biggest.height,
          buttonSize.height,
          padding,
          position,
        );
        break;
      case PullDownMenuPosition.above:
        height = _HeightFor.above(
          biggest.height,
          buttonSize.height,
          padding,
          position,
        );
        break;
      case PullDownMenuPosition.over:
        height = _HeightFor.over(biggest.height, padding, position);
        break;
      case PullDownMenuPosition.automatic:
        height = _HeightFor.automatic(
          biggest.height,
          buttonSize.height,
          padding,
          position,
        );
    }

    return BoxConstraints.loose(
      Size(biggest.width, height),
    ).deflate(
      const EdgeInsets.symmetric(horizontal: _kMenuScreenPadding),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // cache a bunch of values to reuse later
    final childWidth = childSize.width;
    final sizeWidth = size.width;
    final rect = Offset.zero & size;
    final positionLeft = position.left.roundToDouble();
    final positionRight = position.right.roundToDouble();

    final y = position.top;

    double x;

    final bool? isInRightHalf;

    if (positionLeft > positionRight) {
      isInRightHalf = true;
      x = sizeWidth - positionRight - childWidth;
    } else if (positionLeft < positionRight) {
      isInRightHalf = false;
      x = positionLeft;
    } else {
      isInRightHalf = null;
      x = positionLeft + position.toSize(size).width / 2 - childWidth / 2;
    }

    final originCenter = position.toRect(rect).center;
    final subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(rect, avoidBounds);
    final subScreen = _PositionUtils.closestScreen(subScreens, originCenter);

    final dx = _PositionUtils.fitX(x, subScreen, childWidth, padding);
    final dy = _PositionUtils.fitY(
      y,
      subScreen,
      childSize.height,
      padding,
      buttonSize.height,
      menuPosition,
    );

    final offset = Offset(dx, dy);

    final isInBottomHalf = y > dy;

    _updateMenuAlignment(isInRightHalf, isInBottomHalf);

    return offset;
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      position != oldDelegate.position ||
      textDirection != oldDelegate.textDirection ||
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds) ||
      buttonSize != oldDelegate.buttonSize ||
      menuPosition != oldDelegate.menuPosition;
}

@immutable
abstract class _HeightFor {
  const _HeightFor._();

  static const _kMinimumAllowedSize = kMinInteractiveDimensionCupertino * 2;

  static double under(
    double constraintsHeight,
    double buttonHeight,
    EdgeInsets padding,
    RelativeRect position,
  ) {
    final availableHeight = constraintsHeight - position.top - buttonHeight;

    final paddingBottom = padding.bottom;

    if (availableHeight < _kMinimumAllowedSize + paddingBottom) {
      return constraintsHeight -
          buttonHeight -
          padding.top -
          _kMenuScreenPadding -
          position.bottom;
    }

    return availableHeight - paddingBottom - _kMenuScreenPadding;
  }

  static double above(
    double constraintsHeight,
    double buttonHeight,
    EdgeInsets padding,
    RelativeRect position,
  ) {
    final availableHeight = constraintsHeight - position.bottom - buttonHeight;

    final paddingTop = padding.top;

    if (availableHeight < _kMinimumAllowedSize + paddingTop) {
      return constraintsHeight -
          buttonHeight -
          padding.bottom -
          _kMenuScreenPadding -
          position.top;
    }

    return availableHeight - paddingTop - _kMenuScreenPadding;
  }

  static double over(
    double constraintsHeight,
    EdgeInsets padding,
    RelativeRect position,
  ) {
    final availableHeight = constraintsHeight - position.top;

    if (availableHeight < _kMinimumAllowedSize + padding.vertical) {
      return constraintsHeight - padding.top - position.bottom;
    }

    return availableHeight - padding.bottom - _kMenuScreenPadding;
  }

  static double automatic(
    double constraintsHeight,
    double buttonHeight,
    EdgeInsets padding,
    RelativeRect position,
  ) {
    if (position.top > constraintsHeight / 2) {
      return constraintsHeight -
          position.bottom -
          buttonHeight -
          padding.top -
          _kMenuScreenPadding;
    }

    return constraintsHeight -
        position.top -
        buttonHeight -
        padding.bottom -
        _kMenuScreenPadding;
  }
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
    double wantedY,
    Rect screen,
    double childHeight,
    EdgeInsets padding,
    double buttonHeight,
    PullDownMenuPosition menuPosition,
  ) {
    var y = wantedY;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (y + childHeight > screen.bottom) {
          y -= childHeight - buttonHeight;
        }
        break;
      case PullDownMenuPosition.under:
        y + buttonHeight + childHeight > screen.bottom - padding.bottom
            ? y -= childHeight
            : y += buttonHeight;
        break;
      case PullDownMenuPosition.above:
        y - buttonHeight > screen.top + padding.top
            ? y -= childHeight
            : y += buttonHeight;
        break;
      case PullDownMenuPosition.automatic:
        y > screen.height / 2 ? y -= childHeight : y += buttonHeight;
    }

    return y;
  }

  static double fitX(
    double wantedX,
    Rect screen,
    double childWidth,
    EdgeInsets padding,
  ) {
    final fitLeft = screen.left + _kMenuScreenPadding + padding.left;
    final fitRight = screen.right - _kMenuScreenPadding - padding.right;

    if (wantedX < fitLeft) {
      return fitLeft;
    } else if (wantedX + childWidth > fitRight) {
      return fitRight - childWidth;
    }

    return wantedX;
  }
}
