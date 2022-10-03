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
                PullDownMenuIconAction(
                  onTap: () {},
                  title: 'Cut',
                  icon: CupertinoIcons.scissors,
                ),
                PullDownMenuIconAction(
                  onTap: () {},
                  title: 'Copy',
                  icon: CupertinoIcons.doc_on_doc,
                ),
                PullDownMenuIconAction(
                  onTap: () {},
                  title: 'Paste',
                  icon: CupertinoIcons.doc_on_clipboard,
                ),
                PullDownMenuIconAction(
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
                PullDownMenuIconAction(
                  enabled: false,
                  onTap: () {},
                  title: 'Inbox',
                  icon: CupertinoIcons.tray_arrow_down,
                ),
                PullDownMenuIconAction(
                  onTap: () {},
                  title: 'Archive',
                  icon: CupertinoIcons.archivebox,
                ),
                PullDownMenuIconAction(
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
