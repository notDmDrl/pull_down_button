import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'utils.dart';

// ignore_for_file: constant_identifier_names, avoid_redundant_argument_values

const EventChannel _platformEventChannel = EventChannel(
  'native_compare.example.com/responder',
);

void main() {
  runApp(
    const CupertinoApp(home: MyApp()),
  );
}

@immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CompareTest controlName = CompareTest.Null;

  @override
  void initState() {
    super.initState();

    _platformEventChannel.receiveBroadcastStream().listen((dynamic name) {
      if (name is! String) return;

      if (name != controlName.name) {
        setState(() => controlName = CompareTest.values.byName(name));
      }
    });
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    child: Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Align(
          alignment: Alignment.center,
          child: body(controlName),
        ),
      ),
    ),
  );
}

Widget body(CompareTest controlName) {
  if (controlName == CompareTest.Null) return const SizedBox.shrink();

  final entries = controlName.entries;

  if (controlName == CompareTest.ElementSizeSmall) {
    entries.insert(0, small);
  } else if (controlName == CompareTest.ElementSizeMedium) {
    entries.insert(0, medium);
  }

  return PullDownButton(
    itemBuilder: (_) => entries,
    buttonBuilder: ExampleButton.builder,
  );
}

enum CompareTest {
  Null([]),
  Item([
    PullDownMenuItem(
      onTap: _call,
      title: 'Item',
    ),
  ]),
  ItemOverflow([
    PullDownMenuItem(
      onTap: _call,
      title: '012345678901234657890123456789012345678901234657890123456789',
    ),
  ]),
  ItemWithIcon([
    PullDownMenuItem(
      onTap: _call,
      icon: CupertinoIcons.star,
      title: 'ItemWithIcon',
    ),
  ]),
  ItemWithIconOverflow([
    PullDownMenuItem(
      onTap: _call,
      icon: CupertinoIcons.star,
      title: '012345678901234657890123456789',
    ),
  ]),
  Dividers([
    PullDownMenuItem(
      onTap: _call,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: _call,
      title: 'Item',
    ),
    PullDownMenuDivider(),
    PullDownMenuItem(
      onTap: _call,
      title: 'Item',
    ),
  ]),
  Pickers([
    PullDownMenuItem.selectable(
      selected: true,
      onTap: _call,
      title: 'Value1',
    ),
    PullDownMenuItem.selectable(
      onTap: _call,
      title: 'Value2',
    ),
    PullDownMenuItem.selectable(
      onTap: _call,
      title: 'Value3',
    ),
  ]),
  ElementSizeSmall([
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
  ]),
  ElementSizeMedium([]);

  const CompareTest(this.entries);

  static void _call() {}

  final List<Widget> entries;
}

const small = PullDownMenuActionsRow.small(
  items: [
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
  ],
);

const medium = PullDownMenuActionsRow.medium(
  items: [
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
    PullDownMenuItem(
      onTap: CompareTest._call,
      icon: CupertinoIcons.star,
      title: 'Item',
    ),
  ],
);
