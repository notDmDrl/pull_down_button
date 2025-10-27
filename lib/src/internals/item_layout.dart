import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'animation.dart';

/// An [AnimatedContainer] with predefined [duration] and [curve].
///
/// Is used to animate a container on text scale factor change.
final class AnimatedMenuContainer extends AnimatedContainer {
  /// Creates [AnimatedMenuContainer].
  AnimatedMenuContainer({
    super.key,
    super.constraints,
    super.alignment,
    super.padding,
    required super.child,
  }) : super(
         duration: AnimationUtils.kMenuDuration,
         curve: AnimationUtils.kOnSizeChangeCurve,
       );
}

/// A widget used to create a leading widget for pull-down menu items while
/// complying with layouts defined in the Apple Design Resources Sketch file.
///
/// See also:
///
/// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
@immutable
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
/// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
@immutable
class IconBox extends StatelessWidget {
  /// Creates [IconBox].
  const IconBox({
    super.key,
    this.color,
    required this.child,
  }) : _config = const (height: 22, width: 20, size: 22);

  /// Creates [IconBox.small].
  const IconBox.small({
    super.key,
    this.color,
    required this.child,
  }) : _config = const (height: 18, width: 18, size: 17);

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of icon widget.
  final Color? color;

  /// The icons dimensions.
  final ({double height, double width, double size}) _config;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return _TextScaledSizedBox(
      height: _config.height,
      width: _config.width,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: _config.size * textScaleFactor,
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
/// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
@immutable
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

  /// The size of icon at the default text scale factor.
  static const double _kIconSize = 17;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return _TextScaledSizedBox(
      height: _kSize,
      width: _kSize,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: _kIconSize * textScaleFactor,
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
    final double textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

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
  ) => renderObject.additionalConstraints = _additionalConstraints(context);
}
