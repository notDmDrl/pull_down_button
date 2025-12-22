part of 'route.dart';

/// Minimum space from horizontal screen edges for the pull-down menu to be
/// rendered from.
const double _kMenuScreenPadding = 8;

/// Calculates the menu's horizontal position using smooth interpolation
/// based on the button's position relative to the screen center.
///
/// Instead of discrete left/center/right states, this provides a gradual
/// transition as the button moves across the screen.
///
/// - When button is at exact center: menu is centered on button
/// - When button is at left edge: menu's left edge aligns with button's left
/// - When button is at right edge: menu's right edge aligns with button's right
/// - In between: smooth interpolation between these states
double _calculateSmoothX(
  Size screenSize,
  Rect buttonRect,
  double menuWidth,
  double menuOffset,
) {
  final screenWidth = screenSize.width;
  final buttonCenterX = buttonRect.center.dx;

  // Calculate how far the button center is from the screen center
  // normalized to range [-1, 1] where:
  // -1 = left edge, 0 = center, 1 = right edge
  final normalizedPosition =
      (buttonCenterX - screenWidth / 2) / (screenWidth / 2);

  // Clamp to ensure we stay within bounds
  final clampedPosition = normalizedPosition.clamp(-1.0, 1.0);

  // Calculate the three reference x positions:
  // 1. Left-aligned: menu starts at button's left edge
  final leftAlignedX = buttonRect.left - menuOffset;

  // 2. Center-aligned: menu is centered on button
  final centerAlignedX = buttonRect.center.dx - menuWidth / 2;

  // 3. Right-aligned: menu ends at button's right edge
  final rightAlignedX = buttonRect.right - menuWidth + menuOffset;

  // Interpolate between positions based on button's horizontal position
  // Use a smooth curve for more natural feel
  if (clampedPosition <= 0) {
    // Button is in left half of screen: interpolate between left and center
    // When clampedPosition = -1 (left edge): use leftAlignedX
    // When clampedPosition = 0 (center): use centerAlignedX
    final t = clampedPosition + 1; // Convert from [-1, 0] to [0, 1]
    return _smoothLerp(leftAlignedX, centerAlignedX, t);
  } else {
    // Button is in right half of screen: interpolate between center and right
    // When clampedPosition = 0 (center): use centerAlignedX
    // When clampedPosition = 1 (right edge): use rightAlignedX
    return _smoothLerp(centerAlignedX, rightAlignedX, clampedPosition);
  }
}

/// Performs a smooth interpolation using an ease-in-out curve.
double _smoothLerp(double a, double b, double t) {
  // Apply ease-in-out curve for smoother transitions
  // This creates a more natural feel compared to linear interpolation
  final smoothT = t * t * (3 - 2 * t); // Smoothstep function
  return a + (b - a) * smoothT;
}

/// Positioning and size of the menu on the screen.
@immutable
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  const _PopupMenuRouteLayout({
    required this.padding,
    required this.avoidBounds,
    required this.buttonRect,
    required this.menuPosition,
    required this.menuOffset,
    required this.menuSpacing,
  });

  final EdgeInsets padding;
  final Set<Rect> avoidBounds;
  final Rect buttonRect;
  final PullDownMenuPosition menuPosition;
  final double menuOffset;
  final double menuSpacing;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final biggest = constraints.biggest;

    final constraintsHeight = biggest.height;

    final check = buttonRect.center.dy >= constraintsHeight / 2;

    final height = switch (menuPosition) {
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
    final childWidth = childSize.width;

    // Calculate the menu's x position using smooth interpolation
    // instead of discrete left/center/right states
    final x = _calculateSmoothX(size, buttonRect, childWidth, menuOffset);

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
      menuSpacing,
    );

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) =>
      padding != oldDelegate.padding ||
      !setEquals(avoidBounds, oldDelegate.avoidBounds) ||
      buttonRect != oldDelegate.buttonRect ||
      menuPosition != oldDelegate.menuPosition ||
      menuOffset != oldDelegate.menuOffset ||
      menuSpacing != oldDelegate.menuSpacing;
}

/// A set of utils to help calculating menu's position on screen.
@immutable
abstract class _PositionUtils {
  const _PositionUtils._();

  /// Returns closest screen for specific [point].
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

  /// Returns the `y` a top left offset point for menu's container.
  static double fitY(
    Rect buttonRect,
    Rect screen,
    double childHeight,
    EdgeInsets padding,
    PullDownMenuPosition menuPosition,
    double menuSpacing,
  ) {
    var y = buttonRect.top;
    final buttonHeight = buttonRect.height;

    final isInBottomHalf = y + buttonHeight / 2 >= screen.height / 2;

    switch (menuPosition) {
      case PullDownMenuPosition.over:
        if (isInBottomHalf) {
          y -= childHeight - buttonHeight;
        }
      case PullDownMenuPosition.automatic:
        // Native variant applies additional 5px of padding to menu if
        // [buttonHeight] is smaller than 44px.
        final basePadding =
            buttonHeight < kMinInteractiveDimensionCupertino ? 5 : 0;
        final totalSpacing = basePadding + menuSpacing;

        isInBottomHalf
            ? y -= childHeight + totalSpacing
            : y += buttonHeight + totalSpacing;
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
