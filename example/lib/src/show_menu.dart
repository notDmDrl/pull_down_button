import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../setup.dart';
import 'example_scaffold.dart';

@immutable
class ShowPullDownMenu extends StatelessWidget {
  const ShowPullDownMenu({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'showPullDownMenu',
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.label,
                context,
              ),
            ),
          ),
          previousPageTitle: 'Back',
          padding: const EdgeInsetsDirectional.only(end: 8),
          trailing: const CupertinoButton(
            onPressed: onThemeModeChange,
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.sun_max_fill),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (details) async {
                final items = ExampleScaffold.exampleItems(context);

                final screenSize = MediaQuery.of(context).size;

                // possibly not correct way of finding position, but works fine
                // with mouse pointers
                final position = RelativeRect.fromRect(
                  details.globalPosition & Size.zero,
                  Offset.zero & screenSize,
                );

                await showPullDownMenu(
                  context: context,
                  items: items,
                  position: position,
                  itemsOrder: PullDownMenuItemsOrder.automatic,
                  menuPosition: PullDownMenuPosition.automatic,
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
