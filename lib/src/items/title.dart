import 'package:flutter/cupertino.dart';

import '../../pull_down_button.dart';
import '../internals/content_size_category.dart';
import '../internals/element_size.dart';
import '../internals/item_layout.dart';
import '../internals/menu_config.dart';

/// Used to configure how [PullDownMenuTitle.title] is aligned.
enum PullDownMenuTitleAlignment {
  /// [PullDownMenuTitle]'s title widget is aligned at the start edge
  /// (with applied padding).
  start,

  /// [PullDownMenuTitle]'s title widget is aligned at the center.
  center,
}

/// The optional title of the pull-down menu that is usually displayed at the
/// top of the pull-down menu.
@immutable
class PullDownMenuTitle extends StatelessWidget {
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
  ///
  /// If this property is null, then the value from the ambient
  /// [PullDownMenuTitleTheme] is used.
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final PullDownMenuTitleTheme theme =
        MenuConfig.ambientThemeOf(context).titleTheme;
    final bool hasLeading = MenuConfig.hasLeadingOf(context);
    final ContentSizeCategory contentSize = MenuConfig.contentSizeCategoryOf(
      context,
    );

    final TextStyle resolvedStyle = theme.style!.merge(titleStyle);
    final double minHeight = ElementSize.title.resolve(contentSize);
    final isAlignedToStart = alignment == PullDownMenuTitleAlignment.start;
    final bool isAlignedToLeading = hasLeading && isAlignedToStart;

    Widget resolvedChild = title;
    if (isAlignedToLeading) {
      resolvedChild = Row(
        children: [
          const LeadingWidgetBox(),
          Expanded(child: resolvedChild),
        ],
      );
    }

    return AnimatedMenuContainer(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: EdgeInsetsDirectional.only(
        // Use title with menu item's padding so it's all nicely aligned.
        start: isAlignedToLeading ? 9 : 16,
        top: 8,
        bottom: 8,
        end: 16,
      ),
      alignment:
          isAlignedToStart
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.center,
      child: DefaultTextStyle(
        style: resolvedStyle,
        textAlign: isAlignedToStart ? TextAlign.start : TextAlign.center,
        child: resolvedChild,
      ),
    );
  }
}
