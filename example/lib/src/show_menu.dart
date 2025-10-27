import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class ShowPullDownMenu extends StatelessWidget {
  const ShowPullDownMenu({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(title: 'showPullDownMenu'),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (details) async {
                final items = ExampleScaffold.exampleItems(context);

                // possibly not correct way of finding position, but works fine
                // with mouse pointers
                final position = details.globalPosition & Size.zero;

                await showPullDownMenu(
                  context: context,
                  items: items,
                  position: position,
                );
              },
              child: Center(
                child: Text(
                  'Tap anywhere on screen to open menu',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
