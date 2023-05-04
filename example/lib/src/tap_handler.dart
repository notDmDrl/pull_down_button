import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

// ignore_for_file: avoid_print, avoid_redundant_argument_values

@immutable
class TapHandler extends StatelessWidget {
  const TapHandler({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: '.tapHandler',
        ),
        child: ListView(
          children: [
            LabeledExample(
              label: 'PullDownMenuItem.defaultTapHandler',
              items: [
                PullDownMenuItem(
                  onTap: () =>
                      print('This action is called after menu is popped'),
                  // A default behaviour
                  tapHandler: PullDownMenuItem.defaultTapHandler,
                  title: 'Pop menu and call [onTap]',
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.delayedTapHandler',
              items: [
                PullDownMenuItem(
                  onTap: () => print(
                    'This action is called after menu is popped '
                    'and animation ended',
                  ),
                  // A delayed behaviour
                  tapHandler: PullDownMenuItem.delayedTapHandler,
                  title: 'Pop, wait for animation to end and call [onTap]',
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuItem.noPopTapHandler',
              items: [
                PullDownMenuItem(
                  onTap: () =>
                      print('This action is called without menu being popped'),
                  // A no pop behaviour
                  tapHandler: PullDownMenuItem.noPopTapHandler,
                  title: 'Call [onTap]',
                ),
              ],
            ),
            LabeledExample(
              label: 'Custom "Don\'t call anything" behaviour',
              items: [
                PullDownMenuItem(
                  onTap: () => print('This action will never be called'),
                  // A "do nothing" behaviour
                  tapHandler: (context, onTap) => {},
                  title: "Don't call anything",
                ),
              ],
            ),
          ],
        ),
      );
}
