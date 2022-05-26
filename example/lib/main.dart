import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;

  void onThemeModeChange() {
    setState(() {
      if (mode == ThemeMode.light) {
        mode = ThemeMode.dark;
      } else {
        mode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pull-Down button demo',
        theme: ThemeData(
          cupertinoOverrideTheme: const CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.systemBackground,
            barBackgroundColor: CupertinoDynamicColor.withBrightness(
              color: Color(0xF0F9F9F9),
              darkColor: Color(0xF01D1D1D),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          cupertinoOverrideTheme: const CupertinoThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: CupertinoColors.systemBackground,
            barBackgroundColor: CupertinoDynamicColor.withBrightness(
              color: Color(0xF0F9F9F9),
              darkColor: Color(0xF01D1D1D),
            ),
          ),
        ),
        themeMode: mode,
        home: MyHomePage(onThemeModeChange: onThemeModeChange),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.onThemeModeChange});

  final GestureTapCallback onThemeModeChange;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            onPressed: onThemeModeChange,
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.sun_max_fill),
          ),
          middle: Text(
            'Pull-down button example',
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.label,
                context,
              ),
            ),
          ),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: PullDownButtonPositionUnder(),
        ),
      );
}

@immutable
class PullDownButtonPositionUnder extends StatelessWidget {
  const PullDownButtonPositionUnder({super.key});

  void action() {}
  void action2() {}
  void deleteAction() {}

  @override
  Widget build(BuildContext context) => PullDownButton(
        itemBuilder: (context) => [
          const PullDownMenuTitle(title: Text('Pull-Down menu')),
          const PullDownMenuDivider(),
          SelectablePullDownMenuItem(
            title: 'Order by size',
            selected: true,
            onTap: () => action(),
            icon: CupertinoIcons.chevron_down,
          ),
          const PullDownMenuDivider(),
          SelectablePullDownMenuItem(
            title: 'Order by weight',
            selected: false,
            onTap: () => action2(),
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            title: 'Delete',
            icon: CupertinoIcons.delete,
            onTap: () => deleteAction(),
            isDestructive: true,
          ),
        ],
        position: PullDownMenuPosition.under,
        buttonBuilder: (context, showMenu) => CupertinoButton(
          onPressed: showMenu,
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis_circle),
        ),
      );
}
