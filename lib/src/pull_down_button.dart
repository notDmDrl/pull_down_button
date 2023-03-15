import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pull_down_button.dart';
import '_internals/animation.dart';
import '_internals/menu_config.dart';
import '_internals/route.dart';

/// Used to configure how the [PullDownButton] positions its pull-down menu and
/// what type of movement (upwards or downwards) it will use for menu's appear
/// animation.
enum PullDownMenuPosition {
  /// Menu is positioned over an anchor and is forced to be under an anchor
  /// (downwards movement)
  ///
  /// If there is no available space to place menu over an anchor with
  /// downwards movement, menu will be placed over an anchor with upwards
  /// movement.
  over,

  /// Menu is positioned under an anchor and is forced to be under an anchor
  /// (downwards movement).
  ///
  /// If there is no available space to place menu under an anchor, menu will
  /// be placed above an anchor (upwards movement).
  under,

  /// Menu is positioned above an anchor and is forced to always be above an
  /// anchor (upwards movement).
  ///
  /// If there is no available space to place menu above an anchor, menu will
  /// be placed under an anchor (downwards movement).
  above,

  /// Menu is positioned under or above an anchor depending on side that has
  /// more space available.
  ///
  /// If positioned under anchor - downwards movement will be used, if
  /// positioned above - upwards movement will be used.
  automatic,
}

/// Used to configure how the [PullDownButton.itemBuilder] orders it's items.
enum PullDownMenuItemsOrder {
  /// Items are always ordered from item `0` to item `N` in
  /// [PullDownButton.itemBuilder] (from top to bottom).
  ///
  /// For example, list of items (1, 2, 3) will result in menu rendering them
  /// like this:
  ///
  /// ```
  /// -----
  /// | 1 |
  /// -----
  /// | 2 |
  /// -----
  /// | 3 |
  /// -----
  /// ```
  downwards,

  /// Items are always ordered from item `N` to item `0` in
  /// [PullDownButton.itemBuilder] (from bottom to top).
  ///
  /// For example, list of items (1, 2, 3) will result in menu rendering them
  /// like this:
  ///
  /// ```
  /// -----
  /// | 3 |
  /// -----
  /// | 2 |
  /// -----
  /// | 1 |
  /// -----
  /// ```
  upwards,

  /// Items are ordered depending on menu's [PullDownMenuPosition] (and its
  /// potential overflow). Based on SwiftUI *Menu* behavior.
  ///
  /// If the menu is being opened with downwards movement items will be ordered
  /// from `0` to item `N` in [PullDownButton.itemBuilder] (from top to bottom).
  ///
  /// For example, list of items (1, 2, 3) will result in menu rendering them
  /// like this:
  ///
  /// ```
  /// -----
  /// | 1 |
  /// -----
  /// | 2 |
  /// -----
  /// | 3 |
  /// -----
  /// ```
  ///
  /// If the menu is being opened with upwards movement items will be ordered
  /// from `N` to item `0` in [PullDownButton.itemBuilder] (from bottom to top).
  ///
  /// For example, list of items (1, 2, 3) will result in menu rendering them
  /// like this:
  ///
  /// ```
  /// -----
  /// | 3 |
  /// -----
  /// | 2 |
  /// -----
  /// | 1 |
  /// -----
  /// ```
  automatic,
}

/// Signature for the callback invoked when a [PullDownButton] is dismissed
/// without selecting an item.
///
/// Used by [PullDownButton.onCanceled].
typedef PullDownMenuCanceled = void Function();

/// Signature used by [PullDownButton] to lazily construct the items shown when
/// the button is pressed.
///
/// Used by [PullDownButton.itemBuilder].
typedef PullDownMenuItemBuilder = List<PullDownMenuEntry> Function(
  BuildContext context,
);

/// Signature used by [PullDownButton] to build button widget.
///
/// Used by [PullDownButton.buttonBuilder].
typedef PullDownMenuButtonBuilder = Widget Function(
  BuildContext context,
  Future<void> Function() showMenu,
);

