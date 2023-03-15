import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/menu_config.dart';
import 'divider.dart';

/// Displays a number of actions in a more compact way (in a row, 3 or 4 items
/// depending on desired size).
///
/// To show a pull-down menu and create a button that shows a pull-down menu
/// use [PullDownButton.buttonBuilder].
///
/// Default height of [PullDownMenuActionsRow] depends on size:
///
/// * For [PullDownMenuActionsRow.small] it is 44 pixels
/// ([kMinInteractiveDimensionCupertino]).
/// * For [PullDownMenuActionsRow.medium] it is 66 pixels (150% of
/// [kMinInteractiveDimensionCupertino]).
///
/// See also:
/// * [PullDownMenuItem], for a classic, full width pull-down menu entry for a
///   simple action.
/// * preferredElementSize:
///   https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize
@immutable
class PullDownMenuActionsRow extends StatelessWidget
    implements PullDownMenuEntry {
  /// Creates a row of maximum 4 actions, icon only.
  ///
  /// Actions have height of 44 logical pixels.
  const PullDownMenuActionsRow.small({
    super.key,
    required this.items,
    this.dividerColor,
  })  : _size = ElementSize.small,
        assert(
          items.length <= 4,
          'Amount of [items] should not be more than 4',
        );

  /// Creates a row of maximum 3 actions, icon and short (one worded) title.
  ///
  /// Actions have height of 66 logical pixels.
  const PullDownMenuActionsRow.medium({
    super.key,
    required this.items,
    this.dividerColor,
  })  : _size = ElementSize.medium,
        assert(
          items.length <= 3,
          'Amount of [items] should not be more than 3',
        );

  /// The size of descendant [PullDownMenuItem]s.
  final ElementSize _size;

  /// The list of actions.
  ///
  /// Number of provided [items] should not be more than 4 for
  /// [PullDownMenuActionsRow.small] and 3 for [PullDownMenuActionsRow.medium]
  /// to avoid text overflows.
  ///
  /// Required [ElementSize] is passed to [PullDownMenuItem]s via
  /// [ActionsRowSizeConfig].
  final List<PullDownMenuItem> items;

  /// The color of vertical divider used to split actions.
  ///
  /// If this property is null then
  /// [PullDownMenuDividerTheme.dividerColor] from
  /// [PullDownButtonTheme.dividerTheme] is used.
  ///
  /// If that's null then defaults from [PullDownMenuDividerTheme.defaults] are
  /// used.
  final Color? dividerColor;

  /// The height of descendant [PullDownMenuItem]s.
  ///
  /// Can be 44 pixels ([ElementSize.small]) or 66 pixels
  /// ([ElementSize.medium]).
  double get _height {
    switch (_size) {
      case ElementSize.small:
        return kMinInteractiveDimensionCupertino;
      case ElementSize.medium:
        return kMinInteractiveDimensionCupertino +
            kMinInteractiveDimensionCupertino / 2;
      case ElementSize.large:
        throw UnsupportedError(
            '[PullDownMenuActionsRow] only supports `ElementSize.small` '
            'and `ElementSize.medium`');
    }
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: _height),
        child: ActionsRowSizeConfig(
          size: _size,
          child: Row(
            children: PullDownMenuVerticalDivider.wrapWithDivider(
              items,
              height: _height,
              color: dividerColor,
            ),
          ),
        ),
      );
}
