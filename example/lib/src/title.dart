import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

// ignore_for_file: avoid_redundant_argument_values

@immutable
class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(title: 'PullDownMenuTitle'),
        child: ListView(
          children: const [
            LabeledExample(
              label: 'Title with start align',
              items: [
                PullDownMenuTitle(
                  title: Text('Menu title'),
                  alignment: PullDownMenuTitleAlignment.start,
                ),
              ],
            ),
            LabeledExample(
              label: 'Title with center align',
              items: [
                PullDownMenuTitle(
                  title: Text('Menu title'),
                  alignment: PullDownMenuTitleAlignment.center,
                ),
              ],
            ),
            LabeledExample(
              label: 'Title with start align + PullDownMenuItem',
              items: [
                PullDownMenuTitle(
                  title: Text('Menu title'),
                  alignment: PullDownMenuTitleAlignment.start,
                ),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'Title with center align + PullDownMenuItem',
              items: [
                PullDownMenuTitle(
                  title: Text('Menu title'),
                  alignment: PullDownMenuTitleAlignment.center,
                ),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'Title with start align + PullDownMenuItem.selectable',
              items: [
                PullDownMenuTitle(
                  title: Text('Menu title'),
                  alignment: PullDownMenuTitleAlignment.start,
                ),
                PullDownMenuItem.selectable(
                  onTap: noAction,
                  selected: true,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'Title with center align + PullDownMenuItem.selectable',
              items: [
                PullDownMenuTitle(
                  title: Text('Menu title'),
                  alignment: PullDownMenuTitleAlignment.center,
                ),
                PullDownMenuItem.selectable(
                  onTap: noAction,
                  selected: true,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            )
          ],
        ),
      );
}
