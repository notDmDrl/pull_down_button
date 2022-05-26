import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'theme/default_theme.dart';
import 'utils/constants.dart';
import 'utils/route.dart';

/// Used to configure how the [PullDownButton] positions its pull-down menu.
enum PullDownMenuPosition {
  /// Menu is positioned over the anchor.
  over,

  /// Menu is positioned under the anchor.
  under,

  /// Menu is positioned above the anchor.
  above
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
  void Function() showMenu,
);

/// Displays a pull-down menu and animates button to lower opacity when pressed.
@immutable
class PullDownButton extends StatefulWidget {
  /// Creates a button that shows a pull-down menu.
  const PullDownButton({
    super.key,
    required this.itemBuilder,
    required this.buttonBuilder,
    this.onCanceled,
    this.offset = Offset.zero,
    this.position = PullDownMenuPosition.over,
    this.backgroundColor,
  });

  /// Called when the button is pressed to create the items to show in the menu.
  ///
  /// If items contains at least one tappable menu item of type
  /// [SelectablePullDownMenuItem] all of [PullDownMenuItem]s should also be of
  /// type [SelectablePullDownMenuItem].
  ///
  /// See https://developer.apple.com/design/human-interface-guidelines/ios/controls/buttons#pull-down-buttons
  ///
  /// In order to achieve it all [PullDownMenuItem]s will be replaced with
  /// [SelectablePullDownMenuItem] with [SelectablePullDownMenuItem.selected]
  /// set to `false`.
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
  /// When not set, the position defaults to [PullDownMenuPosition.over] which
  /// makes the popup menu appear directly over the button that was used to
  /// create it.
  final PullDownMenuPosition position;

  /// The background color of pull-down menu.
  ///
  /// If this property is null then [PullDownButtonTheme.backgroundColor] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.backgroundColor] is used.
  final Color? backgroundColor;

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

    final items = widget.itemBuilder(context);

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

    if (items.isNotEmpty) {
      if (items.whereType<SelectablePullDownMenuItem>().isNotEmpty) {
        items.forEachIndexed(
          (index, item) {
            if (item.represents && item is! SelectablePullDownMenuItem) {
              items[index] = SelectablePullDownMenuItem.convertFrom(
                item as PullDownMenuItem,
              );
            }
          },
        );
      }

      setState(() => isPressed = true);

      await _showCupertinoMenu(
        context: context,
        items: items,
        position: position,
        backgroundColor: widget.backgroundColor,
        buttonSize: button.size,
        menuPosition: widget.position,
      );

      if (!mounted) return;

      setState(() => isPressed = false);

      widget.onCanceled?.call();
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: isPressed ? 0.5 : 1,
        duration: kMenuDuration,
        curve: kCurve,
        child: widget.buttonBuilder(context, showButtonMenu),
      );
}

Future _showCupertinoMenu({
  required BuildContext context,
  required RelativeRect position,
  required List<PullDownMenuEntry> items,
  required Color? backgroundColor,
  required Size buttonSize,
  required PullDownMenuPosition menuPosition,
}) {
  final navigator = Navigator.of(context);

  return navigator.push(
    PullDownMenuRoute(
      position: position,
      items: items,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      backgroundColor: backgroundColor,
      buttonSize: buttonSize,
      menuPosition: menuPosition,
    ),
  );
}
