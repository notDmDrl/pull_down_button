import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pull_down_button.dart';
import '_internals/animation.dart';
import '_internals/menu_config.dart';
import '_internals/route.dart';

/// Used to configure how the [PullDownButton] positions its pull-down menu.
///
/// If the size of a button widget (which is used to open the menu) is
/// bigger than the size of device screen, consider using
/// [PullDownMenuPosition.over] or [showPullDownMenu] (with desired position)
/// since [PullDownMenuPosition.automatic] forces menu to be above or under a
/// button widget which might result in layout exceptions.
enum PullDownMenuPosition {
  /// Menu is positioned under or above an anchor depending on side that has
  /// more space available.
  ///
  /// If positioned under anchor - downwards movement will be used, if
  /// positioned above - upwards movement will be used.
  automatic,

  /// Menu is positioned under or above an anchor depending on side that has
  /// more space available but also covers the button used to open the menu.
  ///
  /// If there is no available space to place menu over an anchor with
  /// downwards movement, menu will be placed over an anchor with upwards
  /// movement.
  over,
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

/// Used to provide information about menu animation state in
/// [PullDownButton.animationBuilder].
///
/// Used by [PullDownButtonAnimationBuilder].
enum PullDownButtonAnimationState {
  /// Menu is closed.
  closed,

  /// Menu is opened by calling [showMenu] using
  /// [PullDownButton.buttonBuilder]'s button widget.
  opened,
}

/// Signature used by [PullDownButton] to create animation for
/// [PullDownButton.buttonBuilder] when pull-down menu is opened.
///
/// [child] is a button created with [PullDownButton.buttonBuilder].
///
/// Used by [PullDownButton.animationBuilder].
typedef PullDownButtonAnimationBuilder = Widget Function(
  BuildContext context,
  PullDownButtonAnimationState state,
  Widget child,
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
    this.position = PullDownMenuPosition.automatic,
    this.itemsOrder = PullDownMenuItemsOrder.downwards,
    this.animationBuilder = defaultAnimationBuilder,
    this.routeTheme,
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

  /// Whether the popup menu is positioned above, over or under the popup menu
  /// button.
  ///
  /// Defaults to [PullDownMenuPosition.automatic] which makes the popup menu
  /// appear directly under or above the button that was used to create it
  /// (based on side that has more space available).
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

  /// Custom animation for [buttonBuilder] when pull-down menu is opening or
  /// closing.
  ///
  /// Defaults to [defaultAnimationBuilder] which applies opacity on
  /// [buttonBuilder] as it is in iOS.
  ///
  /// If this property is null then no animation will be used.
  final PullDownButtonAnimationBuilder? animationBuilder;

  /// Default animation builder for [animationBuilder].
  ///
  /// If [state] is [PullDownButtonAnimationState.opened], applies opacity
  /// on [child] as it is in iOS.
  static Widget defaultAnimationBuilder(
    BuildContext context,
    PullDownButtonAnimationState state,
    Widget child,
  ) {
    final isPressed = state == PullDownButtonAnimationState.opened;

    // All of the values where eyeballed using iOS 16 Simulator.
    return AnimatedOpacity(
      opacity: isPressed ? 0.4 : 1,
      duration: Duration(milliseconds: isPressed ? 100 : 200),
      curve: isPressed
          ? Curves.fastLinearToSlowEaseIn
          : AnimationUtils.kCurveReverse,
      child: child,
    );
  }

  @override
  State<PullDownButton> createState() => _PullDownButtonState();
}

class _PullDownButtonState extends State<PullDownButton> {
  PullDownButtonAnimationState state = PullDownButtonAnimationState.closed;

  Future<void> showButtonMenu() async {
    final button = PullDownMenuRoute.getRect(context);
    final animationAlignment =
        PullDownMenuRoute.predictedAnimationAlignment(context, button);

    final items = widget.itemBuilder(context);

    if (items.isEmpty) return;

    final hasLeading = MenuConfig.menuHasLeading(items);

    setState(() => state = PullDownButtonAnimationState.opened);

    final action = await _showMenu<VoidCallback>(
      context: context,
      items: items,
      buttonRect: button,
      menuPosition: widget.position,
      itemsOrder: widget.itemsOrder,
      routeTheme: widget.routeTheme,
      hasLeading: hasLeading,
      animationAlignment: animationAlignment,
    );

    if (!mounted) return;

    setState(() => state = PullDownButtonAnimationState.closed);

    if (action != null) {
      action.call();
    } else {
      widget.onCanceled?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonBuilder = widget.buttonBuilder(context, showButtonMenu);

    return widget.animationBuilder?.call(context, state, buttonBuilder) ??
        buttonBuilder;
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
/// [position] rectangle.
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
  required Rect position,
  PullDownMenuItemsOrder itemsOrder = PullDownMenuItemsOrder.downwards,
  PullDownMenuCanceled? onCanceled,
  PullDownMenuRouteTheme? routeTheme,
}) async {
  if (items.isEmpty) return;

  final hasLeading = MenuConfig.menuHasLeading(items);

  final action = await _showMenu<VoidCallback>(
    context: context,
    items: items,
    buttonRect: position,
    menuPosition: PullDownMenuPosition.automatic,
    itemsOrder: itemsOrder,
    routeTheme: routeTheme,
    hasLeading: hasLeading,
    animationAlignment:
        PullDownMenuRoute.predictedAnimationAlignment(context, position),
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
  required Rect buttonRect,
  required List<PullDownMenuEntry> items,
  required PullDownMenuPosition menuPosition,
  required PullDownMenuItemsOrder itemsOrder,
  required PullDownMenuRouteTheme? routeTheme,
  required bool hasLeading,
  required Alignment animationAlignment,
}) {
  final navigator = Navigator.of(context);

  return navigator.push<VoidCallback>(
    PullDownMenuRoute(
      buttonRect: buttonRect,
      items: items,
      barrierLabel: _barrierLabel(context),
      routeTheme: routeTheme,
      menuPosition: menuPosition,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      hasLeading: hasLeading,
      itemsOrder: itemsOrder,
      alignment: animationAlignment,
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
