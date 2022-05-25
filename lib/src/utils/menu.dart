import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart' hide MenuItem;
import 'package:flutter/material.dart' hide MenuItem;

import '../theme/default_theme.dart';
import '../theme/theme.dart';
import 'constants.dart';
import 'menu_item.dart';
import 'route.dart';

// ignore_for_file: public_member_api_docs

// ignore: comment_references
/// Copy of [_PopupMenu] from [PopupMenuButton] implementation since it's
/// private there.
@immutable
@protected
class PullDownMenu extends StatelessWidget {
  const PullDownMenu({
    super.key,
    required this.route,
  });

  final PullDownMenuRoute route;

  @override
  Widget build(BuildContext context) {
    final unit = 1.0 / route.items.length;

    final children = <Widget>[];

    for (var i = 0; i < route.items.length; i += 1) {
      children.add(
        MenuItem(
          onLayout: (size) => route.itemSizes[i] = size,
          child: route.items[i],
        ),
      );
    }

    final height = CurveTween(curve: Interval(0, unit * route.items.length));

    final Widget child = _MenuBody(children: children);

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (context, child) => _Decoration(
        backgroundColor: route.backgroundColor,
        child: Align(
          alignment: AlignmentDirectional.topEnd,
          widthFactor: height.evaluate(route.animation!),
          heightFactor: height.evaluate(route.animation!),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

@immutable
class _Decoration extends StatelessWidget {
  const _Decoration({required this.child, required this.backgroundColor});

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final pullDownButtonThemeData = PullDownButtonTheme.of(context);

    final defaults = PullDownButtonThemeDefaults(context);

    final color = backgroundColor ??
        pullDownButtonThemeData?.backgroundColor ??
        defaults.backgroundColor;

    return ClipRRect(
      borderRadius: kBorderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: kBlurAmount, sigmaY: kBlurAmount),
        child: Material(
          color: color,
          type: MaterialType.card,
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

@immutable
class _MenuBody extends StatelessWidget {
  const _MenuBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: kPopupMenuConstraints,
        child: IntrinsicWidth(
          stepWidth: kMenuWidthStep,
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            label: 'Pull-Down menu',
            child: CupertinoUserInterfaceLevel(
              data: CupertinoUserInterfaceLevelData.elevated,
              child: SingleChildScrollView(
                child: ListBody(children: children),
              ),
            ),
          ),
        ),
      );
}