/// Displays a pull-down menu and animates button to lower opacity when pressed.
///
/// See also:
///
/// * [PullDownMenuItem], a pull-down menu entry for a simple action.
/// * [PullDownMenuItem.selectable], a pull-down menu entry for a selection
///   action.
/// * [PullDownMenuDivider], a pull-down menu entry for a divider.
/// * [PullDownMenuDivider.large], a pull-down menu entry that is a large
///   divider.
/// * [PullDownMenuTitle], a pull-down menu entry for a menu title.
/// * [PullDownMenuActionsRow], a more compact way to show multiple pull-down
///   menu entries for a simple action.
/// * [PullDownButtonTheme], a pull-down button and menu theme configuration.
/// * [showPullDownMenu], a alternative way of displaying a pull-down menu.
/// * [PullDownMenu], a pull-down menu box without any route animations.
@immutable
class PullDownButton extends StatefulWidget {
  /// Creates a button that shows a pull-down menu.
  const PullDownButton({
    super.key,
    required this.itemBuilder,
    required this.buttonBuilder,
    this.onCanceled,
    this.offset = Offset.zero,
    this.position = PullDownMenuPosition.under,
    this.itemsOrder = PullDownMenuItemsOrder.downwards,
    this.routeTheme,
    this.applyOpacity,
  });

  /// Called when the button is pressed to create the items to show in the menu.
  ///
  /// If items contains at least one tappable menu item of type
  /// [PullDownMenuItem.selectable] all of [PullDownMenuItem]s should also be of
  /// type [PullDownMenuItem.selectable].
  ///
  /// See https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons
  ///
  /// In order to achieve it all [PullDownMenuItem]s will automatically switch
  /// to "selectable" view.
  final PullDownMenuItemBuilder itemBuilder;

  /// Builder that provides [BuildContext] as well as `showMenu` function to
  /// pass to any custom button widget.
  final PullDownMenuButtonBuilder buttonBuilder;

  /// Called when the user dismisses the pull-down menu.
  final PullDownMenuCanceled? onCanceled;

  /// The offset is applied relative to the initial position set by the
  /// [position].
  ///
  /// Defaults to [Offset.zero].
  final Offset offset;

  /// Whether the popup menu is positioned above, over or under the popup menu
  /// button.
  ///
  /// [offset] is used to change the position of the popup menu relative to the
  /// position set by this parameter.
  ///
  /// Defaults to [PullDownMenuPosition.under] which makes the popup menu
  /// appear directly under the button that was used to create it.
  final PullDownMenuPosition position;

  /// Whether the popup menu orders its items from [itemBuilder] in downwards
  /// or upwards way.
  ///
  /// Defaults to [PullDownMenuItemsOrder.downwards].
  final PullDownMenuItemsOrder itemsOrder;

  /// Theme of route used to display pull-down menu launched from this
  /// [PullDownButton].
  ///
  /// If this property is null then [PullDownMenuRouteTheme] from
  /// [PullDownButtonTheme.routeTheme] is used.
  ///
  /// If that's null then [PullDownMenuRouteTheme.defaults] is used.
  final PullDownMenuRouteTheme? routeTheme;

  /// Whether to apply opacity on [buttonBuilder] as it is in iOS
  /// or not.
  ///
  /// If this property is null then [PullDownButtonTheme.applyOpacity]
  /// from [PullDownButtonTheme] theme extension is used.
  ///
  /// If that's null then [applyOpacity] will be set to `true`.
  final bool? applyOpacity;

  @override
  State<PullDownButton> createState() => _PullDownButtonState();
}

class _PullDownButtonState extends State<PullDownButton> {
  bool isPressed = false;

