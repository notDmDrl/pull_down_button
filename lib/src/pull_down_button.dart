import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../pull_down_button.dart';
import 'internals/extensions.dart';
import 'internals/menu_config.dart';
import 'internals/route.dart';

/// Used to configure how the [PullDownButton] positions its pull-down menu.
///
/// If the size of a button widget (which is used to open the menu via
/// [PullDownButton.buttonBuilder]) is bigger than the size of the device
/// screen, [PullDownButton] will attempt to fit the menu inside the screen.
///
/// If the end position is not what was desired, consider using
/// [showPullDownMenu].
enum PullDownMenuPosition {
  /// Menu is positioned under or above an anchor depending on the side that
  /// has more space available.
  ///
  /// If positioned under anchor - downward movement will be used,
  /// if positioned above - upwards movement will be used.
  automatic,

  /// Menu is positioned under or above an anchor depending on the side that
  /// has more space available but also covers the button used to open the menu.
  ///
  /// If there is no available space to place the menu over an anchor with a
  /// downward movement, the menu will be placed over an anchor with an upwards
  /// movement.
  over,
}

/// Used to configure how the [PullDownButton.itemBuilder] orders its items.
enum PullDownMenuItemsOrder {
  /// Items are always ordered from item `0` to item `N` in
  /// [PullDownButton.itemBuilder] (from top to bottom).
  ///
  /// For example, a list of items (1, 2, 3) will result in the menu rendering
  /// them like this:
  ///
  /// ```text
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
  /// For example, a list of items (1, 2, 3) will result in the menu rendering
  /// them like this:
  ///
  /// ```text
  /// -----
  /// | 3 |
  /// -----
  /// | 2 |
  /// -----
  /// | 1 |
  /// -----
  /// ```
  upwards,

  /// Items are ordered depending on the menu's [PullDownMenuPosition] (and its
  /// potential overflow). Based on SwiftUI *Menu* behavior.
  ///
  /// If the menu is being opened with downward movement items will be ordered
  /// from `0` to item `N` in [PullDownButton.itemBuilder] (from top to bottom).
  ///
  /// For example, a list of items (1, 2, 3) will result in the menu rendering
  /// them like this:
  ///
  /// ```text
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
  /// For example, a list of items (1, 2, 3) will result in the menu rendering
  /// them like this:
  ///
  /// ```text
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

/// Used to provide information about menu animation state in
/// [PullDownButton.animationBuilder].
///
/// Used by [PullDownButtonAnimationBuilder].
enum PullDownButtonAnimationState {
  /// The menu is closed.
  closed,

  /// The menu is opened by calling [showMenu] using
  /// [PullDownButton.buttonBuilder]'s button widget.
  opened;

  /// Whether the [PullDownMenuButtonBuilder]s button is pressed and the menu
  /// is open.
  bool get isOpen => this == PullDownButtonAnimationState.opened;
}

/// Used to configure what horizontal part of the
/// [PullDownButton.buttonBuilder] will be considered as an anchor to open
/// the menu from.
///
/// It's best suited for situations where [PullDownButton.buttonBuilder] fills
/// the entire width of the screen and it is desired that menu opens from a
/// specific button edge.
enum PullDownMenuAnchor {
  /// The menu will be "opened" from the [PullDownButton.buttonBuilder]
  /// start edge.
  ///
  /// A [TextDirection] must be available to determine if the start is the left
  /// or the right.
  start,

  /// The menu will be "opened" from the [PullDownButton.buttonBuilder] center.
  center,

  /// The menu will be "opened" from the [PullDownButton.buttonBuilder]
  /// end edge.
  ///
  /// A [TextDirection] must be available to determine if the end is the left
  /// or the right.
  end,
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
typedef PullDownMenuItemBuilder =
    List<Widget> Function(
      BuildContext context,
    );

/// Signature used by [PullDownButton] to build button widget.
///
/// Used by [PullDownButton.buttonBuilder].
typedef PullDownMenuButtonBuilder =
    Widget Function(
      BuildContext context,
      Future<void> Function() showMenu,
    );

/// Signature used by [PullDownButton] to create animation for
/// [PullDownButton.buttonBuilder] when the pull-down menu is opened.
///
/// [child] is a button created with [PullDownButton.buttonBuilder].
///
/// Used by [PullDownButton.animationBuilder].
typedef PullDownButtonAnimationBuilder =
    Widget Function(
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
/// * [PullDownMenuDivider], a pull-down menu entry for a large divider.
/// * [PullDownMenuTitle], a pull-down menu entry for a menu title.
/// * [PullDownMenuActionsRow], a more compact way to show multiple pull-down
///   menu entries for a simple action.
/// * [PullDownButtonTheme], a pull-down button and menu theme configuration.
/// * [showPullDownMenu], an alternative way of displaying a pull-down menu.
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
    this.buttonAnchor,
    this.menuOffset = 16,
    this.scrollController,
    this.animationBuilder = defaultAnimationBuilder,
    this.routeTheme,
    this.animationAlignmentOverride,
    this.useRootNavigator = false,
    this.routeSettings,
  });

