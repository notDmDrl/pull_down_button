import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../theme/default_theme.dart';
import '../utils/gesture_detector.dart';
import 'divider.dart';

/// Used to configure how the [PullDownMenuActionsRow] show its
/// [PullDownMenuIconAction]'s and their maximum count;
///
/// See also:
///
/// * preferredElementSize:
///   https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize
enum _ElementSize {
  /// Compact, icon only representation. Maximum 4 items.
  small,

  /// Normal, icon and title vertically aligned. Maximum 3 items.
  medium,
}

/// Displays a number of actions in a more compact way (in a row, 3 or 4 items
/// depending on desired size).
///
/// To show a pull-down menu and create a button that shows a pull-down menu
/// use [PullDownButton.buttonBuilder].
///
/// Default height of [PullDownMenuActionsRow] depends on size:
///
/// * For [PullDownMenuActionsRow.small] it is
///  [kMinInteractiveDimensionCupertino]  pixels.
/// * For [PullDownMenuActionsRow.medium] it is 66 pixels (150% of
/// [kMinInteractiveDimensionCupertino]).
///
/// See also:
/// * [PullDownMenuItem], for a classic, full width pull-down menu entry for a
///   simple action.
/// * preferredElementSize:
///   https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize
@immutable
class PullDownMenuActionsRow extends PullDownMenuEntry {
  /// Creates a row of maximum 4 actions, icon only.
  ///
  /// Actions have height of 44 logical pixels.
  const PullDownMenuActionsRow.small({
    super.key,
    required this.items,
    this.dividerColor,
  })  : _size = _ElementSize.small,
        assert(
          items.length <= 4,
          'Amount of [items] should not be more than 4',
        );

  /// Creates a row of maximum 3 actions, icon and short (one worded) title.
  ///
  /// Actions have height of 66 logical pixels.
  const PullDownMenuActionsRow.medium({
    super.key,
    required this.items,
    this.dividerColor,
  })  : _size = _ElementSize.medium,
        assert(
          items.length <= 3,
          'Amount of [items] should not be more than 3',
        );

  /// The size of descendant [PullDownMenuIconAction]s.
  final _ElementSize _size;

  /// The list of actions.
  ///
  /// Number of provided [items] should not be more than 4 for
  /// [PullDownMenuActionsRow.small] and 3 for [PullDownMenuActionsRow.medium]
  /// to avoid text overflows.
  ///
  /// Required [_ElementSize] is passed to [PullDownMenuIconAction]s via
  /// [_SizeInheritedWidget].
  final List<PullDownMenuIconAction> items;

  /// The color of vertical divider used to split actions.
  ///
  /// If this property is null then
  /// [PullDownButtonTheme.dividerColor] from [PullDownButtonTheme] theme
  /// extension is used. If that's null
  /// then , depending on constructor,
  /// [PullDownButtonTheme.dividerColor] is used.
  final Color? dividerColor;

  /// The height of descendant [PullDownMenuIconAction]s.
  ///
  /// Can be 44 pixels ([_ElementSize.small]) or 66 pixels
  /// ([_ElementSize.medium]).
  @override
  double get height {
    switch (_size) {
      case _ElementSize.small:
        return kMinInteractiveDimensionCupertino;
      case _ElementSize.medium:
        return kMinInteractiveDimensionCupertino +
            kMinInteractiveDimensionCupertino / 2;
    }
  }

  @override
  bool get isDestructive => false;

  @override
  bool get represents => true;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height),
      child: _SizeInheritedWidget(
        size: _size,
        child: Row(
          children: PullDownMenuVerticalDivider.wrapWithDivider(
            items,
            height: height,
            color: dividerColor,
          ),
        ),
      ),
    );
  }
}

/// An item in cupertino style pull-down menu actions row.
///
/// Considering that this type of pull-down menu items is using icons as main
/// way to provide item's action meaning, either [icon] or [iconWidget] are
/// required.
///
/// If [PullDownMenuActionsRow]s size is [_ElementSize.medium], [title] also
/// will be shown.
@immutable
class PullDownMenuIconAction extends StatelessWidget {
  /// Creates an action item for [PullDownMenuActionsRow].
  ///
  /// By default, the item is [enabled].
  const PullDownMenuIconAction({
    super.key,
    required this.onTap,
    this.enabled = true,
    required this.title,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.iconWidget,
    this.isDestructive = false,
    this.iconActionTextStyle,
    this.destructiveColor,
    this.onHoverColor,
    this.onHoverTextStyle,
  }) : assert(
          icon != null || iconWidget != null,
          'Either icon or iconWidget should be provided',
        );

  /// Called when the menu item is tapped.
  final VoidCallback? onTap;

  /// Whether the user is permitted to tap this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;

  /// Title of this [PullDownMenuIconAction], preferably one word.
  final String title;

