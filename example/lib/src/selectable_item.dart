import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class SelectableItem extends StatelessWidget {
  const SelectableItem({super.key});

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'SelectablePullDownMenuItem',
        pullDownButton: PullDownButton(
          itemBuilder: (context) => [
            PullDownMenuItem.selectable(
              title: 'Grid',
              selected: true,
              onTap: () {},
              icon: CupertinoIcons.square_grid_2x2,
            ),
          ],
          buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
        ),
      );
}
