// ignore_for_file: avoid_redundant_argument_values

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
        title: 'PullDownButton Example',
        theme: ThemeData(
          cupertinoOverrideTheme: const CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
            barBackgroundColor: Color(0xF0F9F9F9),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          cupertinoOverrideTheme: const CupertinoThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
            barBackgroundColor: Color(0xF01D1D1D),
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
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(
      left: 16 + MediaQuery.of(context).padding.left,
      top: MediaQuery.of(context).padding.top +
          kMinInteractiveDimensionCupertino +
          24,
      right: 16 + MediaQuery.of(context).padding.right,
      bottom: 24,
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          onPressed: onThemeModeChange,
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.sun_max_fill),
        ),
        middle: Text(
          'PullDownButton Example',
          style: TextStyle(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.label,
              context,
            ),
          ),
        ),
        trailing: _Example(
          position: PullDownMenuPosition.under,
          builder: (_, showMenu) => CupertinoButton(
            onPressed: showMenu,
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.ellipsis_circle),
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: padding,
              reverse: true,
              itemBuilder: (context, index) {
                final isSender = index.isEven;

                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: _Example(
                    position: PullDownMenuPosition.automatic,
                    applyOpacity: false,
                    builder: (_, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: _MessageExample(isSender: isSender),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: 20,
            ),
          ),
          ColoredBox(
            color: CupertinoColors.systemGrey5.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _Example(
                        position: PullDownMenuPosition.above,
                        builder: (_, showMenu) => CupertinoButton(
                          onPressed: showMenu,
                          child: const Text('Show menu above'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _Example(
                        position: PullDownMenuPosition.over,
                        builder: (_, showMenu) => CupertinoButton(
                          onPressed: showMenu,
                          child: const Text('Show menu over'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// iOS Files app menu replica
@immutable
class _Example extends StatelessWidget {
  const _Example({
    required this.position,
    required this.builder,
    this.applyOpacity = true,
  });

  final PullDownMenuPosition position;
  final PullDownMenuButtonBuilder builder;
  final bool applyOpacity;

  @override
  Widget build(BuildContext context) => PullDownButton(
        itemBuilder: (context) => [
          PullDownMenuItem(
            enabled: false,
            title: 'Select',
            onTap: () {},
            icon: CupertinoIcons.checkmark_circle,
          ),
          const PullDownMenuDivider(),
          PullDownMenuItem(
            title: 'Connect to remote server',
            onTap: () {},
            icon: CupertinoIcons.cloud_upload,
          ),
          const PullDownMenuDivider.large(),
          SelectablePullDownMenuItem(
            title: 'Grid',
            selected: true,
            onTap: () {},
            icon: CupertinoIcons.square_grid_2x2,
          ),
          const PullDownMenuDivider(),
          SelectablePullDownMenuItem(
            title: 'List',
            selected: false,
            onTap: () {},
            icon: CupertinoIcons.list_bullet,
          ),
          const PullDownMenuDivider.large(),
          ...PullDownMenuDivider.wrapWithDivider([
            SelectablePullDownMenuItem(
              title: 'Name',
              selected: false,
              onTap: () {},
            ),
            SelectablePullDownMenuItem(
              title: 'Type',
              selected: false,
              onTap: () {},
            ),
            SelectablePullDownMenuItem(
              title: 'Date',
              selected: true,
              icon: CupertinoIcons.chevron_down,
              onTap: () {},
            ),
            SelectablePullDownMenuItem(
              title: 'Size',
              selected: false,
              onTap: () {},
            ),
            SelectablePullDownMenuItem(
              title: 'Tags',
              selected: false,
              onTap: () {},
            ),
          ]),
        ],
        applyOpacity: applyOpacity,
        position: position,
        buttonBuilder: builder,
      );
}

// Eyeballed message box from iMessage
@immutable
class _MessageExample extends StatelessWidget {
  const _MessageExample({
    required this.isSender,
  });

  final bool isSender;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 267,
        child: Material(
          color: isSender
              ? CupertinoColors.systemBlue.resolveFrom(context)
              : CupertinoColors.systemFill.resolveFrom(context),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              isSender
                  ? 'How’s next Tuesday? Can’t wait to see you! 🤗'
                  : 'Let’s get lunch! When works for you? 😋',
              style: TextStyle(
                fontSize: 17,
                height: 22 / 17,
                letterSpacing: -0.41,
                fontFamily: '.SF Pro Text',
                color: isSender
                    ? CupertinoColors.label.darkColor
                    : CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
        ),
      );
}
