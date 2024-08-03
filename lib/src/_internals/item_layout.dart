import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

/// A widget used to create a leading widget for pull-down menu items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch file:
///   https://developer.apple.com/design/resources/
@immutable
@internal
class LeadingWidgetBox extends StatelessWidget {
  /// Creates [LeadingWidgetBox].
  const LeadingWidgetBox({
    super.key,
    this.child,
    this.height,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  /// The width of [LeadingWidgetBox].
  static const double _kLeadingWidth = 20;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          end: 4,
        ),
        child: _TextScaledSizedBox(
          width: _kLeadingWidth,
          height: height,
          child: child,
        ),
      );
}

/// A widget used to create a icon widget for pull-down menu items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch file:
///   https://developer.apple.com/design/resources/
@immutable
@internal
class IconBox extends StatelessWidget {
  /// Creates [IconBox].
  const IconBox({
    super.key,
    this.color,
    required this.child,
  }) : _isSmall = false;

  /// Creates [IconBox.small].
  const IconBox.small({
    super.key,
    this.color,
    required this.child,
  }) : _isSmall = true;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of icon widget.
  final Color? color;

  final bool _isSmall;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    if (_isSmall) {
      return _TextScaledSizedBox(
        height: 18,
        width: 18,
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(
              color: color,
              size: 17 * textScaleFactor,
            ),
            child: child,
          ),
        ),
      );
    }

    return _TextScaledSizedBox(
      height: 22,
      width: 20,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: 22 * textScaleFactor,
        ),
        child: child,
      ),
    );
  }
}

/// A widget used to create a icon widget for pull-down header items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch file:
///   https://developer.apple.com/design/resources/
@immutable
@internal
class IconActionBox extends StatelessWidget {
  /// Creates [IconActionBox].
  const IconActionBox({
    super.key,
    required this.child,
    required this.color,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of icon.
  final Color? color;

  /// The size of [IconActionBox].
  static const double _kSize = 28;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return _TextScaledSizedBox(
      height: _kSize,
      width: _kSize,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: 17 * textScaleFactor,
        ),
        child: child,
      ),
    );
  }
}

/// Rework of [SizedBox] with text scale factor applied internally.
@immutable
class _TextScaledSizedBox extends SingleChildRenderObjectWidget {
  /// Creates [_TextScaledSizedBox].
  const _TextScaledSizedBox({
    this.width,
    this.height,
    super.child,
  });

  /// If non-null, requires the child to have exactly this width.
  final double? width;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  BoxConstraints _additionalConstraints(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return BoxConstraints.tightFor(
      width: width != null ? width! * textScaleFactor : null,
      height: height != null ? height! * textScaleFactor : null,
    );
  }

  @override
  RenderConstrainedBox createRenderObject(BuildContext context) =>
      RenderConstrainedBox(
        additionalConstraints: _additionalConstraints(context),
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderConstrainedBox renderObject,
  ) =>
      renderObject.additionalConstraints = _additionalConstraints(context);
}
