import 'package:flutter/cupertino.dart';

import '/src/internals/actions_row_size_config.dart';
import '/src/internals/element_size.dart';
import '/src/internals/menu_config.dart';
import '/src/items/item.dart';
import 'divider.dart';

/// Displays several actions in a more compact way (in a row, 3 or 4 items
/// depending on the desired size).
///
/// ![](https://docs-assets.developer.apple.com/published/a52c40a3e56e894d1c64dce93b8a252d/media-4047986~dark%402x.png)
///
/// See also:
///
/// * [UIKit documentation, preferredElementSize](https://developer.apple.com/documentation/uikit/uimenu/preferredelementsize)
@immutable
class PullDownMenuActionsRow extends StatelessWidget {
  /// Creates a row of 4 actions at max; icon only.
  const PullDownMenuActionsRow.small({
    super.key,
    required this.items,
  }) : _size = ElementSize.small;

  /// Creates a row of 3 actions at max; icon and short (one-worded) title.
  const PullDownMenuActionsRow.medium({
    super.key,
    required this.items,
  }) : _size = ElementSize.medium;

  /// The size of descendant [PullDownMenuItem]s.
  final ElementSize _size;

  /// The list of actions.
  ///
  /// Number of provided [items] should not be more than 4 for
  /// [PullDownMenuActionsRow.small] and 3 for [PullDownMenuActionsRow.medium]
  /// to avoid icon and text overflows.
  final List<PullDownMenuItem> items;

  /// Returns fixed height for [PullDownMenuItem] in [PullDownMenuActionsRow].
  double _height(BuildContext context) => _size.resolve(
    MenuConfig.contentSizeCategoryOf(context),
  );

  @override
  Widget build(BuildContext context) {
    assert(
      switch (_size) {
        ElementSize.small => items.length <= 4,
        ElementSize.medium => items.length <= 3,
        _ => true,
      },
      'Amount of [items] should not be more than 3 for '
      '[PullDownMenuActionsRow.medium] and not more than 4 for '
      '[PullDownMenuActionsRow.small]',
    );

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: _height(context),
      ),
      child: ActionsRowSizeConfig(
        size: _size,
        child: Row(
          children: PullDownMenuSeparator.wrapSideBySide(items),
        ),
      ),
    );
  }
}
