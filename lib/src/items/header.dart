import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/button.dart';
import '../_internals/content_size_category.dart';
import '../_internals/item_layout.dart';
import '../_internals/menu_config.dart';

const double _kHeaderVerticalPadding = 10;
const double _kHeaderStartPadding = 16;
const double _kHeaderEndPadding = 12;

const EdgeInsetsDirectional _padding = EdgeInsetsDirectional.only(
  start: _kHeaderStartPadding,
  end: _kHeaderEndPadding,
  top: _kHeaderVerticalPadding,
  bottom: _kHeaderVerticalPadding,
);

/// The (optional) header of the pull-down menu that is usually displayed at the
/// top of the pull-down menu.
///
/// To indicate that [PullDownMenuHeader] has an action consider providing
/// [icon] or [iconWidget].
///
/// See also:
///
/// * UIDocumentProperties:
///   https://developer.apple.com/documentation/uikit/uidocumentproperties
@immutable
class PullDownMenuHeader extends StatelessWidget implements PullDownMenuEntry {
  /// Creates a header for pull-down menu.
  const PullDownMenuHeader({
    super.key,
    this.onTap,
    this.tapHandler = PullDownMenuItem.defaultTapHandler,
    required this.leading,
    required this.title,
    this.subtitle,
    this.itemTheme,
    this.icon,
    this.iconWidget,
  }) : assert(
          icon == null || iconWidget == null,
          'Please provide either icon or iconWidget',
        );

  /// The action this header represents.
  ///
  /// If [onTap] is not `null` consider providing either [icon] or [iconWidget]
  /// to indicate to user that this header has an action.
  ///
  /// To specify how this action is resolved, [tapHandler] is used.
  ///
  /// See also:
  ///
  /// * [PullDownMenuItem.defaultTapHandler], a default tap handler.
  /// * [PullDownMenuItem.noPopTapHandler], a tap handler that immediately calls
  /// [onTap] without popping the menu.
  /// * [PullDownMenuItem.delayedTapHandler], a tap handler that pops the menu,
  ///  waits for an animation to end and calls the [onTap].
  final VoidCallback? onTap;

  /// Handler that provides this item's [BuildContext] as well as [onTap] to
  /// resolve how [onTap] callback is used.
  final PullDownMenuItemTapHandler tapHandler;

  /// The leading widget of [PullDownMenuHeader].
  ///
  /// Typically an [Image] widget.
  ///
  /// By default, a [PullDownMenuHeader.leading] is in a square box with
  /// [kMinInteractiveDimensionCupertino] pixels height/width.
  final Widget leading;

  /// Title of this [PullDownMenuHeader].
  final String title;

  /// Subtitle of this [PullDownMenuHeader].
  final String? subtitle;

  /// Theme of this [PullDownMenuHeader].
  ///
  /// If this property is null, then [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] is used.
  ///
  /// If that's null, then defaults from [PullDownMenuItemTheme.defaults] are
  /// used.
  final PullDownMenuItemTheme? itemTheme;

  /// Icon of this [PullDownMenuHeader].
  ///
  /// If the [iconWidget] is used, this property must be null;
  final IconData? icon;

  /// Custom icon widget of this [PullDownMenuHeader].
  ///
  /// If the [icon] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow], either this or [icon] is required.
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuItemTheme.resolve(
      context,
      itemTheme: itemTheme,
    );

    return MergeSemantics(
      child: Semantics(
        button: onTap != null,
        child: MenuActionButton(
          onTap: onTap != null ? () => tapHandler(context, onTap) : null,
          hoverColor: theme.onHoverBackgroundColor!,
          pressedColor: theme.onPressedBackgroundColor!,
          child: _HeaderBody(
            leading: leading,
            title: title,
            titleStyle: theme.textStyle!,
            subtitle: subtitle,
            subtitleStyle: theme.subtitleStyle!,
            icon: icon,
            iconWidget: iconWidget,
            onHoverTextColor: theme.onHoverTextColor!,
          ),
        ),
      ),
    );
  }
}

/// An a header menu item.
@immutable
class _HeaderBody extends StatelessWidget {
  /// Creates [_HeaderBody].
  const _HeaderBody({
    required this.leading,
    required this.title,
    required this.titleStyle,
    required this.subtitle,
    required this.subtitleStyle,
    required this.icon,
    required this.iconWidget,
    required this.onHoverTextColor,
  });

  final Widget leading;
  final String title;
  final TextStyle titleStyle;
  final String? subtitle;
  final TextStyle subtitleStyle;
  final IconData? icon;
  final Widget? iconWidget;
  final Color onHoverTextColor;

  @override
  Widget build(BuildContext context) {
    final isHovered = MenuActionButtonState.of(context);

    final minHeight = ElementSize.resolveLargeWithSubtitle(context);

    final isInAccessibilityMode = TextUtils.isInAccessibilityMode(context);
    final maxLines = isInAccessibilityMode ? 3 : 2;

    Widget body = Text(
      title,
      style: titleStyle.copyWith(
        color: isHovered ? onHoverTextColor : null,
      ),
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      maxLines: maxLines,
    );

    if (subtitle != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          body,
          Text(
            subtitle!,
            style: subtitleStyle,
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

    body = Row(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: _kHeaderEndPadding),
          child: _Leading(child: leading),
        ),
        Expanded(child: body),
        if (hasIcon)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: (isHovered ? onHoverTextColor : subtitleStyle.color!)
                    .withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: IconActionBox(
                color: isHovered ? onHoverTextColor : titleStyle.color!,
                child: iconWidget ?? Icon(icon),
              ),
            ),
          )
      ],
    );

    return AnimatedMenuContainer(
      alignment: AlignmentDirectional.centerStart,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: _padding,
      child: body,
    );
  }
}

/// A leading widget for [PullDownMenuHeader].
@immutable
class _Leading extends StatelessWidget {
  /// Creates [_Leading].
  const _Leading({
    required this.child,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final shadowColor =
        PullDownMenuRouteTheme.resolve(context, routeTheme: null).shadow!.color;

    return Container(
      constraints: const BoxConstraints.tightFor(
        height: kMinInteractiveDimensionCupertino,
        width: kMinInteractiveDimensionCupertino,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: child,
    );
  }
}
