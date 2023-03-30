import 'package:example/src/example_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

// ignore_for_file:  avoid_redundant_argument_values

@immutable
class AnimationBuilder extends StatelessWidget {
  const AnimationBuilder({super.key});

  static List<PullDownMenuItem> _itemBuilder(BuildContext context) => [
        PullDownMenuItem(
          onTap: () {},
          title: 'Add to favorites',
          icon: CupertinoIcons.star,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: ExampleScaffoldNavigationBar(
        title: 'PullDownButton.animationBuilder',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PullDownButton(
                itemBuilder: _itemBuilder,
                animationBuilder: PullDownButton.defaultAnimationBuilder,
                buttonBuilder: (context, showMenu) => CupertinoButton.filled(
                  onPressed: showMenu,
                  pressedOpacity: 1,
                  child: const Text('Opacity animation'),
                ),
              ),
              PullDownButton(
                itemBuilder: _itemBuilder,
                animationBuilder: null,
                buttonBuilder: (context, showMenu) => CupertinoButton.filled(
                  onPressed: showMenu,
                  pressedOpacity: 1,
                  child: const Text('No opacity animation'),
                ),
              ),
              PullDownButton(
                itemBuilder: _itemBuilder,
                animationBuilder: (context, state, child) {
                  final isPressed =
                      state == PullDownButtonAnimationState.opened;

                  return AnimatedScale(
                    scale: isPressed ? 0.5 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: child,
                  );
                },
                buttonBuilder: (context, showMenu) => CupertinoButton.filled(
                  onPressed: showMenu,
                  pressedOpacity: 1,
                  child: const Text('Scale animation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
