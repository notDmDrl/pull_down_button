import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Position extends StatelessWidget {
  const Position({super.key, required this.position});

  final PullDownMenuPosition position;

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: '.${position.name}',
        pullDownButton: PullDownButton(
          position: position,
          itemBuilder: ExampleScaffold.exampleItems,
          buttonBuilder: ExampleButton.builder,
        ),
      );
}
