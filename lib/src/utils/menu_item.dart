import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs, comment_references

/// Copy of [_MenuItem] from [PopupMenuButton] implementation since it's
/// private there;
@internal
@immutable
class RenderMenuItem extends SingleChildRenderObjectWidget {
  /// Copy of [_MenuItem] from [PopupMenuButton] implementation since it's
  /// private there;
  const RenderMenuItem({
    super.key,
    required this.onLayout,
    required super.child,
  });

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMenuItem(onLayout);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMenuItem renderObject,
  ) =>
      renderObject.onLayout = onLayout;
}

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      (child!.parentData! as BoxParentData).offset = Offset.zero;
    }
    onLayout(size);
  }
}
