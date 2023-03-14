import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pull_down_button/src/utils/glide_state.dart';

import '../../pull_down_button.dart';

/// Used to configure how the [PullDownMenuActionsRow] show its
/// [PullDownMenuItem]'s and their maximum count;
///
/// See also:
///
/// * preferredElementSize:
///   https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize
@internal
enum ElementSize {
  /// Compact, icon only representation.
  ///
  /// Used to configure how the [PullDownMenuActionsRow] show its
  /// [PullDownMenuItem]'s and their maximum count. Maximum 4 items.
  small,

  /// Medium, icon and title vertically aligned.
  ///
  /// Used to configure how the [PullDownMenuActionsRow] show its
  /// [PullDownMenuItem]'s and their maximum count. Maximum 3 items.
  medium,

  /// Large, title and icon horizontally aligned.
  large
}

/// Is internally used by [PullDownMenuActionsRow] to provide [ElementSize] to
/// all descendant [PullDownMenuItem]s.
@immutable
@internal
class ActionsRowSizeConfig extends InheritedWidget {
  /// Creates [ActionsRowSizeConfig].
  const ActionsRowSizeConfig({
    super.key,
    required super.child,
    required this.size,
  });

  /// The display type of actions in [PullDownMenuActionsRow].
  final ElementSize size;

  /// The closest instance of this class that encloses the given
  /// context.
  @internal
  static ElementSize of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ActionsRowSizeConfig>()
          ?.size ??
      ElementSize.large;

  @override
  bool updateShouldNotify(ActionsRowSizeConfig oldWidget) =>
      size != oldWidget.size;
}

/// Is internally used by [PullDownButton] to provide whether the pull-down
/// menu has any [PullDownMenuItem]s with leading widget such as chevron to
/// all descendant [PullDownMenuItem]s.
@immutable
@internal
class MenuConfig extends InheritedWidget {
  /// Creates [MenuConfig].
  const MenuConfig({
    super.key,
    required super.child,
    required this.hasLeading,
    required this.glideStateNotifier,
  });

  /// Whether the pull-down menu has any [PullDownMenuItem]s with leading
  /// widget such as chevron.
  final bool hasLeading;

  ///
  // TODO(salvatore): need doc
  final ValueNotifier<MenuGlideState> glideStateNotifier;

  /// The closest instance of this class that encloses the given
  /// context.
  @internal
  static MenuConfig of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuConfig>()!;

  @override
  bool updateShouldNotify(MenuConfig oldWidget) =>
      hasLeading != oldWidget.hasLeading;
}
