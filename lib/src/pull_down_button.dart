import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pull_down_button.dart';
import 'utils/constants.dart';
import 'utils/route.dart';

/// Used to configure how the [PullDownButton] positions its pull-down menu.
enum PullDownMenuPosition {
  /// Menu is positioned over an anchor. Will attempt to fill as much space as
  /// possible.
  over,

  /// Menu is positioned under an anchor and is forced to be under an anchor.
  ///
  /// If there is no available space to place menu under an anchor, menu will
  /// be placed above an anchor.
  under,

  /// Menu is positioned above an anchor and is forced to always be above an
  /// anchor.
  ///
  /// If there is no available space to place menu above an anchor, menu will
  /// be placed under an anchor.
  above,

  /// Menu is positioned under or above an anchor depending on side that has
  /// more space available.
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
  /// pass to any custom button widget;
  final PullDownMenuButtonBuilder buttonBuilder;

  /// Called when the user dismisses the pull-down menu.
  final PullDownMenuCanceled? onCanceled;

  /// The offset is applied relative to the initial position
  /// set by the [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  final Offset offset;

  /// Whether the popup menu is positioned over or under the popup menu button.
  ///
  /// [offset] is used to change the position of the popup menu relative to the
  /// position set by this parameter.
  ///
  /// When not set, the position defaults to [PullDownMenuPosition.under] which
  /// makes the popup menu appear directly under the button that was used to
  /// create it.
  final PullDownMenuPosition position;

  /// Theme of route used to display pull-down menu launched from this
  /// [PullDownButton].
  ///
  /// If this property is null then [PullDownMenuRouteTheme] from
  /// [PullDownButtonTheme.routeTheme] is used.
  ///
  /// If that's null then defaults from [PullDownMenuRouteTheme] are used.
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

    if (items.isNotEmpty) {
      final hasSelectable = items.whereType<PullDownMenuItem>().any(
            (element) => element.selected != null,
          );

      setState(() => isPressed = true);

      final action = await _showCupertinoMenu(
        context: context,
        items: items,
        position: position,
        buttonSize: button.size,
        menuPosition: widget.position,
        routeTheme: widget.routeTheme,
        hasSelectable: hasSelectable,
      );

      if (!mounted) return;

      setState(() => isPressed = false);

      if (action != null) {
        action.call();
      } else {
        widget.onCanceled?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = PullDownButtonTheme.of(context);

    final apply = widget.applyOpacity ?? theme?.applyOpacity ?? true;

    final buttonBuilder = widget.buttonBuilder(context, showButtonMenu);

    if (!apply) return buttonBuilder;

    return AnimatedOpacity(
      opacity: isPressed ? 0.5 : 1,
      duration: kMenuDuration,
      curve: kCurve,
      child: buttonBuilder,
    );
  }
}

/// Show menu.
Future<VoidCallback?> _showCupertinoMenu({
  required BuildContext context,
  required RelativeRect position,
  required List<PullDownMenuEntry> items,
  required Size buttonSize,
  required PullDownMenuPosition menuPosition,
  required PullDownMenuRouteTheme? routeTheme,
  required bool hasSelectable,
}) {
  final navigator = Navigator.of(context);

  // Use this instead of `MaterialLocalizations.of(context)` because
  // [MaterialLocalizations] might be null in some cases.
  final materialLocalizations =
      Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);

  // Use this instead of `CupertinoLocalizations.of(context)` because
  // [CupertinoLocalizations] might be null in some cases.
  final cupertinoLocalizations =
      Localizations.of<CupertinoLocalizations>(context, CupertinoLocalizations);

  return navigator.push<VoidCallback>(
    PullDownMenuRoute(
      position: position,
      items: items,
      // If both localizations are null, fallback to
      // [DefaultMaterialLocalizations().modalBarrierDismissLabel].
      barrierLabel: materialLocalizations?.modalBarrierDismissLabel ??
          cupertinoLocalizations?.modalBarrierDismissLabel ??
          const DefaultMaterialLocalizations().modalBarrierDismissLabel,
      routeTheme: routeTheme,
      buttonSize: buttonSize,
      menuPosition: menuPosition,
      capturedThemes: InheritedTheme.capture(
        from: context,
        to: navigator.context,
      ),
      hasSelectable: hasSelectable,
    ),
  );
}
