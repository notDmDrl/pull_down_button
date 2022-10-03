// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'item_examples.dart';
import 'setup.dart';

/// This file includes basic example for [PullDownButton] that uses all of
/// available menu items and [PullDownMenuPosition.automatic].
///
/// For more specific examples (per menu item, theming, positioning) check
/// [ItemExamples] on [GitHub](https://github.com/notDmDrl/pull_down_button/tree/main/example/lib)
void main() {
  runApp(const MyApp());
}

@immutable
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    final edgeInsets = MediaQuery.of(context).padding;
    final padding = EdgeInsets.only(
      left: 16 + edgeInsets.left,
      top: edgeInsets.top + 24,
      right: 16 + edgeInsets.right,
      bottom: 24 + edgeInsets.bottom,
    );

    return ListView.separated(
      padding: padding,
      reverse: true,
      itemBuilder: (context, index) {
        final isSender = index.isEven;

        return Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: ExampleMenu(
            position: PullDownMenuPosition.automatic,
            applyOpacity: false,
            builder: (_, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: _MessageExample(isSender: isSender),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: 20,
    );
  }
}

@immutable
class ExampleMenu extends StatelessWidget {
  const ExampleMenu({
    super.key,
    required this.position,
    required this.builder,
    this.applyOpacity = true,
  });

  final PullDownMenuPosition position;
  final PullDownMenuButtonBuilder builder;
  final bool applyOpacity;

  @override
  Widget build(BuildContext context) => PullDownButton(
        itemBuilder: (context) => [
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
          SelectablePullDownMenuItem(
            title: 'Grid',
            selected: true,
            onTap: () {},
            icon: CupertinoIcons.square_grid_2x2,
          ),
          const PullDownMenuDivider(),
          SelectablePullDownMenuItem(
            title: 'List',
            selected: false,
            onTap: () {},
            icon: CupertinoIcons.list_bullet,
          ),
          const PullDownMenuDivider.large(),
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
        applyOpacity: applyOpacity,
        position: position,
        buttonBuilder: builder,
      );
}

// Eyeballed message box from iMessage
@immutable
class _MessageExample extends StatelessWidget {
  const _MessageExample({
    required this.isSender,
  });

  final bool isSender;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 267,
        child: Material(
          color: isSender
              ? CupertinoColors.systemBlue.resolveFrom(context)
              : CupertinoColors.systemFill.resolveFrom(context),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              isSender
                  ? 'How’s next Tuesday? Can’t wait to see you! 🤗'
                  : 'Let’s get lunch! When works for you? 😋',
              style: TextStyle(
                fontSize: 17,
                height: 22 / 17,
                letterSpacing: -0.41,
                fontFamily: '.SF Pro Text',
                color: isSender
                    ? CupertinoColors.label.darkColor
                    : CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
        ),
      );
}
