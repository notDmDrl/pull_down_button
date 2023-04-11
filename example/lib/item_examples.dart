import 'package:flutter/cupertino.dart' hide Title;
import 'package:pull_down_button/pull_down_button.dart';

import 'setup.dart';
import 'src/actions_row.dart';
import 'src/anchor.dart';
import 'src/animation_builder.dart';
import 'src/divider.dart';
import 'src/item.dart';
import 'src/position.dart';
import 'src/pull_down_menu.dart';
import 'src/selectable_item.dart';
import 'src/show_menu.dart';
import 'src/tap_handler.dart';
import 'src/theming_custom.dart';
import 'src/theming_default.dart';
import 'src/title.dart';

@immutable
class ItemExamples extends StatelessWidget {
  const ItemExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.label,
        context,
      ),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
        middle: Text('Examples', style: textStyle),
        trailing: const CupertinoButton(
          onPressed: onThemeModeChange,
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.sun_max_fill),
        ),
        padding: const EdgeInsetsDirectional.only(end: 8),
      ),
      child: Builder(
        builder: (context) {
          final edgeInsets = MediaQuery.of(context).padding;

          return ListView(
            padding: EdgeInsets.only(
              left: edgeInsets.left,
              right: edgeInsets.right,
              bottom: edgeInsets.bottom + 16,
              top: edgeInsets.top,
            ),
            children: [
              const _Category(
                header: 'Items',
                children: [
                  _Tile(
                    destination: Item(),
                    title: 'PullDownMenuItem',
                  ),
                  _Tile(
                    destination: SelectableItem(),
                    title: 'PullDownMenuItem.selectable',
                  ),
                  _Tile(
                    destination: Divider(),
                    title: 'PullDownMenuDivider',
                  ),
                  _Tile(
                    destination: Title(),
                    title: 'PullDownMenuTitle',
                  ),
                  _Tile(
                    destination: ActionsRow(),
                    title: 'PullDownMenuActionsRow',
                  ),
                ],
              ),
              _Category(
                header: 'PullDownMenuPosition',
                children: [
                  for (final position in PullDownMenuPosition.values)
                    _Tile(
                      destination: Position(position: position),
                      title: '.${position.name}',
                    ),
                ],
              ),
              const _Category(
                header: 'Theming',
                children: [
                  _Tile(
                    destination: ThemingDefault(),
                    title: 'Default theme',
                  ),
                  _Tile(
                    destination: ThemingCustom(),
                    title: 'Material 3 custom theme',
                  ),
                ],
              ),
              const _Category(
                header: 'Advanced',
                children: [
                  _Tile(
                    destination: ShowPullDownMenu(),
                    title: 'showPullDownMenu',
                  ),
                  _Tile(
                    title: 'PullDownMenuItem.tapHandler',
                    destination: TapHandler(),
                  ),
                  _Tile(
                    title: 'PullDownMenu',
                    destination: PullDownMenuBox(),
                  ),
                  _Tile(
                    title: 'PullDownButton.animationBuilder',
                    destination: AnimationBuilder(),
                  ),
                  _Tile(
                    title: 'PullDownMenuAnchor',
                    destination: Anchor(),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

@immutable
class _Category extends StatelessWidget {
  const _Category({required this.header, required this.children});

  final String header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => CupertinoListSection.insetGrouped(
        header: Text(
          header,
          style: TextStyle(
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
        hasLeading: false,
        additionalDividerMargin: 6,
        children: children,
      );
}

@immutable
class _Tile extends StatelessWidget {
  const _Tile({required this.title, required this.destination});

  final String title;
  final Widget destination;

  @override
  Widget build(BuildContext context) => CupertinoListTile(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute<void>(builder: (_) => destination),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.label,
              context,
            ),
          ),
        ),
        trailing: const CupertinoListTileChevron(),
      );
}
