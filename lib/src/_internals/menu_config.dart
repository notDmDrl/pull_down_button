import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'content_size_category.dart';

/// Used to configure how the [PullDownMenuActionsRow] shows its
/// [PullDownMenuItem]'s and their maximum count.
///
/// See also:
///
/// * preferredElementSize:
///   https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize
@internal
enum ElementSize {
  /// Compact layout, icon-only representation.
  ///
  /// Maximum 4 items.
  small,

  /// Medium layout, icon and title vertically aligned.
  ///
  /// Maximum 3 items.
  medium,

  /// Large layout, title and icon horizontally aligned.
  large;

  /// Minimum allowed height for [ElementSize.large] and [ElementSize.small].
  ///
  /// [ElementSize.large] should use returned value as a `minHeight` for its
  /// constraints. [ElementSize.small] should use returned value as a fixed
  /// height.
  ///
  /// Values were resolved based on a direct comparison with the native variant
  /// for each [ContentSizeCategory].
  ///
  /// Base is 44px ([kMinInteractiveDimensionCupertino]).
  static double resolveLarge(BuildContext context) {
    final level = ContentSizeCategory.of(context);

    switch (level) {
      case ContentSizeCategory.extraSmall:
        return 38;
      case ContentSizeCategory.small:
        return 40;
      case ContentSizeCategory.medium:
        return 42;
      case ContentSizeCategory.large:
        return 44;
      case ContentSizeCategory.extraLarge:
        return 48;
      case ContentSizeCategory.extraExtraLarge:
        return 52;
      case ContentSizeCategory.extraExtraExtraLarge:
        return 58;
      case ContentSizeCategory.accessibilityMedium:
        return 68;
      case ContentSizeCategory.accessibilityLarge:
        return 80;
      case ContentSizeCategory.accessibilityExtraLarge:
        return 96;
      case ContentSizeCategory.accessibilityExtraExtraLarge:
        return 112;
      case ContentSizeCategory.accessibilityExtraExtraExtraLarge:
        return 124;
    }
  }

  /// Minimum allowed height for [ElementSize.large] with a subtitle.
  ///
  /// [ElementSize.large] should use returned value as a `minHeight` for its
  /// constraints.
  ///
  /// Values were eyeballed based on a direct comparison with the native variant
  /// for each [ContentSizeCategory].
  ///
  /// Returned value is always 1.36 times bigger than [resolveLarge].
  ///
  /// Base is 64px.
  static double resolveLargeWithSubtitle(BuildContext context) =>
      (resolveLarge(context) * 1.45).ceilToDouble();

  /// Minimum allowed height for [ElementSize.medium].
  ///
  /// [ElementSize.medium] should use returned value as a fixed height.
  ///
  /// Values were eyeballed based on a direct comparison with the native variant
  /// for each [ContentSizeCategory].
  ///
  /// Returned value is always 1.36 times bigger than [resolveLarge].
  ///
  /// Base is 60px.
  static double resolveMedium(BuildContext context) =>
      (resolveLarge(context) * 1.36).ceilToDouble();
}

/// An inherited widget used to indicate current [ElementSize] configuration.
///
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

/// An inherited widget used to provide menu configuration to all its descendant
/// widgets,
///
/// Is internally used by [PullDownButton], [showPullDownMenu], or
/// [PullDownMenu].
@immutable
@internal
class MenuConfig extends InheritedWidget {
  /// Creates [MenuConfig].
  const MenuConfig({
    super.key,
    required super.child,
    required this.hasLeading,
  });

  /// Whether the pull-down menu has any [PullDownMenuItem]s with leading
  /// widget such as chevron.
  final bool hasLeading;

  /// Used to determine if the menu has any items with a leading widget.
  static bool menuHasLeading(List<PullDownMenuEntry> items) =>
      items.whereType<PullDownMenuItem>().any(
            (element) => element.selected != null,
          );

  /// Returns a [bool] value indicating whether menu has any
  /// [PullDownMenuItem]s  with leading widget from the closest [MenuConfig]
  /// ancestor.
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuConfig>()!.hasLeading;

  @override
  bool updateShouldNotify(MenuConfig oldWidget) =>
      hasLeading != oldWidget.hasLeading;
}
