import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../_internals/content_size_category.dart';
import '../_internals/item_layout.dart';
import '../_internals/menu_config.dart';

/// Used to configure how [PullDownMenuTitle.title] is aligned.
enum PullDownMenuTitleAlignment {
  /// [PullDownMenuTitle.title] is aligned at the start of [PullDownMenuTitle]
  /// widget.
  start,

  /// [PullDownMenuTitle.title] is aligned at the center of [PullDownMenuTitle]
  /// widget.
  center;
}

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
    this.alignment = PullDownMenuTitleAlignment.start,
    this.titleStyle,
  });

  /// Typically a [Text] widget with short one/two words content.
  final Widget title;

  /// The alignment of [title].
  ///
  /// Defaults to [PullDownMenuTitleAlignment.start].
  final PullDownMenuTitleAlignment alignment;

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
  /// The default height is 32px.
  static double _resolveHeight(BuildContext context) =>
      (ElementSize.resolveLarge(context) * 0.72).ceilToDouble();

  @override
  Widget build(BuildContext context) {
    final theme = PullDownMenuTitleTheme.resolve(
      context,
      titleStyle: titleStyle,
    );

    final minHeight = _resolveHeight(context);

    final hasLeading = MenuConfig.of(context);

    final alignedToStart = alignment == PullDownMenuTitleAlignment.start;

    final box = hasLeading && alignedToStart
        ? Row(
            children: [
              const LeadingWidgetBox(),
              Expanded(child: title),
            ],
          )
        : title;

    return AnimatedMenuContainer(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: EdgeInsetsDirectional.only(
        // Use title with menu item's padding so it's all nicely aligned.
        start: alignedToStart && hasLeading ? 9 : 16,
        top: 8,
        bottom: 8,
        end: 16,
      ),
      alignment: alignedToStart
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.center,
      child: DefaultTextStyle(
        style: theme.style!,
        child: box,
      ),
    );
  }
}
