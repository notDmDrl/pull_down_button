import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/animation.dart';
import '../_internals/button.dart';
import '../_internals/content_size_category.dart';
import '../_internals/item_layout.dart';
import '../_internals/menu_config.dart';
import '../_internals/route.dart';

const double _kItemVerticalPadding = 11;
const double _kItemStartPadding = 16;
const double _kItemWithLeadingStartPadding = 9;
const double _kItemEndPadding = 16;
// This value is present in layout guidelines but is not used anywhere right
// now. Have it here already to not forget about it later.
// const double _kItemWithTrailingEndPadding = 6;

EdgeInsetsDirectional _itemPadding({required bool hasLeading}) =>
    EdgeInsetsDirectional.only(
      start: hasLeading ? _kItemWithLeadingStartPadding : _kItemStartPadding,
      end: _kItemEndPadding,
      top: _kItemVerticalPadding,
      bottom: _kItemVerticalPadding,
    );

const EdgeInsetsGeometry _kIconActionPadding = EdgeInsetsDirectional.all(10);

/// Signature used by [PullDownMenuItem] to resolve how [onTap] callback is
/// used.
///
/// Default behavior is to pop the menu and call the [onTap].
///
/// Used by [PullDownMenuItem.tapHandler] and [PullDownMenuHeader.tapHandler].
///
/// See also:
///
/// * [PullDownMenuItem.defaultTapHandler], a default tap handler.
/// * [PullDownMenuItem.noPopTapHandler], a tap handler that immediately calls
/// [onTap] without popping the menu.
/// * [PullDownMenuItem.delayedTapHandler], a tap handler that pops the menu,
/// waits for an animation to end and calls the [onTap].
typedef PullDownMenuItemTapHandler = void Function(
  BuildContext context,
  VoidCallback? onTap,
);

/// An item in a cupertino style pull-down menu.
///
/// To show a checkmark next to the pull-down menu item (an item with a
/// selection state), use [PullDownMenuItem.selectable].
@immutable
class PullDownMenuItem extends StatelessWidget implements PullDownMenuEntry {
  /// Creates an item for a pull-down menu.
  ///
  /// By default, the item is [enabled].
  const PullDownMenuItem({
    super.key,
    required this.onTap,
    this.tapHandler = defaultTapHandler,
    this.enabled = true,
    required this.title,
    this.subtitle,
    this.itemTheme,
    this.icon,
    this.iconColor,
    this.iconWidget,
    this.isDestructive = false,
  })  : selected = null,
        assert(
          icon == null || iconWidget == null,
          'Please provide either icon or iconWidget',
        );

  /// Creates a selectable item for a pull-down menu.
  ///
  /// By default, the item is [enabled].
  const PullDownMenuItem.selectable({
    super.key,
    required this.onTap,
    this.tapHandler = defaultTapHandler,
    this.enabled = true,
    required this.title,
    this.subtitle,
    this.itemTheme,
    this.icon,
    this.iconColor,
    this.iconWidget,
    this.isDestructive = false,
    this.selected = false,
  }) : assert(
          icon == null || iconWidget == null,
          'Please provide either icon or iconWidget',
        );

  /// The action this item represents.
  ///
  /// To specify how this action is resolved, [tapHandler] is used.
  ///
  /// See also:
  ///
  /// * [defaultTapHandler], a default tap handler.
  /// * [noPopTapHandler], a tap handler that immediately calls [onTap] without
  /// popping the menu.
  /// * [delayedTapHandler], a tap handler that pops the menu, waits for an
  /// animation to end and calls the [onTap].
  final VoidCallback? onTap;

  /// Handler that provides this item's [BuildContext] as well as [onTap] to
  /// resolve how [onTap] callback is used.
  final PullDownMenuItemTapHandler tapHandler;

  /// Whether the user is permitted to tap this item.
  ///
  /// Defaults to true. If this is false, the item will not react to touches,
  /// and item text styles and icon colors will be updated with a lower opacity
  /// to indicate a disabled state.
  final bool enabled;

  /// Title of this [PullDownMenuItem].
  final String title;

