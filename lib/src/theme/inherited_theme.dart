import 'package:flutter/material.dart';

import 'theme.dart';

/// Alternative way of defining [PullDownButtonTheme].
///
/// Example:
///
/// ```dart
/// CupertinoApp(
///    builder: (context, child) => PullDownButtonInheritedTheme(
///      data: const PullDownButtonTheme(
///        ...
///      ),
///      child: child!,
///  ),
/// home: ...,
/// ```
///
@immutable
class PullDownButtonInheritedTheme extends InheritedTheme {
  /// Creates a [PullDownButtonInheritedTheme].
  const PullDownButtonInheritedTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final PullDownButtonTheme data;

  /// The closest nullable instance of this class that encloses the given
  /// context.
  static PullDownButtonTheme? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PullDownButtonInheritedTheme>()
      ?.data;

  @override
  bool updateShouldNotify(covariant PullDownButtonInheritedTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      PullDownButtonInheritedTheme(
        data: data,
        child: child,
      );
}
