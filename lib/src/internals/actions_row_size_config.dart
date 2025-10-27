/// @docImport '/pull_down_button.dart';
library;

import 'package:flutter/material.dart';

import 'element_size.dart';

/// An inherited widget used to indicate current [ElementSize] configuration.
///
/// Is internally used by [PullDownMenuActionsRow] to provide [ElementSize] to
/// all descendant [PullDownMenuItem]s.
@immutable
class ActionsRowSizeConfig extends InheritedWidget {
  /// Creates [ActionsRowSizeConfig].
  const ActionsRowSizeConfig({
    super.key,
    required super.child,
    required this.size,
  });

  /// The display type of actions in [PullDownMenuActionsRow].
  final ElementSize size;

  /// Returns the current [ElementSize] from [PullDownMenuActionsRow]
  /// configuration from the closest [ActionsRowSizeConfig] ancestor.
  ///
  /// If there is no ancestor, it returns [ElementSize.large].
  static ElementSize of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ActionsRowSizeConfig>()
          ?.size ??
      ElementSize.large;

  @override
  bool updateShouldNotify(ActionsRowSizeConfig oldWidget) =>
      size != oldWidget.size;
}
