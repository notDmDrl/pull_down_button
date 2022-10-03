import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class ThemingDefault extends StatelessWidget {
  const ThemingDefault({super.key});

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'Default theme',
        pullDownButton: PullDownButton(
          itemBuilder: ExampleScaffold.exampleItems,
          buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
        ),
      );
}
