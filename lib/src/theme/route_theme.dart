/// @docImport '/pull_down_button.dart';
/// @docImport '/src/internals/content_size_category.dart';
library;

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '/src/internals/content_size_category.dart';
import '_dynamic_color.dart';
import 'theme.dart';

/// Signature for the callback invoked when pull-down menu's body is being
/// built.
///
/// The [borderRadius] is passed from [PullDownMenuRouteTheme.borderRadius].
///
/// Used by [PullDownMenuRouteTheme.borderClipper].
@experimental
typedef PullDownMenuRouteBorderClipper =
    SingleChildRenderObjectWidget Function(
      BorderRadius borderRadius,
      Widget child,
    );

/// Defines the visual properties of the pull-down menus.
///
/// Is used by the menu's container.
///
/// Typically a [PullDownMenuRouteTheme] is specified as part of the overall
/// [PullDownButtonTheme] with [PullDownButtonTheme.routeTheme].
///
/// All [PullDownMenuRouteTheme] properties are `null` by default. When null,
/// defined earlier use cases will use the values from [PullDownButtonTheme]
/// if they exist, otherwise it will use iOS 18 defaults specified in
/// [PullDownMenuRouteTheme.defaults].
@immutable
class PullDownMenuRouteTheme with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownMenuRouteTheme].
  const PullDownMenuRouteTheme({
    this.backgroundColor,
    this.borderRadius,
    this.borderClipper,
    this.shadow,
    this.width,
    this.accessibilityWidth,
  });

  /// Creates default set of properties used to configure
  /// [PullDownMenuRouteTheme].
  ///
  /// Default properties were taken from the Apple Design Resources Sketch and
  /// Figma libraries for iOS 18 and iPadOS 18.
  ///
  /// See also:
  ///
  /// * Apple Design Resources Sketch and Figma [libraries](https://developer.apple.com/design/resources/)
  @internal
  const factory PullDownMenuRouteTheme.defaults(BuildContext context) =
      _Defaults;

  /// The background color of the pull-down menu.
  final Color? backgroundColor;

  /// The border radius of the pull-down menu.
  final BorderRadius? borderRadius;

  /// The border radius clipper of the pull-down menu.
  ///
  /// Can be set to [ClipRSuperellipse] on newer Flutter versions past 3.32.0
  /// with Impeller enabled.
  ///
  /// The *borderRadius* is passed from [PullDownMenuRouteTheme.borderRadius].
  ///
  /// If null, defaults to [ClipRRect].
  ///
  /// Example:
  ///
  /// ```dart
  /// PullDownMenuRouteTheme(
  ///   borderClipper: (borderRadius, child) =>
  ///     ClipRSuperellipse(
  ///       borderRadius: borderRadius,
  ///       child: child,
  ///     ),
  /// )
  /// ```
  @experimental
  final PullDownMenuRouteBorderClipper? borderClipper;

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

  /// The helper method to quickly resolve [PullDownMenuRouteTheme]'s width from
  /// [PullDownButtonTheme.routeTheme] or [PullDownMenuRouteTheme.defaults].
  ///
  /// Usually used to offset the menu position in [PullDownButton.menuOffset].
  static double resolvedWidthOf(BuildContext context) {
    final PullDownMenuRouteTheme routeTheme =
        PullDownButtonTheme.ambientOf(context).routeTheme;

    return ContentSizeCategory.isInAccessibilityMode(context)
        ? routeTheme.accessibilityWidth!
        : routeTheme.width!;
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  PullDownMenuRouteTheme copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxShadow? shadow,
    double? width,
    double? accessibilityWidth,
    PullDownMenuRouteBorderClipper? borderClipper,
  }) => PullDownMenuRouteTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    shadow: shadow ?? this.shadow,
    width: width ?? this.width,
    accessibilityWidth: accessibilityWidth ?? this.accessibilityWidth,
    borderClipper: borderClipper ?? this.borderClipper,
  );

  /// Linearly interpolate between two themes.
  static PullDownMenuRouteTheme lerp(
    PullDownMenuRouteTheme? a,
    PullDownMenuRouteTheme? b,
    double t,
  ) {
    if (identical(a, b) && a != null) {
      return a;
    }

    return PullDownMenuRouteTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      shadow: BoxShadow.lerp(a?.shadow, b?.shadow, t),
      width: ui.lerpDouble(a?.width, b?.width, t),
      accessibilityWidth: ui.lerpDouble(
        a?.accessibilityWidth,
        b?.accessibilityWidth,
        t,
      ),
      borderClipper: t < 0.5 ? a?.borderClipper : b?.borderClipper,
    );
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    borderRadius,
    shadow,
    width,
    accessibilityWidth,
    borderClipper,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownMenuRouteTheme &&
        other.backgroundColor == backgroundColor &&
        other.borderRadius == borderRadius &&
        other.shadow == shadow &&
        other.width == width &&
        other.accessibilityWidth == accessibilityWidth &&
        other.borderClipper == borderClipper;
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
      )
      ..add(
        DiagnosticsProperty('borderClipper', borderClipper, defaultValue: null),
      );
  }
}

/// A set of default values for [PullDownMenuRouteTheme].
@immutable
class _Defaults extends PullDownMenuRouteTheme {
  /// Creates [_Defaults].
  const _Defaults(this.context)
    : super(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderClipper: _defaultBorderClipper,
        width: 250,
        accessibilityWidth: 370,
        shadow: const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.2),
          blurRadius: 32,
        ),
      );

  static ClipRRect _defaultBorderClipper(
    BorderRadius borderRadius,
    Widget child,
  ) => ClipRRect(
    borderRadius: borderRadius,
    child: child,
  );

  /// A build context used to resolve [CupertinoDynamicColor]s defined in this
  /// theme.
  final BuildContext context;

  /// The light and dark color of the menu's background.
  static const kBackgroundColor = SimpleDynamicColor(
    color: Color.fromRGBO(247, 247, 247, 0.8),
    darkColor: Color.fromRGBO(36, 36, 36, 0.75),
  );

  @override
  Color get backgroundColor => kBackgroundColor.resolveFrom(context);
}