  /// Icon of this [PullDownMenuIconAction].
  ///
  /// If the [iconWidget] is used, this property must be null;
  final IconData? icon;

  /// The icon size.
  ///
  /// If this property is null then [PullDownButtonTheme.iconSize] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.iconSize] is used.
  final double? iconSize;

  /// Color for this [PullDownMenuIconAction]'s [icon].
  ///
  /// If not provided [PullDownButtonTheme.textStyle].color will be used;
  ///
  /// If [PullDownMenuIconAction] `isDestructive` then [iconColor] will be
  /// ignored.
  final Color? iconColor;

  /// Custom icon widget of this [PullDownMenuIconAction].
  ///
  /// If the [icon] is used, this property must be null;
  final Widget? iconWidget;

  /// The text style to be used by this [PullDownMenuIconAction].
  ///
  /// If this property is null then [PullDownButtonTheme.iconActionTextStyle]
  /// from [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.iconActionTextStyle] is used.
  final TextStyle? iconActionTextStyle;

  /// The text style to be used by this [PullDownMenuIconAction].
  ///
  /// If this property is null then [PullDownButtonTheme.destructiveColor] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.destructiveColor] is used.
  final Color? destructiveColor;

  /// The on hover color of this [PullDownMenuIconAction].
  ///
  /// If this property is null then [PullDownButtonTheme.onHoverColor] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.onHoverColor] is used.
  final Color? onHoverColor;

  /// The on hover text style to be used by this [PullDownMenuIconAction].
  ///
  /// If this property is null then [PullDownButtonTheme.onHoverTextStyle] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.onHoverTextStyle] is used.
  final TextStyle? onHoverTextStyle;

  /// Whether this item represents destructive action;
  ///
  /// If true, the contents of entry are being colored with
  /// [PullDownMenuIconAction.destructiveColor]. If that's null then
  /// [PullDownButtonTheme.destructiveColor] from [PullDownButtonTheme]
  /// theme extension. If that's null too then
  /// [PullDownButtonThemeDefaults.destructiveColor] is used.
  final bool isDestructive;

  /// Content padding.
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  @protected
  void _handleTap(BuildContext context) => Navigator.pop(context, onTap);

  @override
  Widget build(BuildContext context) {
    final size = context
        .dependOnInheritedWidgetOfExactType<_SizeInheritedWidget>()!
        .size;

    final theme = PullDownButtonTheme.of(context);
    final defaults = PullDownButtonThemeDefaults(context);

    var style = PullDownButtonTheme.getProperty(
      widgetProperty: iconActionTextStyle,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.iconActionTextStyle,
    );

    if (isDestructive) {
      final color = PullDownButtonTheme.getProperty(
        widgetProperty: destructiveColor,
        theme: theme,
        defaults: defaults,
        getThemeProperty: (theme) => theme?.destructiveColor,
      );

      style = style.copyWith(color: color);
    }

    if (!enabled) {
      style = style.copyWith(
        color: style.color?.withOpacity(0.38),
      );
    }

    var colorIcon = style.color;

    if (!isDestructive && iconColor != null) {
      colorIcon = iconColor;
    }

    final pressedColor = PullDownButtonTheme.getProperty(
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.largeDividerColor,
    );

    final hoverColor = PullDownButtonTheme.getProperty(
      widgetProperty: onHoverColor,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.onHoverColor,
    );

    final hoverTextStyle = PullDownButtonTheme.getProperty(
      widgetProperty: onHoverTextStyle,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.onHoverTextStyle,
    );

    final Widget child;

    switch (size) {
      case _ElementSize.small:
        child = Center(child: iconWidget ?? Icon(icon));
        break;
      case _ElementSize.medium:
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget ?? Icon(icon),
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
        );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: enabled,
        button: true,
        child: MenuActionGestureDetector(
          onTap: enabled ? () => _handleTap(context) : null,
          pressedColor: pressedColor,
          hoverColor: hoverColor,
          builder: (context, isHovered) => IconTheme.merge(
            data: IconThemeData(
              color: isHovered ? hoverTextStyle.color : colorIcon,
              size: PullDownButtonTheme.getProperty(
                widgetProperty: iconSize,
                theme: theme,
                defaults: defaults,
                getThemeProperty: (theme) => theme?.iconSize,
              ),
            ),
            child: DefaultTextStyle(
              style: isHovered
                  ? hoverTextStyle.copyWith(
                      fontSize: style.fontSize,
                      height: style.height,
                    )
                  : style,
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _SizeInheritedWidget extends InheritedWidget {
  const _SizeInheritedWidget({
    required super.child,
    required this.size,
  });

  final _ElementSize size;

  @override
  bool updateShouldNotify(covariant _SizeInheritedWidget oldWidget) =>
      size != oldWidget.size;
}
