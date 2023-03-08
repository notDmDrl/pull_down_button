import 'package:flutter/material.dart';

import '../pull_down_button.dart';

/// Used to limit types of children passed to [PullDownButton.itemBuilder].
@immutable
abstract class PullDownMenuEntry extends Widget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PullDownMenuEntry({super.key});
}