  /// Called when the button is pressed to create the items to show in the menu.
  ///
  /// If items contain at least one tappable menu item of type
  /// [PullDownMenuItem.selectable] all of [PullDownMenuItem]s should also be of
  /// type [PullDownMenuItem.selectable].
  ///
  /// See https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons
  ///
  /// In order to achieve it all [PullDownMenuItem]s will automatically switch
  /// to the "selectable" view.
  final PullDownMenuItemBuilder itemBuilder;

  /// Builder that provides [BuildContext] as well as the `showMenu` function to
  /// pass to any custom button widget.
  final PullDownMenuButtonBuilder buttonBuilder;

  /// Called when the user dismisses the pull-down menu.
  final PullDownMenuCanceled? onCanceled;

  /// Whether the pull-down menu is positioned above, over, or under the
  /// [buttonBuilder].
  ///
  /// Defaults to [PullDownMenuPosition.automatic] which makes the
  /// pull-down menu appear directly under or above the button that was used to
  /// create it (based on the side that has more space available).
  final PullDownMenuPosition position;

  /// Whether the pull-down menu orders its items from [itemBuilder] in a
  /// downward or upwards way.
  ///
  /// Defaults to [PullDownMenuItemsOrder.downwards].
  final PullDownMenuItemsOrder itemsOrder;

  /// Whether the pull-down menu is anchored to the center, left, or right side
  /// of the [buttonBuilder].
  ///
  /// If `null` no anchoring will be involved.
  ///
  /// Defaults to `null`.
  final PullDownMenuAnchor? buttonAnchor;

  /// Additional horizontal offset for the pull-down menu if the menu's desired
  /// position is not in the central third of the screen.
  ///
  /// If the menu's desired position is in the right side of the screen,
  /// [menuOffset] is added to said position (menu moves to the right). If the
  /// menu's desired position is in the left side of the screen, [menuOffset]
  /// is subtracted from said position (menu moves to the left).
  ///
  /// Consider using [buttonAnchor] if you want to offset the menu for a large
  /// amount of px.
  ///
  /// Defaults to 16px.
  final double menuOffset;

  /// A scroll controller that can be used to control the scrolling of the
  /// [itemBuilder] in the menu.
  ///
  /// If `null`, uses an internally created [ScrollController].
  final ScrollController? scrollController;

  /// Theme of the route used to display pull-down menu launched from this
  /// [PullDownButton].
  ///
  /// If this property is null, then [PullDownMenuRouteTheme] from
  /// [PullDownButtonTheme.routeTheme] is used.
  ///
  /// If that's null, then [PullDownMenuRouteTheme.defaults] is used.
  final PullDownMenuRouteTheme? routeTheme;

  /// Custom animation for [buttonBuilder] when the pull-down menu is opening or
  /// closing.
  ///
  /// Defaults to [defaultAnimationBuilder] which applies opacity on
  /// [buttonBuilder] as it is in iOS.
  ///
  /// If this property is null, then no animation will be used.
  final PullDownButtonAnimationBuilder? animationBuilder;

  /// Custom animation alignment used to override default one.
  ///
  /// This is useful for cases when default animation alignment is not suitable
  /// enough, for example in cases when its needed to "contain" menu in a
  /// specific part of the screen.
  ///
  /// It is also recommended to change [menuOffset] and / or [buttonAnchor] to
  /// reach expected results.
  ///
  /// All examples assume:
  /// * Menu is located in the left third of the screen on a wide display,
  /// such as tablet or desktop.
  /// * Menu is located in top half of the screen.
  /// * Default animation alignment resolves to [Alignment.topLeft].
  ///
  /// For example, to "flip" menu animation:
  ///
  /// ```dart
  /// PullDownButton(
  ///   itemBuilder: ...,
  ///   buttonBuilder: ...,
  ///   // ignore: invalid_use_of_internal_member
  ///   menuOffset: PullDownMenuRouteTheme.resolve(
  ///         context,
  ///         routeTheme: null,
  ///       ).width!,
  ///   animationAlignmentOverride: Alignment.topRight,
  ///   buttonAnchor: PullDownMenuAnchor.end,
  /// )
  /// ```
  ///
  /// In the example below, menu gets "moved" by the its width to the left to
  /// align its right side with [buttonBuilder] and
  /// [animationAlignmentOverride] is used to override the default animation
  /// alignment to one that is correct for this specific case.
  ///
  /// See also:
  ///
  /// * [PullDownMenuRoute.animationAlignment], the default animation alignment
  /// prediction algorithm.
  @experimental
  final Alignment? animationAlignmentOverride;