  /// Subtitle of this [PullDownMenuItem].
  final String? subtitle;

  /// Theme of this [PullDownMenuItem].
  ///
  /// If this property is null, then [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuItemTheme.defaults] are
  /// used.
  final PullDownMenuItemTheme? itemTheme;

  /// Icon of this [PullDownMenuItem].
  ///
  /// If the [iconWidget] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow], either this or [iconWidget] are
  /// required.
  final IconData? icon;

  /// Color for this [PullDownMenuItem]'s [icon].
  ///
  /// If not provided, `textStyle.color` from [itemTheme] will be used.
  ///
  /// If [PullDownMenuItem] `isDestructive`, then [iconColor] will be ignored.
  final Color? iconColor;

  /// Custom icon widget of this [PullDownMenuItem].
  ///
  /// If the [icon] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow], either this or [icon] is required.
  final Widget? iconWidget;

  /// Whether this item represents destructive action;
  ///
  /// If this is true, then `destructiveColor` from [itemTheme] is used.
  final bool isDestructive;

  /// Whether to display a checkmark next to the menu item.
  ///
  /// Defaults to `null`.
  ///
  /// If [PullDownMenuItem] is used inside [PullDownMenuActionsRow] this
  /// property will be ignored, and a checkmark will not be shown.
  ///
  /// When true, an [PullDownMenuItemTheme.checkmark] checkmark is displayed
  /// (from [itemTheme]).
  ///
  /// If itemTheme is null, then defaults from [PullDownMenuItemTheme.defaults]
  /// are used.
  final bool? selected;

  /// Default tap handler for [PullDownMenuItem].
  ///
  /// The behavior is to pop the menu and then call the [onTap].
  static void defaultTapHandler(BuildContext context, VoidCallback? onTap) {
    // If the menu was opened from [PullDownButton] or [showPullDownMenu] - pop
    // route.
    if (ModalRoute.of(context) is PullDownMenuRoute) {
      Navigator.pop(context, onTap);
    } else {
      noPopTapHandler(context, onTap);
    }
  }

  /// An additional, pre-made tap handler for [PullDownMenuItem].
  ///
  /// The behavior is to pop the menu, wait until the animation ends, and call
  /// the [onTap].
  ///
  /// This might be useful if [onTap] results in action involved with changing
  /// navigation stack (like opening a new screen or showing dialog) so there
  /// is a smoother transition between the pull-down menu and said navigation
  /// stack changing action.
  static void delayedTapHandler(
    BuildContext context,
    VoidCallback? onTap,
  ) {
    // If the menu was opened from [PullDownButton] or [showPullDownMenu] - pop
    // route.
    if (ModalRoute.of(context) is PullDownMenuRoute) {
      Future<void> future() async {
        await Future<void>.delayed(AnimationUtils.kMenuDuration);

        onTap?.call();
      }

      Navigator.pop(context, future);
    } else {
      noPopTapHandler(context, onTap);
    }
  }

  /// An additional, pre-made tap handler for [PullDownMenuItem].
  ///
  /// The behavior is to call the [onTap] without popping the menu.
  static void noPopTapHandler(
    BuildContext _,
    VoidCallback? onTap,
  ) =>
      onTap?.call();

