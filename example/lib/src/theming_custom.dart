import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

/// Custom theme created from [CupertinoColors.systemBlue].
///
/// [PullDownButtonTheme] parameters are assigned based on Material 3 colors for
/// [PopupMenuButton].
@immutable
class ThemingCustom extends StatelessWidget {
  const ThemingCustom({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: CupertinoColors.systemBlue.resolveFrom(context),
      brightness: themeData.brightness,
    );

    // For the sake of simplicity, define global theme override.
    return Theme(
      data: themeData.copyWith(
        extensions: [
          PullDownButtonTheme(
            routeTheme: PullDownMenuRouteTheme(
              backgroundColor: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderClipper:
                  (radius, child) => ClipRSuperellipse(
                    borderRadius: radius,
                    child: child,
                  ),
              width: 280,
            ),
            dividerTheme: PullDownMenuDividerTheme(
              dividerColor: colorScheme.outlineVariant,
              largeDividerColor: colorScheme.surfaceContainerHighest,
            ),
            itemTheme: PullDownMenuItemTheme(
              destructiveColor: colorScheme.error,
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              subtitleStyle: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
              iconActionTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              onHoverBackgroundColor: colorScheme.onSurface.withValues(
                alpha: 0.08,
              ),
              onHoverTextColor: colorScheme.onSurface,
              onPressedBackgroundColor: colorScheme.onSurface.withValues(
                alpha: 0.1,
              ),
            ),
          ),
        ],
      ),
      child: CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'Custom theme',
        ),
        child: SafeArea(
          child: Center(
            child: PullDownMenu(
              items: ExampleScaffold.exampleItems(context),
            ),
          ),
        ),
      ),
    );
  }
}
