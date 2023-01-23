import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pull_down_button.dart';
import '../utils/gesture_detector.dart';
import '../utils/menu_config.dart';

const EdgeInsetsGeometry _kItemPadding =
    EdgeInsets.symmetric(horizontal: 16, vertical: 8);
const EdgeInsetsGeometry _kSelectableItemPadding =
    EdgeInsetsDirectional.only(start: 12, end: 16, top: 8, bottom: 8);

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

  /// Called when the menu item is tapped.
  final VoidCallback? onTap;

  /// Whether the user is permitted to tap this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
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

  @protected
  void _handleTap(BuildContext context) => Navigator.pop(context, onTap);

  @protected
  bool _debugActionRowHasIcon(ElementSize size) {
    assert(
      () {
        switch (size) {
          case ElementSize.small:
          case ElementSize.medium:
            if (icon != null || iconWidget != null) {
              return true;
            } else {
              throw FlutterError(
                'Either icon or iconWidget should be provided',
              );
            }
          case ElementSize.large:
            return true;
        }
      }(),
      '',
    );

    return true;
  }

  static double _disabledOpacity(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // opacity values were based on direct pixel to pixel comparison with
    // native variant.
    switch (brightness) {
      case Brightness.dark:
        return 0.55;
      case Brightness.light:
        return 0.45;
    }
  }

  @override
  Widget build(BuildContext context) {
    // don't do unnecessary checks from inherited widget if [selected] is not
    // null.
    final viewAsSelectable = selected != null || MenuConfig.of(context);
    final size = ActionsRowSizeConfig.of(context);

    final theme = PullDownMenuItemTheme.of(context);
    final defaults = PullDownMenuItemTheme.defaults(context);

    final Widget child;

    assert(_debugActionRowHasIcon(size), '');

    switch (size) {
      case ElementSize.small:
        child = Padding(
          padding: _kItemPadding,
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
        child = viewAsSelectable
            ? _SelectableLargeItem(
                selected: selected ?? false,
                itemTheme: itemTheme,
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

    var style = size == ElementSize.large
        ? defaults.textStyle!
            .merge(theme?.textStyle)
            .merge(itemTheme?.textStyle)
        : defaults.iconActionTextStyle!
            .merge(theme?.iconActionTextStyle)
            .merge(itemTheme?.iconActionTextStyle);

    if (isDestructive) {
      final color = itemTheme?.destructiveColor ??
          theme?.destructiveColor ??
          defaults.destructiveColor!;

      style = style.copyWith(color: color);
    }

    if (!enabled) {
      style = style.copyWith(
        color: style.color?.withOpacity(_disabledOpacity(context)),
      );
    }

    final colorIcon =
        !isDestructive && iconColor != null ? iconColor : style.color;

    final pressedColor =
        PullDownMenuDividerTheme.of(context)?.largeDividerColor ??
            PullDownMenuDividerTheme.defaults(context).largeDividerColor!;

    final hoverColor = itemTheme?.onHoverColor ??
        theme?.onHoverColor ??
        defaults.onHoverColor!;

    final hoverTextStyle = defaults.onHoverTextStyle!
        .merge(theme?.onHoverTextStyle)
        .merge(itemTheme?.onHoverTextStyle);

    final iconSize =
        itemTheme?.iconSize ?? theme?.iconSize ?? defaults.iconSize!;

    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        button: true,
        child: MenuActionGestureDetector(
          onTap: enabled ? () => _handleTap(context) : null,
          pressedColor: pressedColor,
          hoverColor: hoverColor,
          builder: (context, isHovered) {
            var textStyle = style;

            if (isHovered) {
              if (size == ElementSize.large) {
                textStyle = hoverTextStyle;
              } else {
                textStyle = hoverTextStyle.copyWith(
                  fontSize: style.fontSize,
                  height: style.height,
                );
              }
            }

            return IconTheme(
              data: IconThemeData(
                color: isHovered ? hoverTextStyle.color : colorIcon,
                size: iconSize,
              ),
              child: DefaultTextStyle(
                style: textStyle,
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
                padding: const EdgeInsetsDirectional.only(start: 16),
                child: iconWidget ?? Icon(icon),
              )
          ],
        ),
      );
}

@immutable
class _SelectableLargeItem extends StatelessWidget {
  const _SelectableLargeItem({
    required this.selected,
    required this.itemTheme,
    required this.title,
    required this.icon,
    required this.iconWidget,
  });

  final bool? selected;
  final PullDownMenuItemTheme? itemTheme;
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
              padding: const EdgeInsetsDirectional.only(end: 6),
              child: _CheckmarkIcon(
                selected: selected ?? false,
                itemTheme: itemTheme,
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
              ),
            ),
            if (icon != null || iconWidget != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 16),
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
        padding: _kItemPadding,
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
    required this.itemTheme,
    required this.selected,
  });

  final PullDownMenuItemTheme? itemTheme;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuItemTheme.of(context);
    final defaults = PullDownMenuItemTheme.defaults(context);

    final icon =
        itemTheme?.checkmark ?? theme?.checkmark ?? defaults.checkmark!;

    final weight = itemTheme?.checkmarkWeight ??
        theme?.checkmarkWeight ??
        defaults.checkmarkWeight!;

    final size = itemTheme?.checkmarkSize ??
        theme?.checkmarkSize ??
        defaults.checkmarkSize!;

    if (!selected) {
      return SizedBox.square(dimension: size);
    }

    return SizedBox(
      width: size,
      child: Text.rich(
        TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: size,
            fontWeight: weight,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
          ),
        ),
      ),
    );
  }
}
