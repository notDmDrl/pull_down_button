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
            backgroundColor: colorScheme.surface,
            dividerColor: colorScheme.outline,
            largeDividerColor: colorScheme.outlineVariant,
            destructiveColor: colorScheme.error,
            textStyle: TextStyle(
              fontSize: 17,
              fontFamily: '.SF UI Text',
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              textBaseline: TextBaseline.alphabetic,
            ),
            iconActionTextStyle: TextStyle(
              fontFamily: '.SF UI Text',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.3,
              textBaseline: TextBaseline.alphabetic,
            ),
            widthConfiguration: const PullDownMenuWidthConfiguration(280),
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