  /// Whether to use the root navigator to show the pull-down menu.
  ///
  /// Defaults to `false`.
  ///
  /// This property allows to show the pull-down menu on the root navigator
  /// instead of the current navigator, useful for nested navigation scenarios
  /// where the popup menu wouldn't be visible or would be clipped by the
  /// parent navigators.
  final bool useRootNavigator;

  /// Optional route settings for the pull-down menu.
  ///
  /// See [RouteSettings] for details.
  final RouteSettings? routeSettings;

  /// Default animation builder for [animationBuilder].
  ///
  /// If [state] is [PullDownButtonAnimationState.opened], apply opacity
  /// on [child] as it is in iOS.
  static Widget defaultAnimationBuilder(
    BuildContext context,
    PullDownButtonAnimationState state,
    Widget child,
  ) {
    final bool isOpen = state.isOpen;

    // All of the values where eyeballed using the iOS 16 Simulator.
    return AnimatedOpacity(
      opacity: isOpen ? 0.4 : 1,
      duration: Duration(milliseconds: isOpen ? 100 : 200),
      curve: isOpen ? Curves.fastLinearToSlowEaseIn : Curves.easeIn,
      child: child,
    );
  }

  @override
  State<PullDownButton> createState() => _PullDownButtonState();
}

class _PullDownButtonState extends State<PullDownButton> {
  PullDownButtonAnimationState state = PullDownButtonAnimationState.closed;

