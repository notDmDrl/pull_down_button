import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class AnimationBuilder extends StatelessWidget {
  const AnimationBuilder({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: '.animationBuilder',
        ),
        child: ListView(
          children: [
            const LabeledExample(
              label: 'Opacity animation',
              // We want to see that this was achieved with the
              // [defaultAnimationBuilder]
              // ignore: avoid_redundant_argument_values
              animationBuilder: PullDownButton.defaultAnimationBuilder,
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            const LabeledExample(
              label: 'No opacity animation',
              animationBuilder: null,
              items: [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            LabeledExample(
              label: 'Slide animation',
              animationBuilder: (context, state, child) {
                final isPressed = state.isOpen;

                return AnimatedSlide(
                  offset: isPressed ? const Offset(0.3, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              },
              items: const [
                PullDownMenuItem(
                  onTap: noAction,
                  title: 'Title',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
          ],
        ),
      );
}
