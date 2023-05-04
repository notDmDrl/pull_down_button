import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';
import '../_internals/content_size_category.dart';

/// Defines the visual properties of the routes used to display pull-down menus.
///
/// All [PullDownMenuRouteTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [PullDownMenuRouteTheme.defaults].
@immutable
class PullDownMenuRouteTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuRouteTheme].
  const PullDownMenuRouteTheme({
    this.backgroundColor,
    this.borderRadius,
    this.shadow,
    this.width,
    this.accessibilityWidth,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch file.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch file:
  ///   https://developer.apple.com/design/resources/
  @internal
  const factory PullDownMenuRouteTheme.defaults(BuildContext context) =
      _PullDownMenuRouteThemeDefaults;

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius? borderRadius;

  /// The pull-down menu shadow.
  final BoxShadow? shadow;

  /// The width of pull-down menu.
  final double? width;

  /// The accessibility width of pull-down menu.
  ///
  /// The width of pull-down menu when `MediaQuery.of(context).textScaleFactor`
  /// is bigger than [ContentSizeCategory.extraExtraExtraLarge]. At this text
  /// scale factor menu transitions to its bigger size "accessibility" mode.
  final double? accessibilityWidth;

  /// The [PullDownButtonTheme.routeTheme] property of the ambient
  /// [PullDownButtonTheme].
  static PullDownMenuRouteTheme? maybeOf(BuildContext context) =>
      PullDownButtonTheme.maybeOf(context)?.routeTheme;

  /// The helper method to quickly resolve [PullDownMenuRouteTheme] from
  /// [PullDownButtonTheme.routeTheme] or [PullDownMenuRouteTheme.defaults]
  /// as well as from theme data from [PullDownButton] or [showPullDownMenu].
  @internal
  static PullDownMenuRouteTheme resolve(
    BuildContext context, {
    required PullDownMenuRouteTheme? routeTheme,
  }) {
    final theme = PullDownMenuRouteTheme.maybeOf(context);
    final defaults = PullDownMenuRouteTheme.defaults(context);

    return PullDownMenuRouteTheme(
      backgroundColor: routeTheme?.backgroundColor ??
          theme?.backgroundColor ??
          defaults.backgroundColor!,
      borderRadius: routeTheme?.borderRadius ??
          theme?.borderRadius ??
          defaults.borderRadius!,
      shadow: routeTheme?.shadow ?? theme?.shadow ?? defaults.shadow!,
      width: routeTheme?.width ?? theme?.width ?? defaults.width!,
      accessibilityWidth: routeTheme?.accessibilityWidth ??
          theme?.accessibilityWidth ??
          defaults.accessibilityWidth!,
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuRouteTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxShadow? shadow,
    double? width,
    double? accessibilityWidth,
  }) =>
      PullDownMenuRouteTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
        shadow: shadow ?? this.shadow,
        width: width ?? this.width,
        accessibilityWidth: accessibilityWidth ?? this.accessibilityWidth,
      );

  /// Linearly interpolate between two themes.
  static PullDownMenuRouteTheme lerp(
    PullDownMenuRouteTheme? a,
    PullDownMenuRouteTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    return PullDownMenuRouteTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      shadow: BoxShadow.lerp(a?.shadow, b?.shadow, t),
      width: ui.lerpDouble(a?.width, b?.width, t),
      accessibilityWidth:
          ui.lerpDouble(a?.accessibilityWidth, b?.accessibilityWidth, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderRadius,
        shadow,
        width,
        accessibilityWidth,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownMenuRouteTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.shadow == shadow &&
        other.width == width &&
        other.accessibilityWidth == accessibilityWidth;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('borderRadius', borderRadius, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('shadow', shadow, defaultValue: null),
      )
      ..add(
        DoubleProperty('width', width, defaultValue: null),
      )
      ..add(
        DoubleProperty(
          'accessibilityWidth',
          accessibilityWidth,
          defaultValue: null,
        ),
      );
  }
}

/// A set of default values for [PullDownMenuRouteTheme].
@immutable
class _PullDownMenuRouteThemeDefaults extends PullDownMenuRouteTheme {
  /// Creates [_PullDownMenuRouteThemeDefaults].
  const _PullDownMenuRouteThemeDefaults(this.context)
      : super(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          width: 250,
          accessibilityWidth: 390,
          shadow: const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 64,
          ),
        );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark color of the menu's background.
  static const kBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(247, 247, 247, 0.8),
    darkColor: Color.fromRGBO(36, 36, 36, 0.75),
  );

  @override
  Color get backgroundColor => kBackgroundColor.resolveFrom(context);
}
