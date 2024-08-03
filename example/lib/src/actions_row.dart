import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: ExampleScaffoldNavigationBar(
          title: 'PullDownMenuActionsRow',
        ),
        child: ListView(
          children: const [
            LabeledExample(
              label: 'PullDownMenuActionsRow.small',
              items: [
                PullDownMenuActionsRow.small(
                  items: [
                    PullDownMenuItem(
                      onTap: noAction,
                      title: 'Cut',
                      icon: CupertinoIcons.scissors,
                    ),
                    PullDownMenuItem(
                      onTap: noAction,
                      title: 'Copy',
                      icon: CupertinoIcons.doc_on_doc,
                    ),
                    PullDownMenuItem(
                      onTap: noAction,
                      title: 'Paste',
                      icon: CupertinoIcons.doc_on_clipboard,
                    ),
                    PullDownMenuItem(
                      onTap: noAction,
                      isDestructive: true,
                      title: 'Delete',
                      icon: CupertinoIcons.delete,
                    ),
                  ],
                ),
              ],
            ),
            LabeledExample(
              label: 'PullDownMenuActionsRow.medium',
              items: [
                PullDownMenuActionsRow.medium(
                  items: [
                    PullDownMenuItem(
                      onTap: noAction,
                      title: 'Cut',
                      icon: CupertinoIcons.scissors,
                    ),
                    PullDownMenuItem(
                      onTap: noAction,
                      title: 'Copy',
                      icon: CupertinoIcons.doc_on_doc,
                    ),
                    PullDownMenuItem(
                      onTap: noAction,
                      title: 'Paste',
                      icon: CupertinoIcons.doc_on_clipboard,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}
