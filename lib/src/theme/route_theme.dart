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
    this.beginShadow,
    this.endShadow,
    this.width,
    this.largeTextScaleWidth,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  ///
  /// Default properties where taken from community Figma files and direct
  /// color compare with SwiftUI `Menu`.
  ///
  /// See also:
  ///
  /// * iOS 16 UI Kit for Figma by Joey Banks:
  ///   https://www.figma.com/community/file/1121065701252736567.
  /// * iOS 16 UI Kit for Figma by Itty Bitty Apps:
  ///   https://www.figma.com/community/file/1172051389106515682
  @internal
  const factory PullDownMenuRouteTheme.defaults(BuildContext context) =
      _PullDownMenuRouteThemeDefaults;

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius? borderRadius;

  /// The pull-down menu shadow at the moment of the menu being opened.
  ///
  /// Will interpolate to [endShadow] (on open) or from [endShadow] (on close).
  ///
  /// Usually uses [endShadow] color with opacity set to `0` (for smooth color
  /// transition).
  final BoxShadow? beginShadow;

  /// The pull-down menu shadow at the moment of the menu being fully opened.
  ///
  /// Will interpolate from [beginShadow] (on open) or to [beginShadow]
  /// (on close).
  final BoxShadow? endShadow;

  /// The width of pull-down menu.
  final double? width;

  /// The width of pull-down menu when `MediaQuery.of(context).textScaleFactor`
  /// is bigger than [ContentSizeCategory.extraExtraExtraLarge]. At this text
  /// scale factor menu transitions to its bigger size "accessibility" mode.
  final double? largeTextScaleWidth;

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
      beginShadow: routeTheme?.beginShadow ??
          theme?.beginShadow ??
          defaults.beginShadow!,
      endShadow:
          routeTheme?.endShadow ?? theme?.endShadow ?? defaults.endShadow!,
      width: routeTheme?.width ?? theme?.width ?? defaults.width!,
      largeTextScaleWidth: routeTheme?.largeTextScaleWidth ??
          theme?.largeTextScaleWidth ??
          defaults.largeTextScaleWidth!,
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuRouteTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxShadow? beginShadow,
    BoxShadow? endShadow,
    double? width,
    double? largeTextScaleWidth,
  }) =>
      PullDownMenuRouteTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
        beginShadow: beginShadow ?? this.beginShadow,
        endShadow: endShadow ?? this.endShadow,
        width: width ?? this.width,
        largeTextScaleWidth: largeTextScaleWidth ?? this.largeTextScaleWidth,
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
      beginShadow: BoxShadow.lerp(a?.beginShadow, b?.beginShadow, t),
      endShadow: BoxShadow.lerp(a?.endShadow, b?.endShadow, t),
      width: ui.lerpDouble(a?.width, b?.width, t),
      largeTextScaleWidth:
          ui.lerpDouble(a?.largeTextScaleWidth, b?.largeTextScaleWidth, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderRadius,
        beginShadow,
        endShadow,
        width,
        largeTextScaleWidth,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownMenuRouteTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.beginShadow == beginShadow &&
        other.endShadow == endShadow &&
        other.width == width &&
        other.largeTextScaleWidth == largeTextScaleWidth;
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
        DiagnosticsProperty('beginShadow', beginShadow, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('endShadow', endShadow, defaultValue: null),
      )
      ..add(
        DoubleProperty('width', width, defaultValue: null),
      )
      ..add(
        DoubleProperty(
          'largeTextScaleWidth',
          largeTextScaleWidth,
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
          largeTextScaleWidth: 390,
        );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark color of the menu's on open shadow.
  static const kBeginShadowColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0),
    darkColor: Color.fromRGBO(0, 255, 0, 0),
  );

  /// The light and dark color of the menu's on fully open shadow.
  static const kEndShadowColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    darkColor: Color.fromRGBO(0, 255, 0, 0.015),
  );

  /// The light and dark color of the menu's background.
  static const kBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(249, 249, 249, 0.78),
    darkColor: Color.fromRGBO(84, 84, 88, 0.36),
  );

  @override
  Color get backgroundColor => kBackgroundColor.resolveFrom(context);

  @override
  BoxShadow get beginShadow => BoxShadow(
        color: kBeginShadowColor.resolveFrom(context),
      );

  @override
  BoxShadow get endShadow => BoxShadow(
        color: kEndShadowColor.resolveFrom(context),
        blurRadius: 64,
        spreadRadius: 64,
      );
}
