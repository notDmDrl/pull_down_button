import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '/src/items/divider.dart';
import '/src/theme/route_theme.dart';
import 'blur.dart';

/// A widget used to create pull-down menu container.
@immutable
class MenuDecoration extends StatelessWidget {
  /// Creates [MenuDecoration].
  const MenuDecoration({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderClipper,
  });

  /// A menu content widget.
  final Widget child;

  /// The background color of the pull-down menu.
  final Color backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius borderRadius;

  /// The border radius clipper of the pull-down menu.
  final PullDownMenuRouteBorderClipper borderClipper;

  @override
  Widget build(BuildContext context) {
    Widget box = ColoredBox(
      color: backgroundColor,
      child: child,
    );

    if (BlurUtils.useBackdropFilter(backgroundColor)) {
      box = BackdropFilter(
        filter: BlurUtils.menuBlur(context),
        child: box,
      );
    }

    return borderClipper(borderRadius, box);
  }
}

/// A widget used to create a scrollable body for pull-down menu items.
@immutable
class MenuBody extends StatefulWidget {
  /// Creates [MenuBody].
  const MenuBody({
    super.key,
    required this.items,
    required this.scrollController,
  });

  /// Items to show in the menu.
  final List<Widget> items;

  /// A scroll controller that can be used to control the scrolling of the
  /// [items] in the menu.
  final ScrollController? scrollController;

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  late final ScrollController _effectiveScrollController;

  @override
  void initState() {
    super.initState();
    _effectiveScrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _effectiveScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = CupertinoScrollbar(
      controller: _effectiveScrollController,
      child: SingleChildScrollView(
        primary: false,
        clipBehavior: Clip.none,
        controller: _effectiveScrollController,
        child: ListBody(
          children: PullDownMenuSeparator.wrapVerticalList(widget.items),
        ),
      ),
    );

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: 'Pull-Down menu',
      child: switch (defaultTargetPlatform) {
        TargetPlatform.android || TargetPlatform.iOS => child,
        _ => ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: child,
        ),
      },
    );
  }
}
