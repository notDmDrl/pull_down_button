/// @docImport '/pull_down_button.dart';
/// @docImport '/src/items/title.dart';
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '_dynamic_color.dart';
import '_fonts.dart';

/// Defines the visual properties of the titles in pull-down menus.
///
/// Is used by [PullDownMenuTitle].
///
/// Typically a [PullDownMenuTitleTheme] is specified as part of the overall
/// [PullDownButtonTheme] with [PullDownButtonTheme.titleTheme].
///
/// All [PullDownMenuTitleTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuTitleTheme.defaults].
@immutable
class PullDownMenuTitleTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuTitleTheme].
  const PullDownMenuTitleTheme({
    this.style,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuTitleTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch and
  /// Figma libraries for iOS 18 and iPadOS 18.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  @internal
  const factory PullDownMenuTitleTheme.defaults(BuildContext context) =
      _Defaults;

  /// The text style of title in the pull-down menu.
  final TextStyle? style;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuTitleTheme copyWith({
    TextStyle? style,
  }) => PullDownMenuTitleTheme(
    style: style ?? this.style,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuTitleTheme lerp(
    PullDownMenuTitleTheme? a,
    PullDownMenuTitleTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuTitleTheme(
      style: TextStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  int get hashCode => Object.hashAll([style]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuTitleTheme && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('style', style, defaultValue: null));
  }
}

/// A set of default values for [PullDownMenuTitleTheme].
@immutable
class _Defaults extends PullDownMenuTitleTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context);

  /// A build context used to resolve [SimpleDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark colors of [PullDownMenuTitleTheme.style].
  static const kTitleColor = SimpleDynamicColor(
    color: Color.fromRGBO(60, 60, 67, 0.6),
    darkColor: Color.fromRGBO(235, 235, 245, 0.6),
  );

  /// The [PullDownMenuTitleTheme.style] before applying [kTitleColor].
  static const kStyle = TextStyle(
    inherit: false,
    fontFamily: kPullDownMenuEntryFontFamily,
    fontFamilyFallback: kPullDownMenuEntryFontFallbacks,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: 1,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  @override
  TextStyle get style => kStyle.copyWith(
    color: kTitleColor.resolveFrom(context),
  );
}