  /// Asserts that an item with sizes [ElementSize.small] or
  /// [ElementSize.medium] has an [icon] or a [iconWidget].
  @protected
  bool _debugActionRowHasIcon(ElementSize size) {
    assert(
      () {
        switch (size) {
          case ElementSize.small:
          case ElementSize.medium:
            return icon != null || iconWidget != null;
          case ElementSize.large:
            return true;
        }
      }(),
      'Either icon or iconWidget should be provided',
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = ActionsRowSizeConfig.of(context);

    assert(_debugActionRowHasIcon(size), '');

    final theme = PullDownMenuItemTheme.resolve(
      context,
      itemTheme: itemTheme,
    );

    final Widget child;

    final isEnabled = enabled && onTap != null;

    switch (size) {
      case ElementSize.small:
        child = _SmallItem(
          icon: iconWidget ?? Icon(icon),
          destructiveColor: theme.destructiveColor!,
          onHoverColor: theme.onHoverTextColor!,
          color: iconColor ?? theme.iconActionTextStyle!.color!,
          enabled: isEnabled,
          destructive: isDestructive,
        );
        break;
      case ElementSize.medium:
        child = _MediumItem(
          icon: iconWidget ?? Icon(icon),
          destructiveColor: theme.destructiveColor!,
          onHoverColor: theme.onHoverTextColor!,
          iconColor: iconColor,
          enabled: isEnabled,
          destructive: isDestructive,
          title: title,
          titleStyle: theme.iconActionTextStyle!,
        );
        break;
      case ElementSize.large:
        // Don't do unnecessary checks from inherited widget if [selected] is
        // not null.
        final hasLeading = selected != null || MenuConfig.of(context);

        child = _LargeItem(
          icon: icon,
          iconWidget: iconWidget,
          destructiveColor: theme.destructiveColor!,
          onHoverColor: theme.onHoverTextColor!,
          iconColor: iconColor,
          enabled: isEnabled,
          destructive: isDestructive,
          leading: hasLeading
              ? _CheckmarkIcon(
                  selected: selected ?? false,
                  checkmark: theme.checkmark!,
                )
              : null,
          title: title,
          titleStyle: theme.textStyle!,
          subtitle: subtitle,
          subtitleStyle: theme.subtitleStyle!,
        );
        break;
    }

    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        button: true,
        selected: selected,
        child: MenuActionButton(
          onTap: enabled ? () => tapHandler(context, onTap) : null,
          pressedColor: theme.onPressedBackgroundColor!,
          hoverColor: theme.onHoverBackgroundColor!,
          child: child,
        ),
      ),
    );
  }
}

/// An a [ElementSize.small] menu item.
@immutable
class _SmallItem extends StatelessWidget {
  const _SmallItem({
    required this.icon,
    required this.destructiveColor,
    required this.onHoverColor,
    required this.color,
    required this.enabled,
    required this.destructive,
  });

  final Widget icon;
  final Color destructiveColor;
  final Color onHoverColor;
  final Color color;
  final bool enabled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final isHovered = MenuActionButtonState.of(context);

    var resolvedColor = color;
    if (destructive) {
      resolvedColor = destructiveColor;
    } else if (isHovered) {
      resolvedColor = onHoverColor;
    }

    if (!enabled) {
      resolvedColor = resolvedColor.withOpacity(
        PullDownMenuItemTheme.disabledOpacity(context),
      );
    }

    return Center(
      child: IconBox(
        color: resolvedColor,
        child: icon,
      ),
    );
  }
}

/// An a [ElementSize.medium] menu item.
@immutable
class _MediumItem extends StatelessWidget {
  /// Creates [_MediumItem].
  const _MediumItem({
    required this.icon,
    required this.destructiveColor,
    required this.onHoverColor,
    required this.iconColor,
    required this.enabled,
    required this.destructive,
    required this.title,
    required this.titleStyle,
  });

  final Widget icon;
  final Color destructiveColor;
  final Color onHoverColor;
  final Color? iconColor;
  final bool enabled;
  final bool destructive;
  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    final isHovered = MenuActionButtonState.of(context);

    var resolvedColor = iconColor ?? titleStyle.color!;
    var resolvedStyle = titleStyle;
    if (destructive) {
      resolvedColor = destructiveColor;
      resolvedStyle = resolvedStyle.copyWith(color: destructiveColor);
    } else if (isHovered) {
      resolvedColor = onHoverColor;
      resolvedStyle = resolvedStyle.copyWith(color: onHoverColor);
    }

    if (!enabled) {
      final disabledOpacity = PullDownMenuItemTheme.disabledOpacity(context);

      resolvedColor = resolvedColor.withOpacity(disabledOpacity);
      resolvedStyle = resolvedStyle.copyWith(
        color: resolvedStyle.color!.withOpacity(disabledOpacity),
      );
    }

