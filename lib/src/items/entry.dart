import 'package:flutter/material.dart';

import '../theme/default_theme.dart';
import '../theme/theme.dart';

/// See [PopupMenuEntry].
@immutable
abstract class PullDownMenuEntry extends StatelessWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PullDownMenuEntry({super.key});

  /// See [PopupMenuEntry.height].
  double get height;

  /// Whether this entry represents any action and is available to tap;
  bool get represents;

  /// Whether this entry represents destructive action;
  ///
  /// If true, the contents of entry are being colored with
  /// [PullDownButtonTheme.destructiveColor] from [PullDownButtonTheme]
  /// theme extension. If that's null then
  /// [PullDownButtonThemeDefaults.destructiveColor] is used.
  bool get isDestructive;
}
