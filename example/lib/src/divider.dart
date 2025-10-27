import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuDivider',
        ),
        child: ListView(
          children: const [
            LabeledExample(
              label: 'PullDownMenuDivider',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuDivider.large',
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
                PullDownMenuDivider(),
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
          ],
        ),
      );
}
