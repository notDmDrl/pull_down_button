import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class AlignmentOverride extends StatelessWidget {
  const AlignmentOverride({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: '.animationAlignmentOverride',
        ),
        child: SafeArea(
          child: Align(
            alignment: const Alignment(-0.4, -1),
            child: PullDownButton(
              itemBuilder: ExampleScaffold.exampleItems,
              buttonBuilder: ExampleButton.builder,
              // ignore: invalid_use_of_internal_member
              menuOffset: PullDownMenuRouteTheme.resolve(
                context,
                routeTheme: null,
              ).width!,
              animationAlignmentOverride: Alignment.topRight,
              buttonAnchor: PullDownMenuAnchor.end,
            ),
          ),
        ),
      );
}
