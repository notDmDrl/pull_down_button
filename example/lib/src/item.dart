import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Item extends StatelessWidget {
  const Item({super.key});

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'PullDownMenuItem',
        pullDownButton: PullDownButton(
          itemBuilder: (context) => [
            PullDownMenuItem(
              onTap: () {},
              title: 'Add to favorites',
              icon: CupertinoIcons.star,
            ),
          ],
          buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
        ),
      );
}
