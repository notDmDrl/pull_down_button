import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'example_scaffold.dart';

@immutable
class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key});

  @override
  Widget build(BuildContext context) => ExampleScaffold(
        title: 'PullDownMenuActionsRow',
        pullDownButton: PullDownButton(
          itemBuilder: (context) => [
            const PullDownMenuTitle(
              title: Text('PullDownMenuActionsRow.small'),
            ),
            const PullDownMenuDivider(),
            PullDownMenuActionsRow.small(
              items: [
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Cut',
                  icon: CupertinoIcons.scissors,
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Copy',
                  icon: CupertinoIcons.doc_on_doc,
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Paste',
                  icon: CupertinoIcons.doc_on_clipboard,
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Look Up',
                  icon: CupertinoIcons.doc_text_search,
                ),
              ],
            ),
            const PullDownMenuDivider.large(),
            const PullDownMenuTitle(
              title: Text('PullDownMenuActionsRow.medium'),
            ),
            const PullDownMenuDivider(),
            PullDownMenuActionsRow.medium(
              items: [
                PullDownMenuItem(
                  enabled: false,
                  onTap: () {},
                  title: 'Inbox',
                  icon: CupertinoIcons.tray_arrow_down,
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Archive',
                  icon: CupertinoIcons.archivebox,
                ),
                PullDownMenuItem(
                  onTap: () {},
                  title: 'Trash',
                  isDestructive: true,
                  icon: CupertinoIcons.delete,
                ),
              ],
            ),
          ],
          buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
        ),
      );
}