  Future<void> showButtonMenu() async {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final offset = widget.offset;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final items = widget.itemBuilder(context);

    if (items.isEmpty) return;

    final hasLeading = MenuConfig.menuHasLeading(items);

    setState(() => isPressed = true);

    final action = await _showMenu<VoidCallback>(
      context: context,
      items: items,
      position: position,
      buttonSize: button.size,
      menuPosition: widget.position,
      itemsOrder: widget.itemsOrder,
      routeTheme: widget.routeTheme,
      hasLeading: hasLeading,
    );

    if (!mounted) return;

    setState(() => isPressed = false);

    if (action != null) {
      action.call();
    } else {
      widget.onCanceled?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = PullDownButtonTheme.of(context);

    final apply = widget.applyOpacity ?? theme?.applyOpacity ?? true;

    final buttonBuilder = widget.buttonBuilder(context, showButtonMenu);

    if (!apply) return buttonBuilder;

    return AnimatedOpacity(
      opacity: isPressed ? 0.4 : 1,
      duration: kMenuDuration,
      curve: kCurve,
      child: buttonBuilder,
    );
  }
}

/// Displays a pull-down menu with [items] at [position].
///
/// [items] should be not empty for menu to be shown.
///
/// If [items] contains at least one tappable menu item of type
/// [PullDownMenuItem.selectable] all of [PullDownMenuItem]s should also be of
/// type [PullDownMenuItem.selectable].
///
/// See https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons
///
/// In order to achieve it all [PullDownMenuItem]s will automatically switch
/// to "selectable" view.
///
/// Desired [position] is used to align top of the menu with top of the
/// [position] rectangle. [buttonSize] can be additionally used to let menu
/// know about additional bottom offsets it needs to consider while calculating
/// final menu's position.
///
/// [menuPosition] is used to define whether the popup menu is positioned above,
/// over or under the calculated menu's position. Defaults to
/// [PullDownMenuPosition.under].
///
/// [itemsOrder] is used to define how menu will order its [items] depending on
/// calculated menu's position. Defaults to
/// [PullDownMenuItemsOrder.downwards].
///
/// [onCanceled] is called when the user dismisses the pull-down menu.
///
/// [routeTheme] is used to define theme of route used to display pull-down menu
/// launched from this function.
///
/// See also:
///
/// * [PullDownButton], a default way of displaying a pull-down menu.
/// * [showMenu], a material design alternative.
/// * [PullDownMenu], an another alternative way of displaying a pull-down
/// menu.
Future<void> showPullDownMenu({
  required BuildContext context,
  required List<PullDownMenuEntry> items,
  required RelativeRect position,
  Size buttonSize = Size.zero,
  PullDownMenuPosition menuPosition = PullDownMenuPosition.under,
  PullDownMenuItemsOrder itemsOrder = PullDownMenuItemsOrder.downwards,
  PullDownMenuCanceled? onCanceled,
  PullDownMenuRouteTheme? routeTheme,
}) async {
  if (items.isEmpty) return;

  final hasLeading = MenuConfig.menuHasLeading(items);

  final action = await _showMenu<VoidCallback>(
    context: context,
    items: items,
    position: position,
    buttonSize: buttonSize,
    menuPosition: menuPosition,
    itemsOrder: itemsOrder,
    routeTheme: routeTheme,
    hasLeading: hasLeading,
  );

  // TODO(notDmDrl): this was not available at Flutter 3.0.0 release,
  // uncomment after min dart version for package is 3.0?
  // if (!context.mounted) return;

  if (action != null) {
    action.call();
  } else {
    onCanceled?.call();
  }
}

/// Is used internally by [PullDownButton] and [showPullDownMenu] to show
/// pull-down menu.
Future<VoidCallback?> _showMenu<VoidCallback>({
  required BuildContext context,
  required RelativeRect position,
  required List<PullDownMenuEntry> items,
  required Size buttonSize,
  required PullDownMenuPosition menuPosition,
  required PullDownMenuItemsOrder itemsOrder,
  required PullDownMenuRouteTheme? routeTheme,
  required bool hasLeading,
}) {
  final navigator = Navigator.of(context);

  return navigator.push<VoidCallback>(
    PullDownMenuRoute(
      position: position,
      items: items,
      barrierLabel: _barrierLabel(context),
      routeTheme: routeTheme,
      buttonSize: buttonSize,
      menuPosition: menuPosition,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      hasLeading: hasLeading,
      itemsOrder: itemsOrder,
    ),
  );
}

String _barrierLabel(BuildContext context) {
  // Use this instead of `MaterialLocalizations.of(context)` because
  // [MaterialLocalizations] might be null in some cases.
  final materialLocalizations =
      Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);

  // Use this instead of `CupertinoLocalizations.of(context)` because
  // [CupertinoLocalizations] might be null in some cases.
  final cupertinoLocalizations =
      Localizations.of<CupertinoLocalizations>(context, CupertinoLocalizations);

  // If both localizations are null, fallback to
  // [DefaultMaterialLocalizations().modalBarrierDismissLabel].
  return materialLocalizations?.modalBarrierDismissLabel ??
      cupertinoLocalizations?.modalBarrierDismissLabel ??
      const DefaultMaterialLocalizations().modalBarrierDismissLabel;
}
