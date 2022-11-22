import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../pull_down_button.dart';

/// Defines the visual properties of the routes used to display pull-down menus.
///
/// All [PullDownMenuRouteTheme] properties are `null` by default. When null,
/// the pull-down menu will use iOS 16 defaults specified in
/// [_PullDownMenuRouteThemeDefaults].
@immutable
class PullDownMenuRouteTheme {
  /// Creates the set of properties used to configure [PullDownMenuRouteTheme].
  const PullDownMenuRouteTheme({
    this.backgroundColor,
    this.borderRadius,
    this.beginShadow,
    this.endShadow,
    this.width,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  @internal
  const factory PullDownMenuRouteTheme.defaults(BuildContext context) =
      _PullDownMenuRouteThemeDefaults;

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius? borderRadius;

  /// The pull-down menu shadow at the moment of menu being opened.
  ///
  /// Will interpolate to [endShadow] (on open) or from [endShadow] (on close).
  ///
  /// Usually uses [endShadow] color with opacity set to `0` (for smooth color
  /// transition).
  final BoxShadow? beginShadow;

  /// The pull-down menu shadow at the moment of menu being fully opened.
  ///
  /// Will interpolate from [beginShadow] (on open) or to [beginShadow]
  /// (on close).
  final BoxShadow? endShadow;

  /// The width of pull-down menu.
  final double? width;

  /// The [PullDownButtonTheme.routeTheme] property of the ambient
  /// [PullDownButtonTheme].
  static PullDownMenuRouteTheme? of(BuildContext context) =>
      PullDownButtonTheme.of(context)?.routeTheme;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuRouteTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxShadow? beginShadow,
    BoxShadow? endShadow,
    double? width,
  }) =>
      PullDownMenuRouteTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        borderRadius: borderRadius ?? this.borderRadius,
        beginShadow: beginShadow ?? this.beginShadow,
        endShadow: endShadow ?? this.endShadow,
        width: width ?? this.width,
      );

  /// Linearly interpolate between two themes.
  static PullDownMenuRouteTheme lerp(
    PullDownMenuRouteTheme? a,
    PullDownMenuRouteTheme? b,
    double t,
  ) =>
      PullDownMenuRouteTheme(
        backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
        borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
        beginShadow: BoxShadow.lerp(a?.beginShadow, b?.beginShadow, t),
        endShadow: BoxShadow.lerp(a?.endShadow, b?.endShadow, t),
        width: ui.lerpDouble(a?.width, b?.width, t),
      );

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderRadius,
        beginShadow,
        endShadow,
        width,
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
        other.width == width;
  }
}

// Based on values from https://www.figma.com/community/file/1121065701252736567.
@immutable
class _PullDownMenuRouteThemeDefaults extends PullDownMenuRouteTheme {
  const _PullDownMenuRouteThemeDefaults(this.context)
      : super(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          beginShadow: const BoxShadow(color: Color.fromRGBO(0, 0, 0, 0)),
          endShadow: const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 64,
            spreadRadius: 64,
          ),
          width: 250,
        );

  final BuildContext context;

  static const kBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color.fromRGBO(237, 237, 237, 0.8),
    darkColor: Color.fromRGBO(37, 37, 37, 0.5),
  );

  @override
  Color get backgroundColor => kBackgroundColor.resolveFrom(context);
}
