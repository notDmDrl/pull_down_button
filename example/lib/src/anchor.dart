import 'package:example/src/example_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

@immutable
class Anchor extends StatelessWidget {
  const Anchor({super.key});

  static List<PullDownMenuItem> _itemBuilder(BuildContext context) => [
        PullDownMenuItem(
          onTap: () {},
          title: 'Add to favorites',
          icon: CupertinoIcons.star,
        ),
      ];

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuAnchor',
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final anchor in PullDownMenuAnchor.values)
                  PullDownButton(
                    itemBuilder: _itemBuilder,
                    buttonAnchor: anchor,
                    buttonBuilder: (context, showMenu) =>
                        CupertinoButton.filled(
                      onPressed: showMenu,
                      pressedOpacity: 1,
                      child: Text(anchor.toString()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
