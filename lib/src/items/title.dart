import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/content_size_category.dart';
import '../_internals/menu_config.dart';

/// The (optional) title of the pull-down menu that is usually displayed at the
/// top of the pull-down menu.
///
/// [title] is typically a [Text] widget.
@immutable
class PullDownMenuTitle extends StatelessWidget implements PullDownMenuEntry {
  /// Creates a title for a pull-down menu.
  const PullDownMenuTitle({
    super.key,
    required this.title,
    this.titleStyle,
  });

  /// Typically a [Text] widget with short one/two words content and
  /// [Text.textAlign] set to [TextAlign.center].
  final Widget title;

  /// The text style of the title.
  ///
  /// If this property is null, then [PullDownButtonTheme.titleTheme] from
  /// [PullDownButtonTheme] theme extension is used.
  ///
  /// If that's null, then defaults from [PullDownMenuTitleTheme.defaults] are
  /// used.
  final TextStyle? titleStyle;

  /// Returns a minimum height of title container.
  ///
  /// The default height is 30px.
  // TODO(notDmDrl): revisit this when `Menu` in SwiftUI will have support for
  // menu titles (only in UIKit right now).
  static double _resolveHeight(BuildContext context) =>
      (ElementSize.resolveLarge(context) * 0.68).ceilToDouble();

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuTitleTheme.resolve(
      context,
      titleStyle: titleStyle,
    );

    final minHeight = _resolveHeight(context);

    final hasLeading = MenuConfig.of(context);

    return AnimatedMenuContainer(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: EdgeInsetsDirectional.symmetric(
        // Use title with menu item's padding so it's all nicely aligned.
        horizontal: hasLeading ? 13 : 16,
        vertical: 7,
      ),
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: theme.style!,
        child: title,
      ),
    );
  }
}
