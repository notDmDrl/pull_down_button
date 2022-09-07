import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:pull_down_button/src/theme/default_theme.dart';

// Generate theme based on Material 3 guidelines & colorscheme.
PullDownButtonTheme theme(ColorScheme scheme) => PullDownButtonTheme(
      backgroundColor: ElevationOverlay.applySurfaceTint(
        scheme.surface,
        scheme.surfaceTint,
        6,
      ).withAlpha(0xc8),
      dividerColor: scheme.outline,
      largeDividerColor: scheme.onSurfaceVariant,
      destructiveColor: scheme.error,
      iconSize: 24,
      checkmark: Icons.check,
      checkmarkWeight: FontWeight.w400,
      checkmarkSize: 24,
      textStyle: TextStyle(
        fontFamily: 'Roboto',
        color: scheme.onSurface,
        fontSize: 14,
        height: 1.43,
        fontWeight: FontWeight.w500,
      ),
    );

void main() {
  test('PullDownButtonTheme copyWith, ==, hashCode basics', () {
    expect(const PullDownButtonTheme(), const PullDownButtonTheme().copyWith());
    expect(
      const PullDownButtonTheme().hashCode,
      const PullDownButtonTheme().copyWith().hashCode,
    );
  });

  test('PullDownButtonTheme null fields by default', () {
    const theme = PullDownButtonTheme();
    expect(theme.backgroundColor, null);
    expect(theme.dividerColor, null);
    expect(theme.largeDividerColor, null);
    expect(theme.destructiveColor, null);
    expect(theme.iconSize, null);
    expect(theme.checkmark, null);
    expect(theme.checkmarkWeight, null);
    expect(theme.checkmarkSize, null);
    expect(theme.textStyle, null);
    expect(theme.titleStyle, null);
    expect(theme.widthConfiguration, null);
    expect(theme.applyOpacity, null);
    expect(theme.onHoverColor, null);
    expect(theme.onHoverTextStyle, null);
  });

  testWidgets('PullDownButtonTheme implements debugFillProperties',
      (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const PullDownButtonTheme(
      backgroundColor: Color(0xFFFFFFFF),
      iconSize: 24,
      textStyle: TextStyle(color: Color(0xffffffff)),
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(description, <String>[
      'backgroundColor: Color(0xffffffff)',
      'iconSize: 24.0',
      'textStyle: TextStyle(inherit: true, color: Color(0xffffffff))',
    ]);
  });

  testWidgets('Passing no PullDownButtonTheme returns defaults',
      (tester) async {
    final Key pullDownButton = UniqueKey();
    final Key pullDownApp = UniqueKey();
    final Key pullDownItem = UniqueKey();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(),
        key: pullDownApp,
        home: Center(
          child: PullDownButton(
            key: pullDownButton,
            itemBuilder: (context) => [
              const PullDownMenuTitle(
                title: Text('Title'),
              ),
              PullDownMenuItem(
                key: pullDownItem,
                title: 'Item',
                onTap: () {},
              ),
            ],
            buttonBuilder: (context, showMenu) => TextButton(
              onPressed: showMenu,
              child: const Text('Show menu'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(pullDownButton));
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.text('Show menu'));

    final defaults = PullDownButtonThemeDefaults(context);

    // find [ColoredBox] that is used to create pull-down menu surface.
    final button = tester.widget<ColoredBox>(
      find
          .descendant(
            of: find.byKey(pullDownApp),
            matching: find.byType(ColoredBox),
          )
          .last,
    );
    expect(button.color, defaults.backgroundColor);

    // find [PullDownMenuItem]s [DefaultTextStyle].
    final text = tester.widget<DefaultTextStyle>(
      find
          .descendant(
            of: find.byKey(pullDownItem),
            matching: find.byType(DefaultTextStyle),
          )
          .last,
    );
    expect(text.style.fontFamily, '.SF UI Text');
    expect(
      text.style.color,
      CupertinoDynamicColor.resolve(CupertinoColors.label, context),
    );
  });

  testWidgets('PullDownButton uses values from PullDownButtonTheme',
      (tester) async {
    final Key pullDownButton = UniqueKey();
    final Key pullDownApp = UniqueKey();
    final Key pullDownItem = UniqueKey();

    final scheme = ColorScheme.fromSeed(seedColor: Colors.red);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: scheme, extensions: [theme(scheme)]),
        key: pullDownApp,
        home: Center(
          child: PullDownButton(
            key: pullDownButton,
            itemBuilder: (context) => [
              const PullDownMenuTitle(
                title: Text('Title'),
              ),
              PullDownMenuItem(
                key: pullDownItem,
                title: 'Item',
                onTap: () {},
              ),
            ],
            buttonBuilder: (context, showMenu) => TextButton(
              onPressed: showMenu,
              child: const Text('Show menu'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(pullDownButton));
    await tester.pumpAndSettle();

    // find [ColoredBox] that is used to create pull-down menu surface.
    final button = tester.widget<ColoredBox>(
      find
          .descendant(
            of: find.byKey(pullDownApp),
            matching: find.byType(ColoredBox),
          )
          .last,
    );
    expect(button.color, theme(scheme).backgroundColor);

    // find [PullDownMenuItem]s [DefaultTextStyle].
    final text = tester.widget<DefaultTextStyle>(
      find
          .descendant(
            of: find.byKey(pullDownItem),
            matching: find.byType(DefaultTextStyle),
          )
          .last,
    );
    expect(text.style.fontFamily, theme(scheme).textStyle?.fontFamily);
    expect(
      text.style.color,
      theme(scheme).textStyle?.color,
    );
  });

  testWidgets('PullDownButton uses values from PullDownButtonInheritedTheme',
      (tester) async {
    final Key pullDownButton = UniqueKey();
    final Key pullDownApp = UniqueKey();
    final Key pullDownItem = UniqueKey();
    final Key pullDownDivider = UniqueKey();

    const theme = PullDownButtonTheme(
      backgroundColor: Colors.grey,
      iconSize: 24,
      dividerColor: Colors.black,
    );

    await tester.pumpWidget(
      CupertinoApp(
        key: pullDownApp,
        builder: (context, child) => PullDownButtonInheritedTheme(
          data: theme,
          child: child!,
        ),
        home: Center(
          child: PullDownButton(
            key: pullDownButton,
            itemBuilder: (context) => [
              const PullDownMenuTitle(
                title: Text('Title'),
              ),
              PullDownMenuDivider(key: pullDownDivider),
              PullDownMenuItem(
                key: pullDownItem,
                title: 'Item',
                onTap: () {},
              ),
            ],
            buttonBuilder: (context, showMenu) => TextButton(
              onPressed: showMenu,
              child: const Text('Show menu'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(pullDownButton));
    await tester.pumpAndSettle();

    // find [PullDownMenuItem]s [DefaultTextStyle].
    final divider = tester.widget<Divider>(
      find
          .descendant(
            of: find.byKey(pullDownDivider),
            matching: find.byType(Divider),
          )
          .last,
    );
    expect(divider.color, theme.dividerColor);
  });

  testWidgets(
      'PullDownButton uses widgets properties instead of values from '
      'PullDownButtonTheme', (tester) async {
    final Key pullDownButton = UniqueKey();
    final Key pullDownApp = UniqueKey();
    final Key pullDownItem = UniqueKey();

    final scheme = ColorScheme.fromSeed(seedColor: Colors.red);

    const background = Colors.blue;

    const textStyle = TextStyle(color: Colors.white);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: scheme, extensions: [theme(scheme)]),
        key: pullDownApp,
        home: Center(
          child: PullDownButton(
            backgroundColor: background,
            key: pullDownButton,
            itemBuilder: (context) => [
              const PullDownMenuTitle(
                title: Text('Title'),
              ),
              PullDownMenuItem(
                onTap: () {},
                key: pullDownItem,
                title: 'Item',
                textStyle: textStyle,
              ),
            ],
            buttonBuilder: (context, showMenu) => TextButton(
              onPressed: showMenu,
              child: const Text('Show menu'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(pullDownButton));
    await tester.pumpAndSettle();

    // find [ColoredBox] that is used to create pull-down menu surface.
    final button = tester.widget<ColoredBox>(
      find
          .descendant(
            of: find.byKey(pullDownApp),
            matching: find.byType(ColoredBox),
          )
          .last,
    );
    expect(button.color, background);

    // find [PullDownMenuItem]s [DefaultTextStyle].
    final text = tester.widget<DefaultTextStyle>(
      find
          .descendant(
            of: find.byKey(pullDownItem),
            matching: find.byType(DefaultTextStyle),
          )
          .last,
    );
    expect(
      text.style.color,
      textStyle.color,
    );
  });
}
