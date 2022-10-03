import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'PullDownMenuDivider',
        pullDownButton: PullDownButton(
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
              onTap: () {},
              icon: CupertinoIcons.list_bullet,
            ),
          ],
          buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
        ),
      );
}
