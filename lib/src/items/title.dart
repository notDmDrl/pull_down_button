import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';

/// The (optional) title of the pull-down menu that is usually displayed at the
/// top of pull-down menu.
///
/// [title] is typically a [Text] widget.
@immutable
class PullDownMenuTitle extends PullDownMenuEntry {
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
  /// If that's null then defaults from [PullDownMenuTitleTheme] are used.
  final TextStyle? titleStyle;

  /// Eyeballed from iOS 16.
  @override
  double get height => 26;

  @override
  bool get represents => false;

  @override
  bool get isDestructive => false;

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuTitleTheme.of(context);
    final defaults = PullDownMenuTitleTheme.defaults(context);

    final style = titleStyle ?? theme?.style ?? defaults.style!;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Center(
        child: DefaultTextStyle(
          style: style,
          child: title,
        ),
      ),
    );
  }
}
