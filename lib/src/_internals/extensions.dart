import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// Extension for [Rect] related calculations.
@internal
extension RectExtension on BuildContext {
  /// Shorthand for `context.findRenderObject()! as RenderBox`
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
  ///
  /// The [mediaQueryContext] parameter can be provided to use a different
  /// context for MediaQuery lookups. This is useful when the button's
  /// context has incomplete MediaQuery data (e.g., Flutter 3.35.x nav bar
  /// bug where MediaQueryData only contains textScaler).
  Rect getRect({RenderObject? ancestor, BuildContext? mediaQueryContext}) {
    final renderBoxContainer = currentRenderBox;
    final queryContext = mediaQueryContext ?? this;
    final queryData = MediaQuery.of(queryContext);
    final size = queryData.size;

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
Rect _normalizeLargeRect(Rect rect, Size size, EdgeInsets padding) {
  const minimumAllowedSize = kMinInteractiveDimensionCupertino * 2;

  final topIsNegative = rect.top.isNegative;
  final height = size.height;
  final rectBottom = rect.bottom;

  double? top;
  double? bottom;

  if (topIsNegative && rectBottom > height) {
    top = height * 0.65;
    bottom = height * 0.75;
  } else if (topIsNegative && rectBottom < height) {
    final diff = height - rectBottom - padding.bottom;

    if (diff < minimumAllowedSize) {
      top = rectBottom;
      bottom = height - padding.bottom;
    }
  } else {
    final diff = rect.top - padding.top;

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
