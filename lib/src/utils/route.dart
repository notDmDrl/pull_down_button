import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'constants.dart';
import 'menu.dart';
import 'menu_config.dart';

part 'route_layout.dart';

// ignore_for_file: public_member_api_docs

/// Copy of `_PopupMenuRoute` from [PopupMenuButton] implementation since it's
/// private there.
@internal
class PullDownMenuRoute extends PopupRoute<VoidCallback> {
  PullDownMenuRoute({
    required this.position,
    required this.items,
    required this.barrierLabel,
    required this.routeTheme,
    required this.buttonSize,
    required this.menuPosition,
    required this.capturedThemes,
    required this.hasSelectable,
    required this.itemsOrder,
  });

  final List<PullDownMenuEntry> items;
  final CapturedThemes capturedThemes;
  final PullDownMenuRouteTheme? routeTheme;
  final bool hasSelectable;
  final RelativeRect position;
  final Size buttonSize;
  final PullDownMenuPosition menuPosition;
  final PullDownMenuItemsOrder itemsOrder;

  @override
  final String barrierLabel;

  @override
  Animation<double> createAnimation() => CurvedAnimation(
        parent: super.createAnimation(),
        curve: kCurve,
        reverseCurve: kCurveReverse,
      );

  @override
  Duration get transitionDuration => kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget menu = MenuConfig(
      hasLeading: hasSelectable,
      child: ValueListenableBuilder<Alignment>(
        valueListenable: _menuAlignmentNotifier,
        builder: (_, alignment, __) {
          final Iterable<PullDownMenuEntry> orderedItems;

          switch (itemsOrder) {
            case PullDownMenuItemsOrder.downwards:
              orderedItems = items;
              break;
            case PullDownMenuItemsOrder.upwards:
              orderedItems = items.reversed;
              break;
            case PullDownMenuItemsOrder.automatic:
              if (alignment.y == -1) {
                orderedItems = items;
              } else {
                orderedItems = items.reversed;
              }
              break;
          }

          return PullDownMenu(
            items: orderedItems.toList(),
            routeTheme: routeTheme,
            animation: animation,
            alignment: alignment,
          );
        },
      ),
    );

    final mediaQuery = MediaQuery.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (context) => CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            position: position,
            textDirection: Directionality.of(context),
            padding: mediaQuery.padding,
            avoidBounds: _avoidBounds(mediaQuery),
            buttonSize: buttonSize,
            menuPosition: menuPosition,
          ),
          child: capturedThemes.wrap(menu),
        ),
      ),
    );
  }

  static Set<Rect> _avoidBounds(MediaQueryData mediaQuery) =>
      DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
}

// TODO(notDmDrl): replace with something less ugly
final _menuAlignmentNotifier = ValueNotifier(Alignment.topRight);

void _updateMenuAlignment(
  bool? isInRightHalf,
  bool isInBottomHalf,
) {
  final Alignment alignment;

  if (isInRightHalf == null) {
    if (isInBottomHalf) {
      alignment = Alignment.bottomCenter;
    } else {
      alignment = Alignment.topCenter;
    }
  } else {
    if (isInRightHalf && !isInBottomHalf) {
      alignment = Alignment.topRight;
    } else if (!isInRightHalf && !isInBottomHalf) {
      alignment = Alignment.topLeft;
    } else if (isInRightHalf && isInBottomHalf) {
      alignment = Alignment.bottomRight;
    } else if (!isInRightHalf && isInBottomHalf) {
      alignment = Alignment.bottomLeft;
    } else {
      alignment = Alignment.topCenter;
    }
  }

  WidgetsBinding.instance.scheduleFrameCallback(
    (_) => _menuAlignmentNotifier.value = alignment,
  );
}
