import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'item_examples.dart';
import 'main.dart';

final themeNotifier = ValueNotifier(ThemeMode.light);

void onThemeModeChange() {
  if (themeNotifier.value == ThemeMode.light) {
    themeNotifier.value = ThemeMode.dark;
  } else {
    themeNotifier.value = ThemeMode.light;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, value, child) => MaterialApp(
          title: 'PullDownButton Example',
          theme: ThemeData(
            fontFamily: '.SF Pro Text',
            cupertinoOverrideTheme: const CupertinoThemeData(
              scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
              barBackgroundColor: Color(0xF0F9F9F9),
              applyThemeToAll: true,
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: '.SF Pro Text',
            brightness: Brightness.dark,
            cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
              barBackgroundColor: Color(0xF01D1D1D),
              applyThemeToAll: true,
            ),
          ),
          themeMode: value,
          builder: (context, child) => Directionality(
            textDirection: TextDirection.ltr,
            child: child!,
          ),
          home: child,
        ),
        child: const MyHomePage(),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: const CupertinoButton(
            onPressed: onThemeModeChange,
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.sun_max_fill),
          ),
          middle: Text(
            'PullDownButton',
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.label,
                context,
              ),
            ),
          ),
          trailing: CupertinoButton(
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute<void>(builder: (_) => const ItemExamples()),
            ),
            padding: EdgeInsets.zero,
            child: const Text('Examples'),
          ),
        ),
        child: const Example(),
      );
}
