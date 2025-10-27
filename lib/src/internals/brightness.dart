import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A [Brightness] which a Pull-down menu should use for its looks.
Brightness menuBrightnessOf(BuildContext context) =>
    CupertinoTheme.maybeBrightnessOf(context) ??
    Theme.maybeBrightnessOf(context) ??
    Brightness.light;

/// Returns an opacity level for disabled state of this menu item for
/// specific [Brightness].
///
/// Opacity values were based on a direct pixel-to-pixel comparison with the
/// native variant.
double disabledOpacityOf(BuildContext context) => //
    switch (menuBrightnessOf(context)) {
  Brightness.dark => 0.55,
  Brightness.light => 0.45,
};
