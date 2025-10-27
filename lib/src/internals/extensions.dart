import 'package:flutter/cupertino.dart';

/// Extension for [Rect] related calculations.
extension RectExtension on BuildContext {
  /// Shorthand for `context.findRenderObject()! as RenderBox`.
  RenderBox get currentRenderBox => findRenderObject()! as RenderBox;

  /// Given a [BuildContext], return the [Rect] of the corresponding
  /// [RenderBox]'s paintBounds in global coordinates.
  ///
  /// To specify a different [RenderBox] as the ancestor, provide the [ancestor]
  /// parameter. This is usually used to specify a Navigator's [Overlay] as the
  /// ancestor coordinate space.
  ///
  /// If no [ancestor] is provided, the returned rect is in the coordinate space
  /// of the root [RenderObject] of the application, or in global coordinates.
  ///
  /// If [Rect]'s height is bigger than the screen size, additionally normalize
  /// [Rect] to help mitigate possible layout issues.
  Rect getRect({RenderObject? ancestor}) {
    final RenderBox renderBoxContainer = currentRenderBox;
    final MediaQueryData queryData = MediaQuery.of(this);
    final Size size = queryData.size;

    final rect = Rect.fromPoints(
      renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.topLeft,
        ancestor: ancestor,
      ),
      renderBoxContainer.localToGlobal(
        renderBoxContainer.paintBounds.bottomRight,
        ancestor: ancestor,
      ),
    );

    if (rect.size.height > size.height) {
      return _normalizeLargeRect(rect, size, queryData.padding);
    }

    return rect;
  }
}

/// Apply some additional adjustments on [Rect] from [RectExtension.getRect] if
/// [rect] is bigger than [size].
Rect _normalizeLargeRect(
  Rect rect,
  Size size,
  EdgeInsets padding,
) {
  const double minimumAllowedSize = kMinInteractiveDimensionCupertino * 2;

  final bool topIsNegative = rect.top.isNegative;
  final double height = size.height;
  final double rectBottom = rect.bottom;

  double? top;
  double? bottom;

  if (topIsNegative && rectBottom > height) {
    top = height * 0.65;
    bottom = height * 0.75;
  } else if (topIsNegative && rectBottom < height) {
    final double diff = height - rectBottom - padding.bottom;

    if (diff < minimumAllowedSize) {
      top = rectBottom;
      bottom = height - padding.bottom;
    }
  } else {
    final double diff = rect.top - padding.top;

    if (diff < minimumAllowedSize) {
      top = padding.top;
      bottom = rect.top;
    }
  }

  return Rect.fromLTRB(
    rect.left,
    top ?? rect.top,
    rect.right,
    bottom ?? rect.bottom,
  );
}
