import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import 'blur.dart';

/// Menu container - shape, blur, color.
@immutable
@internal
class MenuDecoration extends StatelessWidget {
  /// Creates [MenuDecoration].
  const MenuDecoration({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.borderRadius,
  });

  /// A menu content widget.
  final Widget child;

  /// The background color of the pull-down menu.
  final Color backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget box = ColoredBox(
      color: backgroundColor,
      child: child,
    );

    if (useBackdropFilter(backgroundColor)) {
      box = BackdropFilter(
        filter: kPullDownMenuBlur,
        child: box,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: box,
    );
  }
}

/// Menu body - scrollbar, list of [PullDownMenuEntry].
@immutable
@internal
class MenuBody extends StatefulWidget {
  /// Creates [MenuBody].
  const MenuBody({
    super.key,
    required this.items,
  });

  /// Items to show in the menu.
  final List<PullDownMenuEntry> items;

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: 'Pull-Down menu',
        child: CupertinoScrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            primary: false,
            controller: scrollController,
            child: ListBody(children: widget.items),
          ),
        ),
      );
}
