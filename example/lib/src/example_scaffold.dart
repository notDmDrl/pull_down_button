import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../setup.dart';

@immutable
class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    required this.title,
    required this.pullDownButton,
  });

  final String title;
  final PullDownButton pullDownButton;

  static List<PullDownMenuEntry> exampleItems(BuildContext context) => [
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
        PullDownMenuItem(
          enabled: false,
          title: 'Select',
          onTap: () {},
          icon: CupertinoIcons.checkmark_circle,
        ),
        const PullDownMenuDivider(),
        PullDownMenuItem(
          title: 'Connect to remote server',
          onTap: () {},
          icon: CupertinoIcons.cloud_upload,
        ),
        const PullDownMenuDivider.large(),
        PullDownMenuItem.selectable(
          title: 'Grid',
          selected: true,
          onTap: () {},
          icon: CupertinoIcons.square_grid_2x2,
        ),
        const PullDownMenuDivider(),
        PullDownMenuItem.selectable(
          title: 'List',
          onTap: () {},
          icon: CupertinoIcons.list_bullet,
        ),
        const PullDownMenuDivider.large(),
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
      ];

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            title,
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.label,
                context,
              ),
            ),
          ),
          previousPageTitle: 'Back',
          padding: const EdgeInsetsDirectional.only(end: 8),
          trailing: const CupertinoButton(
            onPressed: onThemeModeChange,
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.sun_max_fill),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              for (final alignment in [
                AlignmentDirectional.centerStart,
                AlignmentDirectional.center,
                AlignmentDirectional.centerEnd
              ])
                Expanded(
                  child: Align(
                    alignment: alignment,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        pullDownButton,
                        pullDownButton,
                        pullDownButton,
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

@immutable
class ExampleButton extends StatelessWidget {
  const ExampleButton({super.key, required this.onTap});

  /// Shortcut constructor to allow easy passing to
  /// [PullDownButton.buttonBuilder] as tear-off:
  ///
  /// ```dart
  /// buttonBuilder: ExampleButton.builder,
  /// ```
  ///
  /// instead of:
  ///
  /// ```dart
  /// buttonBuilder: (_, showMenu) => ExampleButton(onTap: showMenu),
  /// ```
  const ExampleButton.builder(
    BuildContext _,
    this.onTap, {
    super.key,
  });

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        onPressed: onTap,
        pressedOpacity: 1,
        child: const Icon(CupertinoIcons.ellipsis_circle),
      );
}
