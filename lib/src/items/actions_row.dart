import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/menu_config.dart';
import 'divider.dart';

/// Displays several actions in a more compact way (in a row, 3 or 4 items
/// depending on the desired size).
///
/// See also:
///
/// * preferredElementSize:
///   https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize
@immutable
class PullDownMenuActionsRow extends StatelessWidget
    implements PullDownMenuEntry {
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
  double _height(BuildContext context) {
    switch (_size) {
      case ElementSize.small:
        return ElementSize.resolveLarge(context);
      case ElementSize.medium:
        return ElementSize.resolveMedium(context);
      case ElementSize.large:
        throw UnsupportedError(
          '[PullDownMenuActionsRow] only supports `ElementSize.small` '
          'and `ElementSize.medium`',
        );
    }
  }

  @protected
  bool _debugHasCorrectItemsCount() {
    assert(
      () {
        switch (_size) {
          case ElementSize.small:
            return items.length <= 4;
          case ElementSize.medium:
            return items.length <= 3;
          case ElementSize.large:
            return true;
        }
      }(),
      'Amount of [items] should not be more than 3 for '
      '[PullDownMenuActionsRow.medium] and not more than 4 for '
      '[PullDownMenuActionsRow.small]',
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(_debugHasCorrectItemsCount(), '');

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: _height(context),
      ),
      child: ActionsRowSizeConfig(
        size: _size,
        child: Row(
          children: MenuSeparator.wrapSideBySide(items),
        ),
      ),
    );
  }
}
