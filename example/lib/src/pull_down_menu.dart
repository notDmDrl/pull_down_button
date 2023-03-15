import 'package:example/src/example_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../setup.dart';

@immutable
class PullDownMenuBox extends StatelessWidget {
  const PullDownMenuBox({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'PullDownMenu',
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
        child: SafeArea(
          child: Center(
            child: PullDownMenu(
              items: ExampleScaffold.exampleItems(context),
            ),
          ),
        ),
      );
}
