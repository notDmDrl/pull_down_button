/// @docImport '/src/pull_down_button.dart';
library;

import 'package:flutter/cupertino.dart';

import '/src/theme/route_theme.dart';
import 'animation.dart';
import 'content_size_category.dart';
import 'item_layout.dart';
import 'menu.dart';
import 'menu_config.dart';
import 'route.dart';

/// Pull-down menu displayed by [PullDownButton] or [showPullDownMenu].
@immutable
class RoutePullDownMenu extends StatelessWidget {
  /// Creates [RoutePullDownMenu].
  const RoutePullDownMenu({
    super.key,
    required this.items,
    required this.routeTheme,
    required this.alignment,
    required this.animation,
    required this.scrollController,
  });

  /// Items to show in the menu.
  final List<Widget> items;

  /// A per-menu custom theme.
  ///
  /// Final theme is resolved using [MenuConfig.ambientThemeOf].
  final PullDownMenuRouteTheme? routeTheme;

  /// An animation provided by [PullDownMenuRoute] for scale, fade, and size
  /// transitions.
  final Animation<double> animation;

  /// The point menu scales from.
  final Alignment alignment;

  /// Is used to define the initial scroll offset of menu's body.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final bool isInAccessibilityMode =
        ContentSizeCategory.isInAccessibilityMode(context);

    final PullDownMenuRouteTheme theme =
        MenuConfig.ambientThemeOf(context).routeTheme;

    final BoxShadow shadow = theme.shadow!;
    final shadowTween = DecorationTween(
      begin: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadow.color.withValues(alpha: 0),
            blurRadius: shadow.blurRadius,
            spreadRadius: shadow.spreadRadius,
          ),
        ],
      ),
      end: BoxDecoration(boxShadow: [shadow]),
    );

    final clampedAnimation = ClampedAnimation(animation);

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: DecoratedBoxTransition(
        decoration: AnimationUtils.shadowTween
            .animate(clampedAnimation)
            .drive(shadowTween),
        child: FadeTransition(
          opacity: clampedAnimation,
          child: MenuDecoration(
            backgroundColor: theme.backgroundColor!,
            borderRadius: theme.borderRadius!,
            borderClipper: theme.borderClipper!,
            child: FadeTransition(
              opacity: clampedAnimation,
              child: AnimatedMenuContainer(
                constraints: BoxConstraints.tightFor(
                  width:
                      isInAccessibilityMode
                          ? theme.accessibilityWidth
                          : theme.width,
                ),
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: clampedAnimation,
                  child: MenuBody(
                    scrollController: scrollController,
                    items: items,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
