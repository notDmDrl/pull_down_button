import 'package:flutter/cupertino.dart' hide Title;
import 'package:pull_down_button/pull_down_button.dart';

import 'setup.dart';
import 'src/actions_row.dart';
import 'src/divider.dart';
import 'src/item.dart';
import 'src/position.dart';
import 'src/selectable_item.dart';
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

    final header = TextStyle(
      color: CupertinoColors.secondaryLabel.resolveFrom(context),
    );

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            previousPageTitle: 'Back',
            largeTitle: Text('Examples', style: textStyle),
            trailing: const CupertinoButton(
              onPressed: onThemeModeChange,
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.sun_max_fill),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: CupertinoListSection.insetGrouped(
                header: Text(
                  'Items',
                  style: header,
                ),
                children: [
                  CupertinoListTile(
                    onTap: () => context.push(const Item()),
                    title: Text(
                      'PullDownMenuItem',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                  CupertinoListTile(
                    onTap: () => context.push(const SelectableItem()),
                    title: Text(
                      'SelectablePullDownMenuItem',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                  CupertinoListTile(
                    onTap: () => context.push(const Divider()),
                    title: Text(
                      'PullDownMenuDivider',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                  CupertinoListTile(
                    onTap: () => context.push(const Title()),
                    title: Text(
                      'PullDownMenuTitle',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                  CupertinoListTile(
                    onTap: () => context.push(const ActionsRow()),
                    title: Text(
                      'PullDownMenuActionsRow',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              bottom: false,
              child: CupertinoListSection.insetGrouped(
                header: Text(
                  'PullDownMenuPosition',
                  style: header,
                ),
                children: [
                  for (final position in PullDownMenuPosition.values)
                    CupertinoListTile(
                      onTap: () => context.push(Position(position: position)),
                      title: Text(
                        '.${position.name}',
                        style: textStyle,
                      ),
                      trailing: const CupertinoListTileChevron(),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: CupertinoListSection.insetGrouped(
                header: Text(
                  'Theming',
                  style: header,
                ),
                children: [
                  CupertinoListTile(
                    onTap: () => context.push(const ThemingDefault()),
                    title: Text(
                      'Default theme',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                  CupertinoListTile(
                    onTap: () => context.push(const ThemingCustom()),
                    title: Text(
                      'Material 3 custom theme',
                      style: textStyle,
                    ),
                    trailing: const CupertinoListTileChevron(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on BuildContext {
  Future<void> push(Widget screen) => Navigator.push(
        this,
        CupertinoPageRoute<void>(
          builder: (_) => screen,
        ),
      );
}
