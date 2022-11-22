import 'package:flutter/material.dart';

import '../../pull_down_button.dart';

/// See [PopupMenuEntry].
@immutable
abstract class PullDownMenuEntry extends StatelessWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PullDownMenuEntry({super.key});

  /// See [PopupMenuEntry.height].
  double get height;

  /// Whether this entry represents any action and is available to tap.
  bool get represents;

  /// Whether this entry represents destructive action;
  ///
  /// If true, the contents of entry are being colored with
  /// [PullDownMenuItemTheme.destructiveColor] from
  /// [PullDownButtonTheme.itemTheme].
  ///
  /// If that's null then defaults from [PullDownMenuItemTheme] are used.
  bool get isDestructive;
}
