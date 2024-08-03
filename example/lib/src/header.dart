import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuHeader',
        ),
        child: ListView(
          children: [
            const LabeledExample(
              label: 'PullDownMenuHeader',
              items: [
                PullDownMenuHeader(
                  leading: _Thumbnail(),
                  title: 'Title',
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuHeader with leadingBuilder',
              items: [
                PullDownMenuHeader(
                  leadingBuilder: (context, constraints) => ConstrainedBox(
                    constraints: constraints,
                    child: const FlutterLogo(),
                  ),
                  title: 'Title',
                ),
              ],
            ),
            const LabeledExample(
              label: 'PullDownMenuHeader + subtitle',
              items: [
                PullDownMenuHeader(
                  leading: _Thumbnail(),
                  title: 'Title',
                  subtitle: 'Subtitle',
                ),
              ],
            ),
            const LabeledExample(
              label: 'PullDownMenuHeader + subtitle + onTap',
              items: [
                PullDownMenuHeader(
                  leading: _Thumbnail(),
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle',
                ),
              ],
            ),
            const LabeledExample(
              label: 'PullDownMenuHeader + subtitle + onTap + icon',
              items: [
                PullDownMenuHeader(
                  leading: _Thumbnail(),
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle',
                  icon: CupertinoIcons.square,
                ),
              ],
            ),
            const LabeledExample(
              label: 'PullDownMenuHeader + subtitle + onTap + iconWidget',
              items: [
                PullDownMenuHeader(
                  leading: _Thumbnail(),
                  onTap: noAction,
                  title: 'Title',
                  subtitle: 'Subtitle',
                  iconWidget: CircleAvatar(
                    backgroundColor: CupertinoColors.systemCyan,
                    foregroundColor: CupertinoColors.systemBackground,
                    child: Text('A', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

@immutable
class _Thumbnail extends StatelessWidget {
  const _Thumbnail();

  @override
  Widget build(BuildContext context) => Container(
        color: CupertinoColors.systemOrange.resolveFrom(context),
      );
}
