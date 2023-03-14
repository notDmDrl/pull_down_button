import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../utils/gesture_detector.dart';
import '../utils/menu_config.dart';

// Note:
// I am not entirely sure why top and bottom padding values are that much
// different but only using those values it was possible to closely match with
// native counterpart when we have a `PullDownMenuItem.title` long enough to
// overflow to second row
const EdgeInsetsGeometry _kItemPadding =
    EdgeInsetsDirectional.only(start: 16, end: 18, top: 9.5, bottom: 12.5);
const EdgeInsetsGeometry _kSelectableItemPadding =
    EdgeInsetsDirectional.only(start: 13, end: 18, top: 9.5, bottom: 12.5);
const EdgeInsetsGeometry _kIconActionPadding = EdgeInsetsDirectional.all(8);

/// Signature used by [PullDownMenuItem] to resolve how [onTap] callback is
/// used.
///
/// Default behaviour is to pop the menu and than call the [onTap].
///
/// Used by [PullDownMenuItem.tapHandler].
///
/// See also:
///
/// * [PullDownMenuItem.defaultTapHandler], a default tap handler.
/// * [PullDownMenuItem.noPopTapHandler], a tap handler that immediately calls
/// [onTap] without popping the menu.
typedef PullDownMenuItemTapHandler = void Function(
  BuildContext context,
  VoidCallback onTap,
);

/// An item in a cupertino style pull-down menu.
///
/// To show a pull-down menu and create a button that shows a pull-down menu
/// use [PullDownButton.buttonBuilder].
///
/// To show a checkmark next to pull-down menu item (an item with selection
/// state), consider using [PullDownMenuItem.selectable].
///
/// By default, a [PullDownMenuItem] is minimum of
/// [kMinInteractiveDimensionCupertino] pixels height.
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
    this.icon,
    this.itemTheme,
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
    this.icon,
    this.itemTheme,
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
  final VoidCallback? onTap;

  /// Handler that provides this item's [BuildContext] as well as [onTap] to
  /// resolve how [onTap] callback is used.
  final PullDownMenuItemTapHandler tapHandler;

  /// Whether the user is permitted to tap this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches and item's text styles and icon colors will be updated with lower
  /// opacity to indicate disabled state.
  final bool enabled;

  /// Title of this [PullDownMenuItem].
  final String title;

  /// Icon of this [PullDownMenuItem].
  ///
  /// If the [iconWidget] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow] either this or [iconWidget] are
  /// required.
  final IconData? icon;

  /// Theme of this [PullDownMenuItem].
  ///
  /// If this property is null then [PullDownMenuItemTheme] from
  /// [PullDownButtonTheme.itemTheme] is used.
  ///
  /// If that's null then defaults from [PullDownMenuItemTheme.defaults] are
  /// used.
  final PullDownMenuItemTheme? itemTheme;

  /// Color for this [PullDownMenuItem]'s [icon].
  ///
  /// If not provided `textStyle.color` from [itemTheme] will be used.
  ///
  /// If [PullDownMenuItem] `isDestructive` then [iconColor] will be ignored;
  final Color? iconColor;

  /// Custom icon widget of this [PullDownMenuItem].
  ///
  /// If the [icon] is used, this property must be null;
  ///
  /// If used in [PullDownMenuActionsRow] either this or [icon] are required.
  final Widget? iconWidget;

  /// Whether this item represents destructive action;
  ///
  /// If this is true then `destructiveColor` from [itemTheme] is used.
  final bool isDestructive;

  /// Whether to display a checkmark next to the menu item.
  ///
  /// Defaults to `null`.
  ///
  /// If [PullDownMenuItem] is used inside [PullDownMenuActionsRow] this
  /// property will be ignored and checkmark will not be showed.
  ///
  /// When true, an [PullDownMenuItemTheme.checkmark] checkmark is displayed
  /// (from [itemTheme]).
  ///
  /// If itemTheme is null then defaults from [PullDownMenuItemTheme.defaults]
  /// are used.
  final bool? selected;

  /// Default tap handler for [PullDownMenuItem].
  ///
  /// The behaviour is to pop the menu and than call the [onTap].
  static void defaultTapHandler(BuildContext context, VoidCallback? onTap) =>
      Navigator.pop(context, onTap);

  /// An additional, pre-made tap handler for [PullDownMenuItem].
  ///
  /// The behaviour is to call the [onTap] without popping the menu.
  static void noPopTapHandler(BuildContext _, VoidCallback? onTap) =>
      onTap?.call();

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
      enabled: enabled,
      isDestructive: isDestructive,
    );

    final Widget child;

    switch (size) {
      case ElementSize.small:
        child = Padding(
          padding: _kIconActionPadding,
          child: Center(child: iconWidget ?? Icon(icon)),
        );
        break;
      case ElementSize.medium:
        child = _MediumItem(
          icon: iconWidget ?? Icon(icon),
          title: title,
        );
        break;
      case ElementSize.large:
        // don't do unnecessary checks from inherited widget if [selected] is
        // not null.
        final viewAsSelectable =
            selected != null || MenuConfig.of(context).hasLeading;

        child = viewAsSelectable
            ? _SelectableLargeItem(
                checkmark: _CheckmarkIcon(
                  selected: selected ?? false,
                  checkmark: theme.checkmark!,
                  checkmarkWeight: theme.checkmarkWeight!,
                  checkmarkSize: theme.checkmarkSize!,
                ),
                title: title,
                icon: icon,
                iconWidget: iconWidget,
              )
            : _LargeItem(
                title: title,
                icon: icon,
                iconWidget: iconWidget,
              );
        break;
    }

    final style = size == ElementSize.large
        ? theme.textStyle!
        : theme.iconActionTextStyle!;

    final colorIcon =
        !isDestructive && iconColor != null ? iconColor : style.color;

    final hoverTextStyle = theme.onHoverTextStyle!;

    final iconSize = theme.iconSize;

    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        button: true,
        selected: selected,
        child: MenuActionGestureDetector(
          onTap: enabled ? () => tapHandler(context, onTap!) : null,
          pressedColor:
              PullDownMenuDividerTheme.resolve(context).largeDividerColor!,
          hoverColor: theme.onHoverColor!,
          builder: (context, isHovered) {
            var textStyle = style;

            if (isHovered) {
              textStyle = size == ElementSize.large
                  ? hoverTextStyle
                  : hoverTextStyle.copyWith(
                      fontSize: style.fontSize,
                      height: style.height,
                    );
            }

            return IconTheme(
              data: IconThemeData(
                color: isHovered ? hoverTextStyle.color : colorIcon,
                size: iconSize,
              ),
              child: DefaultTextStyle(
                style: textStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

@immutable
class _LargeItem extends StatelessWidget {
  const _LargeItem({
    required this.title,
    required this.icon,
    required this.iconWidget,
  });

  final String title;
  final IconData? icon;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) => Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: const BoxConstraints(
          minHeight: kMinInteractiveDimensionCupertino,
        ),
        padding: _kItemPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
              ),
            ),
            if (icon != null || iconWidget != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: iconWidget ?? Icon(icon),
              )
          ],
        ),
      );
}

