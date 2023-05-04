import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Anchor extends StatelessWidget {
  const Anchor({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuAnchor',
        ),
        child: ListView(
          children: [
            for (final anchor in PullDownMenuAnchor.values)
              LabeledExample(
                label: anchor.toString(),
                anchor: anchor,
                items: const [
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
