import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';

/// The (optional) title of the pull-down menu that is usually displayed at the
/// top of pull-down menu.
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

  /// The text style of title.
  ///
  /// If this property is null then [PullDownButtonTheme.titleTheme] from
  /// [PullDownButtonTheme] theme extension is used.
  ///
  /// If that's null then defaults from [PullDownMenuTitleTheme.defaults] are
  /// used.
  final TextStyle? titleStyle;

  /// Eyeballed from iOS 16.
  static const double kPullDownMenuTitleHeight = 30;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuTitleTheme.resolve(
      context,
      titleStyle: titleStyle,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: kPullDownMenuTitleHeight),
      child: Center(
        child: DefaultTextStyle(
          style: theme.style!,
          child: title,
        ),
      ),
    );
  }
}