@immutable
class _SelectableLargeItem extends StatelessWidget {
  const _SelectableLargeItem({
    required this.checkmark,
    required this.title,
    required this.icon,
    required this.iconWidget,
  });

  final Widget checkmark;
  final String title;
  final IconData? icon;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) => Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: const BoxConstraints(
          minHeight: kMinInteractiveDimensionCupertino,
        ),
        padding: _kSelectableItemPadding,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 3),
              child: checkmark,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
              ),
            ),
            if (icon != null || iconWidget != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: iconWidget ?? Icon(icon),
              )
          ],
        ),
      );
}

@immutable
class _MediumItem extends StatelessWidget {
  const _MediumItem({
    required this.icon,
    required this.title,
  });

  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: _kIconActionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            )
          ],
        ),
      );
}

// Replicate the Icon logic here to add weight to checkmark as seen in iOS.
@immutable
class _CheckmarkIcon extends StatelessWidget {
  const _CheckmarkIcon({
    required this.selected,
    required this.checkmark,
    required this.checkmarkWeight,
    required this.checkmarkSize,
  });

  final IconData checkmark;
  final FontWeight checkmarkWeight;
  final double checkmarkSize;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return SizedBox.square(dimension: checkmarkSize);
    }

    return SizedBox(
      width: checkmarkSize,
      child: Text.rich(
        TextSpan(
          text: String.fromCharCode(checkmark.codePoint),
          style: TextStyle(
            fontSize: checkmarkSize,
            fontWeight: checkmarkWeight,
            fontFamily: checkmark.fontFamily,
            package: checkmark.fontPackage,
          ),
        ),
      ),
    );
  }
}