  Future<void> showButtonMenu() async {
    final NavigatorState navigator = Navigator.of(
      context,
      rootNavigator: widget.useRootNavigator,
    );

    final RenderBox overlay = navigator.overlay!.context.currentRenderBox;
    Rect button = context.getRect(ancestor: overlay);

    if (widget.buttonAnchor != null) {
      button = _anchorToButtonPart(context, button, widget.buttonAnchor!);
    }

    final Alignment animationAlignment =
        widget.animationAlignmentOverride ??
        PullDownMenuRoute.animationAlignment(context, button);

    final List<Widget> items = widget.itemBuilder(context);

    if (items.isEmpty) {
      return;
    }

    final bool hasLeading = MenuConfig.menuHasLeading(items);

    setState(() => state = PullDownButtonAnimationState.opened);

    final VoidCallback? action = await _showMenu<VoidCallback>(
      context: context,
      items: items,
      buttonRect: button,
      menuPosition: widget.position,
      itemsOrder: widget.itemsOrder,
      routeTheme: widget.routeTheme,
      hasLeading: hasLeading,
      animationAlignment: animationAlignment,
      menuOffset: widget.menuOffset,
      scrollController: widget.scrollController,
      useRootNavigator: widget.useRootNavigator,
      routeSettings: widget.routeSettings,
    );

    if (!mounted) {
      return;
    }

    setState(() => state = PullDownButtonAnimationState.closed);

    if (action != null) {
      action.call();
    } else {
      widget.onCanceled?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget buttonBuilder = widget.buttonBuilder(context, showButtonMenu);

    return widget.animationBuilder?.call(context, state, buttonBuilder) ??
        buttonBuilder;
  }
}

/// Displays a pull-down menu with [items] at [position].
///
/// [items] should be not empty for the menu to be shown.
///
/// If [items] contain at least one tappable menu item of type
/// [PullDownMenuItem.selectable] all of [PullDownMenuItem]s should also be of
/// type [PullDownMenuItem.selectable].
///
/// See https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons
///
/// In order to achieve it all [PullDownMenuItem]s will automatically switch
/// to the "selectable" view.
///
/// Desired [position] is used to align the top of the menu with the top of the
/// [position] rectangle.
///
/// [itemsOrder] is used to define how the menu will order its [items] depending
/// on the calculated menu's position. Defaults to
/// [PullDownMenuItemsOrder.downwards].
///
/// [menuOffset] is used to define additional horizontal offset for
/// the pull-down menu if the menu's desired position is not in the central
/// third of the screen. Defaults to 16px.
///
/// [scrollController] can be used to control the scrolling of the
/// [items] in the menu. If `null`, uses an internally created
/// [ScrollController].
///
/// [onCanceled] is called when the user dismisses the pull-down menu.
///
/// [routeTheme] is used to define the theme of the route used to display
/// the pull-down menu launched from this function.
///
/// [useRootNavigator] is used to determine whether to use the root navigator
/// to show the pull-down menu. Defaults to `false`.
///
/// Use [routeSettings] to set optional route settings for the pull-down menu.
///
/// See also:
///
/// * [PullDownMenuItem], a pull-down menu entry for a simple action.
/// * [PullDownMenuItem.selectable], a pull-down menu entry for a selection
///   action.
/// * [PullDownMenuDivider], a pull-down menu entry for a large divider.
/// * [PullDownMenuTitle], a pull-down menu entry for a menu title.
/// * [PullDownMenuActionsRow], a more compact way to show multiple pull-down
///   menu entries for a simple action.
/// * [PullDownButtonTheme], a pull-down button and menu theme configuration.
/// * [PullDownButton], a default way of displaying a pull-down menu.
/// * [showMenu], a material design alternative.
/// * [PullDownMenu], another alternative way of displaying a pull-down
///   menu.
Future<void> showPullDownMenu({
  required BuildContext context,
  required List<Widget> items,
  required Rect position,
  PullDownMenuItemsOrder itemsOrder = PullDownMenuItemsOrder.downwards,
  double menuOffset = 16,
  ScrollController? scrollController,
  PullDownMenuCanceled? onCanceled,
  PullDownMenuRouteTheme? routeTheme,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) async {
  if (items.isEmpty) {
    return;
  }

  final bool hasLeading = MenuConfig.menuHasLeading(items);

  final VoidCallback? action = await _showMenu<VoidCallback>(
    context: context,
    items: items,
    buttonRect: position,
    menuPosition: PullDownMenuPosition.automatic,
    itemsOrder: itemsOrder,
    routeTheme: routeTheme,
    hasLeading: hasLeading,
    animationAlignment: PullDownMenuRoute.animationAlignment(context, position),
    menuOffset: menuOffset,
    scrollController: scrollController,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );

  if (action != null) {
    action.call();
  } else {
    onCanceled?.call();
  }
}

/// Is used internally by [PullDownButton] and [showPullDownMenu] to show
/// the pull-down menu.
Future<VoidCallback?> _showMenu<VoidCallback>({
  required BuildContext context,
  required Rect buttonRect,
  required List<Widget> items,
  required PullDownMenuPosition menuPosition,
  required PullDownMenuItemsOrder itemsOrder,
  required PullDownMenuRouteTheme? routeTheme,
  required bool hasLeading,
  required Alignment animationAlignment,
  required double menuOffset,
  required ScrollController? scrollController,
  required bool useRootNavigator,
  required RouteSettings? routeSettings,
}) {
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );

  return navigator.push(
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
      menuOffset: menuOffset,
      scrollController: scrollController,
      settings: routeSettings,
    ),
  );
}

/// "Anchors" menu to specific [buttonRect] side.
///
/// [anchor] is a side to which it is required to "anchor".
Rect _anchorToButtonPart(
  BuildContext context,
  Rect buttonRect,
  PullDownMenuAnchor anchor,
) {
  final TextDirection textDirection = Directionality.of(context);

  final double side = switch (anchor) {
    PullDownMenuAnchor.start when textDirection == TextDirection.ltr =>
      buttonRect.left,
    PullDownMenuAnchor.start => buttonRect.right,
    PullDownMenuAnchor.center => buttonRect.center.dx,
    PullDownMenuAnchor.end when textDirection == TextDirection.ltr =>
      buttonRect.right,
    PullDownMenuAnchor.end => buttonRect.left,
  };

  return Rect.fromLTRB(
    side,
    buttonRect.top,
    side,
    buttonRect.bottom,
  );
}

/// Returns a barrier label for [PullDownMenuRoute].
String _barrierLabel(BuildContext context) {
  // Use this instead of `MaterialLocalizations.of(context)` because
  // [MaterialLocalizations] might be null in some cases.
  final MaterialLocalizations? materialLocalizations =
      Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);

  // Use this instead of `CupertinoLocalizations.of(context)` because
  // [CupertinoLocalizations] might be null in some cases.
  final CupertinoLocalizations? cupertinoLocalizations =
      Localizations.of<CupertinoLocalizations>(context, CupertinoLocalizations);

  // If both localizations are null, fallback to
  // [DefaultMaterialLocalizations().modalBarrierDismissLabel].
  return materialLocalizations?.modalBarrierDismissLabel ??
      cupertinoLocalizations?.modalBarrierDismissLabel ??
      const DefaultMaterialLocalizations().modalBarrierDismissLabel;
}
