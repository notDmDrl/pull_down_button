import 'package:flutter/cupertino.dart';

@immutable
class ExampleButton extends StatelessWidget {
  const ExampleButton({super.key, required this.onTap});

  const ExampleButton.builder(
    BuildContext _,
    this.onTap, {
    super.key,
  });

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: CupertinoColors.systemGreen,
        minSize: 34 * MediaQuery.textScaleFactorOf(context),
        onPressed: onTap,
        pressedOpacity: 1,
        child: const Text('Button'),
      );
}
