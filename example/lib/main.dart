// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'item_examples.dart';
import 'setup.dart';

/// This file includes basic example for [PullDownButton] that uses some of
/// available menu items.
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
      top: 24 + edgeInsets.top,
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
            builder: (_, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              pressedOpacity: 1,
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
    required this.builder,
  });

  final PullDownMenuButtonBuilder builder;

  @override
  Widget build(BuildContext context) => PullDownButton(
        itemBuilder: (context) => [
          PullDownMenuHeader(
            leading: ColoredBox(
              color: CupertinoColors.systemBlue.resolveFrom(context),
            ),
            title: 'Profile',
            subtitle: 'Tap to open',
            onTap: () {},
            icon: CupertinoIcons.profile_circled,
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuActionsRow.medium(
            items: [
              PullDownMenuItem(
                onTap: () {},
                title: 'Reply',
                icon: CupertinoIcons.arrowshape_turn_up_left,
              ),
              PullDownMenuItem(
                onTap: () {},
                title: 'Copy',
                icon: CupertinoIcons.doc_on_doc,
              ),
              PullDownMenuItem(
                onTap: () {},
                title: 'Edit',
                icon: CupertinoIcons.pencil,
              ),
            ],
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            onTap: () {},
            title: 'Pin',
            icon: CupertinoIcons.pin,
          ),
          PullDownMenuItem(
            title: 'Forward',
            subtitle: 'Share in different channel',
            onTap: () {},
            icon: CupertinoIcons.arrowshape_turn_up_right,
          ),
          PullDownMenuItem(
            onTap: () {},
            title: 'Delete',
            isDestructive: true,
            icon: CupertinoIcons.delete,
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            title: 'Select',
            onTap: () {},
            icon: CupertinoIcons.checkmark_circle,
          ),
        ],
        animationBuilder: null,
        position: PullDownMenuPosition.automatic,
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
            borderRadius: BorderRadius.all(Radius.circular(18)),
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
