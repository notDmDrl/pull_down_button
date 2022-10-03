import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import '../theme/default_theme.dart';
import '../utils/gesture_detector.dart';

/// An item in a cupertino style pull-down menu.
///
/// To show a pull-down menu and create a button that shows a pull-down menu
/// use [PullDownButton.buttonBuilder].
///
/// To show a checkmark next to pull-down menu item, consider using
/// [SelectablePullDownMenuItem].
///
/// By default, a [PullDownMenuItem] is minimum of
/// [kMinInteractiveDimensionCupertino] pixels height.
@immutable
class PullDownMenuItem extends PullDownMenuEntry {
  /// Creates an item for a pull-down menu.
  ///
  /// By default, the item is [enabled].
  const PullDownMenuItem({
    super.key,
    required this.onTap,
    this.enabled = true,
    required this.title,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.iconWidget,
    this.isDestructive = false,
    this.textStyle,
    this.destructiveColor,
    this.onHoverColor,
    this.onHoverTextStyle,
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
  final IconData? icon;

  /// The icon size.
  ///
  /// If this property is null then [PullDownButtonTheme.iconSize] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.iconSize] is used.
  final double? iconSize;

  /// Color for this [PullDownMenuItem]'s [icon].
  ///
  /// If not provided [PullDownButtonTheme.textStyle].color will be used;
  ///
  /// If [PullDownMenuItem] `isDestructive` then [iconColor] will be ignored;
  final Color? iconColor;

  /// Custom icon widget of this [PullDownMenuItem].
  ///
  /// If the [icon] is used, this property must be null;
  final Widget? iconWidget;

  /// The text style to be used by this [PullDownMenuItem].
  ///
  /// If this property is null then [PullDownButtonTheme.textStyle] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.textStyle] is used.
  final TextStyle? textStyle;

  /// The text style to be used by this [PullDownMenuItem].
  ///
  /// If this property is null then [PullDownButtonTheme.destructiveColor] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.destructiveColor] is used.
  final Color? destructiveColor;

  /// The on hover color of this [PullDownMenuItem].
  ///
  /// If this property is null then [PullDownButtonTheme.onHoverColor] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.onHoverColor] is used.
  final Color? onHoverColor;

  /// The on hover text style to be used by this [PullDownMenuItem].
  ///
  /// If this property is null then [PullDownButtonTheme.onHoverTextStyle] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.onHoverTextStyle] is used.
  final TextStyle? onHoverTextStyle;

  /// Whether this item represents destructive action;
  ///
  /// If true, the contents of entry are being colored with
  /// [PullDownMenuItem.destructiveColor]. If that's null then
  /// [PullDownButtonTheme.destructiveColor] from [PullDownButtonTheme]
  /// theme extension. If that's null too then
  /// [PullDownButtonThemeDefaults.destructiveColor] is used.
  @override
  final bool isDestructive;

  /// Content padding.
  EdgeInsets get padding => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      );

  /// Height of [PullDownMenuItem].
  ///
  /// Defaults to [kMinInteractiveDimensionCupertino].
  @override
  double get height => kMinInteractiveDimensionCupertino;

  @override
  bool get represents => true;

  /// Build item body.
  @protected
  Widget buildChild() => Row(
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
            ),
          ),
          if (icon != null || iconWidget != null)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: iconWidget ?? Icon(icon),
            )
        ],
      );

  @protected
  void _handleTap(BuildContext context) => Navigator.pop(context, onTap);

  @override
  Widget build(BuildContext context) {
    final theme = PullDownButtonTheme.of(context);
    final defaults = PullDownButtonThemeDefaults(context);

    var style = PullDownButtonTheme.getProperty(
      widgetProperty: textStyle,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.textStyle,
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
              style: isHovered ? hoverTextStyle : style,
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                constraints: BoxConstraints(minHeight: height),
                padding: padding,
                child: buildChild(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An item with selection state in a cupertino style pull-down menu.
///
/// To show a pull-down menu and create a button that shows a pull-down menu
/// use [PullDownButton.buttonBuilder].
///
/// To show normal pull-down menu item, consider using
/// [PullDownMenuItem].
///
/// By default, a [SelectablePullDownMenuItem] is minimum of
/// [kMinInteractiveDimensionCupertino] pixels height.
@immutable
class SelectablePullDownMenuItem extends PullDownMenuItem {
  /// Creates an item with selection state for a pull-down menu.
  ///
  /// By default, the item is [enabled] and not [selected].
  const SelectablePullDownMenuItem({
    super.key,
    this.selected = false,
    this.checkmark,
    this.checkmarkWeight,
    this.checkmarkSize,
    super.enabled,
    required super.title,
    super.icon,
    super.isDestructive,
    required super.onTap,
    super.iconSize,
    super.iconWidget,
    super.iconColor,
    super.textStyle,
    super.destructiveColor,
    super.onHoverColor,
    super.onHoverTextStyle,
  }) : assert(
          icon == null || iconWidget == null,
          'Please provide either icon or iconWidget',
        );

  /// Helper constructor for converting [PullDownMenuItem] to
  /// [SelectablePullDownMenuItem].
  @internal
  SelectablePullDownMenuItem.convertFrom(PullDownMenuItem item)
      : selected = false,
        checkmark = null,
        checkmarkWeight = null,
        checkmarkSize = null,
        super(
          key: item.key,
          enabled: item.enabled,
          title: item.title,
          icon: item.icon,
          isDestructive: item.isDestructive,
          onTap: item.onTap,
          iconSize: item.iconSize,
          iconWidget: item.iconWidget,
          iconColor: item.iconColor,
          textStyle: item.textStyle,
          destructiveColor: item.destructiveColor,
          onHoverColor: item.onHoverColor,
          onHoverTextStyle: item.onHoverTextStyle,
        );

  /// Whether to display a checkmark next to the menu item.
  ///
  /// Defaults to false.
  ///
  /// When true, an [CupertinoIcons.checkmark] checkmark is displayed.
  final bool selected;

  /// The checkmark icon.
  ///
  /// If this property is null then [PullDownButtonTheme.checkmark] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.checkmark] is used.
  final IconData? checkmark;

  /// The checkmark font weight.
  ///
  /// If this property is null then [PullDownButtonTheme.checkmarkWeight] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.checkmarkWeight] is used.
  final FontWeight? checkmarkWeight;

  /// The checkmark size.
  ///
  /// If this property is null then [PullDownButtonTheme.checkmarkSize] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.checkmarkSize] is used.
  final double? checkmarkSize;

  @override
  EdgeInsets get padding =>
      const EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 8);

  @override
  Widget buildChild() => Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _CheckmarkIcon(
              selected: selected,
              checkmark: checkmark,
              checkmarkWeight: checkmarkWeight,
              checkmarkSize: checkmarkSize,
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
              padding: const EdgeInsets.only(left: 16),
              child: iconWidget ?? Icon(icon),
            )
        ],
      );
}

// Replicate the Icon logic here to add weight to checkmark as seen in iOS
@immutable
class _CheckmarkIcon extends StatelessWidget {
  const _CheckmarkIcon({
    this.checkmark,
    this.checkmarkWeight,
    this.checkmarkSize,
    required this.selected,
  });

  final IconData? checkmark;
  final FontWeight? checkmarkWeight;
  final double? checkmarkSize;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownButtonTheme.of(context);

    final defaults = PullDownButtonThemeDefaults(context);

    final icon = PullDownButtonTheme.getProperty(
      widgetProperty: checkmark,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.checkmark,
    );

    final weight = PullDownButtonTheme.getProperty(
      widgetProperty: checkmarkWeight,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.checkmarkWeight,
    );

    final size = PullDownButtonTheme.getProperty(
      widgetProperty: checkmarkSize,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.checkmarkSize,
    );

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
