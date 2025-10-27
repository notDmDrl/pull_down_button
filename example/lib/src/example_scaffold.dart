import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../setup.dart';

void noAction() {}

@immutable
class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    required this.title,
    required this.pullDownButton,
  });

  final String title;
  final PullDownButton pullDownButton;

  static List<Widget> exampleItems(BuildContext context) => [
    PullDownMenuHeader(
      leading: ColoredBox(
        color: CupertinoColors.systemBlue.resolveFrom(context),
      ),
      title: 'Profile',
      subtitle: 'Tap to open',
      onTap: () {},
      icon: CupertinoIcons.profile_circled,
    ),
    const PullDownMenuDivider(),
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
    const PullDownMenuDivider(),
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
    const PullDownMenuDivider(),
    PullDownMenuItem(
      title: 'Select',
      onTap: () {},
      icon: CupertinoIcons.checkmark_circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        for (final alignment in const [
          AlignmentDirectional.centerStart,
          AlignmentDirectional.center,
          AlignmentDirectional.centerEnd,
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
    );

    return CupertinoPageScaffold(
      navigationBar: ExampleScaffoldNavigationBar(title: title),
      child: SafeArea(
        child: child,
      ),
    );
  }
}

@immutable
class ExampleScaffoldNavigationBar extends CupertinoNavigationBar {
  ExampleScaffoldNavigationBar({
    super.key,
    required String title,
  }) : super(
         middle: Builder(
           builder:
               (context) => Text(
                 title,
                 style: TextStyle(
                   color: CupertinoDynamicColor.resolve(
                     CupertinoColors.label,
                     context,
                   ),
                 ),
                 textAlign: TextAlign.center,
               ),
         ),
         previousPageTitle: 'Back',
         padding: const EdgeInsetsDirectional.only(end: 8),
         trailing: const CupertinoButton(
           onPressed: onThemeModeChange,
           padding: EdgeInsets.zero,
           child: Icon(CupertinoIcons.sun_max_fill),
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

@immutable
class LabeledExample extends StatelessWidget {
  const LabeledExample({
    super.key,
    required this.label,
    required this.items,
    this.anchor = PullDownMenuAnchor.end,
    this.animationBuilder = PullDownButton.defaultAnimationBuilder,
  });

  final String label;
  final List<Widget> items;
  final PullDownMenuAnchor anchor;
  final PullDownButtonAnimationBuilder? animationBuilder;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = CupertinoColors.secondarySystemGroupedBackground
        .resolveFrom(context);

    return CupertinoListSection.insetGrouped(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      children: [
        PullDownButton(
          itemBuilder: (_) => items,
          buttonAnchor: anchor,
          animationBuilder: animationBuilder,
          buttonBuilder:
              (context, showMenu) => CupertinoListTile(
                backgroundColor: backgroundColor,
                backgroundColorActivated: backgroundColor,
                onTap: showMenu,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    label,
                    maxLines: 3,
                    style: TextStyle(
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                ),
                trailing: Icon(
                  CupertinoIcons.chevron_up_chevron_down,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  size: 17,
                ),
              ),
        ),
      ],
    );
  }
}
