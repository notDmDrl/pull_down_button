import 'package:example/src/example_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

@immutable
class PullDownMenuBox extends StatelessWidget {
  const PullDownMenuBox({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenu',
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
