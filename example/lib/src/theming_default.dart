import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class ThemingDefault extends StatelessWidget {
  const ThemingDefault({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'Default theme',
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
