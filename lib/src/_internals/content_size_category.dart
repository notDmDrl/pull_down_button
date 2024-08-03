import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../items/entry.dart';
import 'animation.dart';

/// Text scale levels available in iOS 16 accessibility menu.
///
/// The value of each level was taken by writing down values returned by
/// `MediaQuery.of(context).textScaleFactor`.
///
/// [ContentSizeCategory.large] is the default value.
///
/// Those values are used to resolve heights of various [PullDownMenuEntry].
///
/// See also:
///
/// * preferredContentSizeCategory:
///   https://developer.apple.com/documentation/uikit/uiapplication/1623048-preferredcontentsizecategory
/// * UIContentSizeCategory:
///   https://developer.apple.com/documentation/uikit/uicontentsizecategory
@internal
enum ContentSizeCategory {
  /// An extra-small font.
  ///
  /// * UIKit value - `.extraSmall`.
  /// * SwiftUI value - `.xSmall`.
  extraSmall(0.8235294117647058),

  /// A small font.
  ///
  /// * UIKit value - `.small`.
  /// * SwiftUI value - `.small`.
  small(0.8823529411764706),

  /// A medium-sized font.
  ///
  /// * UIKit value - `.medium`.
  /// * SwiftUI value - `.medium`.
  medium(0.9411764705882353),

  /// A large font.
  ///
  /// * UIKit value - `.large`.
  /// * SwiftUI value - `.large`.
  large(1),

  /// An extra-large font.
  ///
  /// * UIKit value - `.extraLarge`.
  /// * SwiftUI value - `.xLarge`.
  extraLarge(1.1176470588235294),

  /// A font that is larger than the extra-large font but smaller than the
  /// largest font size available.
  ///
  /// * UIKit value - `.extraExtraLarge`.
  /// * SwiftUI value - `.xxLarge`.
  extraExtraLarge(1.2352941176470589),

  /// The largest font size.
  ///
  /// * UIKit value - `.extraExtraExtraLarge`.
  /// * SwiftUI value - `.xxxLarge`.
  extraExtraExtraLarge(1.3529411764705883),

  /// A medium font size that reflects the current accessibility settings.
  ///
  /// * UIKit value - `.accessibilityMedium`.
  /// * SwiftUI value - `.accessibility1`.
  accessibilityMedium(1.6470588235294117),

  /// A large font size that reflects the current accessibility settings.
  ///
  /// * UIKit value - `.accessibilityLarge`.
  /// * SwiftUI value - `.accessibility2`.
  accessibilityLarge(1.9411764705882353),

  /// An extra-large font size that reflects the current accessibility settings.
  ///
  /// * UIKit value - `.accessibilityExtraLarge`.
  /// * SwiftUI value - `.accessibility3`.
  accessibilityExtraLarge(2.3529411764705883),

  /// A font that is larger than the extra-large font but not the largest
  /// available, reflecting the current accessibility settings.
  ///
  /// * UIKit value - `.accessibilityExtraExtraLarge`.
  /// * SwiftUI value - `.accessibility4`.
  accessibilityExtraExtraLarge(2.764705882352941),

  /// The largest font size that reflects the current accessibility settings.
  ///
  /// * UIKit value - `.accessibilityExtraExtraExtraLarge`.
  /// * SwiftUI value - `.accessibility5`.
  accessibilityExtraExtraExtraLarge(3.1176470588235294);

  /// Creates [ContentSizeCategory].
  const ContentSizeCategory(this.textScaleFactor);

  /// A text scale factor for specific preferred text size level.
  final double textScaleFactor;

  /// The [ContentSizeCategory] from the closest [MediaQuery] instance that
  /// encloses the given context.
  static ContentSizeCategory of(BuildContext context) {
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return ContentSizeCategory.values.firstWhere(
      (element) => element.textScaleFactor >= textScaleFactor,
      orElse: () => ContentSizeCategory.large,
    );
  }
}

/// A set of text scale related utils.
///
/// All of the values were eyeballed using the iOS 16 Simulator.
@internal
abstract final class TextUtils {
  /// Utility method for resolving if current text scale factor is bigger
  /// than [ContentSizeCategory.extraExtraExtraLarge]. At this text scale
  /// factor menu transitions to its bigger size "accessibility" mode.
  ///
  /// Required text scale factor was deducted using the iPhone 14 Pro Max and
  /// iPhone SE (3rd gen) iOS 16 Simulators.
  static bool isInAccessibilityMode(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(1) >
      ContentSizeCategory.extraExtraExtraLarge.textScaleFactor;
}

/// An [AnimatedContainer] with predefined [duration] and [curve].
///
/// Is used to animate a container on text scale factor change.
@internal
class AnimatedMenuContainer extends AnimatedContainer {
  /// Creates [AnimatedMenuContainer].
  AnimatedMenuContainer({
    super.key,
    super.constraints,
    super.alignment,
    super.padding,
    required super.child,
  }) : super(
          duration: AnimationUtils.kMenuDuration,
          curve: Curves.fastOutSlowIn,
        );
}