    return Padding(
      padding: _kIconActionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBox.small(
            color: resolvedColor,
            child: icon,
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: resolvedStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ],
      ),
    );
  }
}

/// An a [ElementSize.large] menu item.
@immutable
class _LargeItem extends StatelessWidget {
  /// Creates [_LargeItem].
  const _LargeItem({
    required this.icon,
    required this.iconWidget,
    required this.destructiveColor,
    required this.onHoverColor,
    required this.iconColor,
    required this.enabled,
    required this.destructive,
    required this.leading,
    required this.title,
    required this.titleStyle,
    required this.subtitle,
    required this.subtitleStyle,
  });

  final IconData? icon;
  final Widget? iconWidget;
  final Color destructiveColor;
  final Color onHoverColor;
  final Color? iconColor;
  final bool enabled;
  final bool destructive;
  final Widget? leading;
  final String title;
  final TextStyle titleStyle;
  final String? subtitle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final isHovered = MenuActionButtonState.of(context);

    final minHeight = subtitle != null
        ? ElementSize.resolveLargeWithSubtitle(context)
        : ElementSize.resolveLarge(context);

    final isInAccessibilityMode = TextUtils.isInAccessibilityMode(context);
    final maxLines = isInAccessibilityMode ? 3 : 2;

    var resolvedColor = iconColor ?? titleStyle.color!;
    var resolvedStyle = titleStyle;
    var resolvedSubtitleStyle = subtitleStyle;
    if (destructive) {
      resolvedColor = destructiveColor;
      resolvedStyle = resolvedStyle.copyWith(color: destructiveColor);
    } else if (isHovered) {
      resolvedColor = onHoverColor;
      resolvedStyle = resolvedStyle.copyWith(color: onHoverColor);
    }

    if (!enabled) {
      final disabledOpacity = PullDownMenuItemTheme.disabledOpacity(context);

      resolvedColor = resolvedColor.withOpacity(disabledOpacity);
      resolvedStyle = resolvedStyle.copyWith(
        color: resolvedStyle.color!.withOpacity(disabledOpacity),
      );
      resolvedSubtitleStyle = resolvedSubtitleStyle.copyWith(
        color: resolvedSubtitleStyle.color!.withOpacity(disabledOpacity),
      );
    }

    Widget body = Text(
      title,
      style: resolvedStyle,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      maxLines: maxLines,
    );

    if (subtitle != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          body,
          Text(
            subtitle!,
            style: resolvedSubtitleStyle,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: maxLines,
          ),
        ],
      );
    }

    final hasIcon =
        !isInAccessibilityMode && (icon != null || iconWidget != null);
    final hasLeading = leading != null;

    if (hasLeading || hasIcon) {
      body = Row(
        children: [
          if (hasLeading)
            DefaultTextStyle(
              style: TextStyle(color: resolvedStyle.color),
              child: leading!,
            ),
          Expanded(child: body),
          if (hasIcon)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: IconBox(
                color: resolvedColor,
                child: iconWidget ?? Icon(icon),
              ),
            ),
        ],
      );
    }

    return AnimatedMenuContainer(
      alignment: AlignmentDirectional.centerStart,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: _itemPadding(hasLeading: hasLeading),
      child: body,
    );
  }
}

/// A checkmark widget.
///
/// Replicated the [Icon] logic here with required parameters as seen in
/// iOS 16 Guidelines.
@immutable
class _CheckmarkIcon extends StatelessWidget {
  /// Creates [_CheckmarkIcon].
  const _CheckmarkIcon({
    required this.selected,
    required this.checkmark,
  });

  final IconData checkmark;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return const LeadingWidgetBox(
        height: 22,
      );
    }

    return LeadingWidgetBox(
      height: 22,
      child: Center(
        child: Text.rich(
          TextSpan(
            text: String.fromCharCode(checkmark.codePoint),
            style: TextStyle(
              fontSize: 17,
              height: 22 / 17,
              fontWeight: FontWeight.w600,
              fontFamily: checkmark.fontFamily,
              package: checkmark.fontPackage,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
