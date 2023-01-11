import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'PullDownMenuTitle',
        pullDownButton: PullDownButton(
          itemBuilder: (context) => [
            const PullDownMenuTitle(
              title: Text('Menu title'),
            ),
            const PullDownMenuDivider(),
            PullDownMenuItem(
              onTap: () {},
              title: 'Add to favorites',
              icon: CupertinoIcons.star,
            ),
          ],
          buttonBuilder: ExampleButton.builder,
        ),
      );
}
