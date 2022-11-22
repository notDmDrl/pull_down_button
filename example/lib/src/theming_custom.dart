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

    // For the sake of simplicity, define global theme override
    return Theme(
      data: themeData.copyWith(
        extensions: [
          PullDownButtonTheme(
            routeTheme: PullDownMenuRouteTheme(
              backgroundColor: colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              width: 280,
            ),
            dividerTheme: PullDownMenuDividerTheme(
              dividerColor: colorScheme.outline,
              largeDividerColor: colorScheme.outlineVariant,
            ),
            itemTheme: PullDownMenuItemTheme(
              destructiveColor: colorScheme.error,
              textStyle: TextStyle(
                fontSize: 17,
                height: 22 / 17,
                fontFamily: '.SF UI Text',
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              iconActionTextStyle: TextStyle(
                fontFamily: '.SF UI Text',
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      child: ExampleScaffold(
        title: 'Custom theme',
        pullDownButton: PullDownButton(
          itemBuilder: ExampleScaffold.exampleItems,
          buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
        ),
      ),
    );
  }
}
