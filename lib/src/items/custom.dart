import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/button.dart';
import '../_internals/content_size_category.dart';
import '../_internals/menu_config.dart';

/// A customizable pull-down menu entry that accepts a custom child widget
/// and optional tap callback.
///
/// This widget provides the flexibility to pass any custom child widget while
/// maintaining the same tap behavior as [PullDownMenuItem].
///
/// To create a non-tappable custom entry, simply omit the [onTap] parameter.
@immutable
class PullDownMenuCustom extends StatelessWidget implements PullDownMenuEntry {
  /// Creates a custom entry for a pull-down menu.
  ///
  /// The [child] parameter is required and represents the custom widget to
  /// display.
  ///
  /// The [onTap] parameter is optional. When provided, the entry becomes
  /// tappable with the specified [tapHandler] behavior.
  const PullDownMenuCustom({
    super.key,
    required this.child,
    this.onTap,
    this.tapHandler = PullDownMenuItem.defaultTapHandler,
    this.enabled = true,
    this.itemTheme,
    this.padding,
    this.constraints,
    this.alignment,
  });

  /// The custom widget to display in the menu entry.
  final Widget child;

  /// The action this item represents.
  ///
  /// If null, the item will not be tappable.
  ///
  /// To specify how this action is resolved, [tapHandler] is used.
  ///
  /// See also:
  ///
  /// * [PullDownMenuItem.defaultTapHandler], a default tap handler.
  /// * [PullDownMenuItem.noPopTapHandler], a tap handler that immediately
  ///   calls [onTap] without popping the menu.
  /// * [PullDownMenuItem.delayedTapHandler], a tap handler that pops the menu,
  ///   waits for an animation to end and calls the [onTap].
  final VoidCallback? onTap;

  /// Handler that provides this item's [BuildContext] as well as [onTap] to
  /// resolve how [onTap] callback is used.
  ///
  /// Defaults to [PullDownMenuItem.defaultTapHandler].
  final PullDownMenuItemTapHandler tapHandler;

  /// Whether the user is permitted to tap this item.
  ///
  /// Defaults to true. If this is false, the item will not react to touches.
  final bool enabled;

  /// Theme of this [PullDownMenuCustom].
  ///
  /// If this property is null, then [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuItemTheme.defaults] are
  /// used.
  final PullDownMenuItemTheme? itemTheme;

  /// The padding for the [child].
  ///
  /// If null, defaults to `EdgeInsets.symmetric(horizontal: 16, vertical: 11)`.
  final EdgeInsetsGeometry? padding;

  /// The constraints for the container.
  ///
  /// If null, uses a minimum height based on the default large element size.
  final BoxConstraints? constraints;

  /// How to align the [child] within the container.
  ///
  /// If null, defaults to [AlignmentDirectional.centerStart].
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuItemTheme.resolve(
      context,
      itemTheme: itemTheme,
    );

    final isEnabled = enabled && onTap != null;

    final resolvedPadding = padding ??
        const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 11,
        );

    final resolvedConstraints = constraints ??
        BoxConstraints(
          minHeight: ElementSize.resolveLarge(context),
        );

    final resolvedAlignment = alignment ?? AlignmentDirectional.centerStart;

    final container = AnimatedMenuContainer(
      padding: resolvedPadding,
      constraints: resolvedConstraints,
      alignment: resolvedAlignment,
      child: child,
    );

    // If onTap is null, return the container without tap handling
    if (onTap == null) {
      return container;
    }

    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        button: true,
        child: MenuActionButton(
          onTap: isEnabled ? () => tapHandler(context, onTap) : null,
          pressedColor: theme.onPressedBackgroundColor!,
          hoverColor: theme.onHoverBackgroundColor!,
          child: container,
        ),
      ),
    );
  }
}
