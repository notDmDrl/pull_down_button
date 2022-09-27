import 'package:flutter/cupertino.dart';

import '../theme/default_theme.dart';
import '../theme/theme.dart';
import 'entry.dart';

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
  /// If this property is null then [PullDownButtonTheme.titleStyle] from
  /// [PullDownButtonTheme] theme extension is used. If that's null then
  /// [PullDownButtonThemeDefaults.titleStyle] is used.
  final TextStyle? titleStyle;

  /// Eyeballed from iOS 15.
  @override
  double get height => 26;

  @override
  bool get represents => false;

  @override
  bool get isDestructive => false;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Center(
          child: DefaultTextStyle(
            style: PullDownButtonTheme.getProperty(
              widgetProperty: titleStyle,
              theme: PullDownButtonTheme.of(context),
              defaults: PullDownButtonThemeDefaults(context),
              getThemeProperty: (theme) => theme?.titleStyle,
            ),
            child: title,
          ),
        ),
      );
}
