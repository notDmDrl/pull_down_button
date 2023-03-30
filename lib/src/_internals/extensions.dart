import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// Extension used to get current [RenderBox] for the widget.
@internal
extension FindRenderBoxExtension on BuildContext {
  /// Shorthand for `context.findRenderObject()! as RenderBox`
  RenderBox get currentRenderBox => findRenderObject()! as RenderBox;
}
