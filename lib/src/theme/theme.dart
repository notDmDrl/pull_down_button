import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../pull_down_button.dart';

/// Defines the visual properties of the routes used to display pull-down menus
/// as well as any widgets that extend [PullDownMenuEntry].
///
/// Widgets that extend [PullDownMenuEntry] obtain current
/// [PullDownButtonTheme] object using `PullDownTheme.of(context)`.
///
/// [PullDownButtonTheme] should be specified in [ThemeData.extensions] or
/// using [PullDownButtonInheritedTheme] in `builder` property of [MaterialApp]
/// or [CupertinoApp].
///
/// All [PullDownButtonTheme] properties are `null` by default.
/// If any of these properties are null, or some properties of sub-themes are
/// null, the pull-down menu will use iOS 16 defaults specified in each
/// sub-theme.
@immutable
class PullDownButtonTheme extends ThemeExtension<PullDownButtonTheme>
    with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownButtonTheme].
  const PullDownButtonTheme({
    this.routeTheme,
    this.itemTheme,
    this.dividerTheme,
    this.titleTheme,
    this.applyOpacity,
  });

  /// Sub-theme for visual properties of the routes used to display pull-down
  /// menus.
  final PullDownMenuRouteTheme? routeTheme;

  /// Sub-theme for visual properties of the items in pull-down menus.
  final PullDownMenuItemTheme? itemTheme;

  /// Sub-theme for visual properties of the dividers in pull-down menus.
  final PullDownMenuDividerTheme? dividerTheme;

  /// Sub-theme for visual properties of the titles in pull-down menus.
  final PullDownMenuTitleTheme? titleTheme;

  /// Whether to apply opacity on [PullDownButton.buttonBuilder] as it is in iOS
  /// or not.
  final bool? applyOpacity;

  /// Get [PullDownButtonTheme] from [PullDownButtonInheritedTheme].
  ///
  /// If that's null get [PullDownButtonTheme] from [ThemeData.extensions]
  /// property of the ambient [Theme].
  static PullDownButtonTheme? of(BuildContext context) =>
      PullDownButtonInheritedTheme.of(context) ??
      Theme.of(context).extensions[PullDownButtonTheme] as PullDownButtonTheme?;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  @override
  PullDownButtonTheme copyWith({
    PullDownMenuRouteTheme? routeTheme,
    PullDownMenuItemTheme? itemTheme,
    PullDownMenuDividerTheme? dividerTheme,
    PullDownMenuTitleTheme? titleTheme,
    bool? applyOpacity,
  }) =>
      PullDownButtonTheme(
        routeTheme: routeTheme ?? this.routeTheme,
        itemTheme: itemTheme ?? this.itemTheme,
        dividerTheme: dividerTheme ?? this.dividerTheme,
        titleTheme: titleTheme ?? this.titleTheme,
        applyOpacity: applyOpacity ?? this.applyOpacity,
      );

  /// Linearly interpolate between two themes.
  @override
  PullDownButtonTheme lerp(
    ThemeExtension<PullDownButtonTheme>? other,
    double t,
  ) {
    if (other is! PullDownButtonTheme || identical(this, other)) return this;

    return PullDownButtonTheme(
      routeTheme: PullDownMenuRouteTheme.lerp(routeTheme, other.routeTheme, t),
      itemTheme: PullDownMenuItemTheme.lerp(itemTheme, other.itemTheme, t),
      dividerTheme:
          PullDownMenuDividerTheme.lerp(dividerTheme, other.dividerTheme, t),
      titleTheme: PullDownMenuTitleTheme.lerp(titleTheme, other.titleTheme, t),
      applyOpacity: _lerpBool(applyOpacity, other.applyOpacity, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        routeTheme,
        itemTheme,
        dividerTheme,
        titleTheme,
        applyOpacity,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PullDownButtonTheme &&
        other.routeTheme == routeTheme &&
        other.itemTheme == itemTheme &&
        other.dividerTheme == dividerTheme &&
        other.titleTheme == titleTheme &&
        other.applyOpacity == applyOpacity;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty('routeTheme', routeTheme, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('itemTheme', itemTheme, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('dividerTheme', dividerTheme, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('titleTheme', titleTheme, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty('applyOpacity', applyOpacity, defaultValue: null),
      );
  }
}

/// Taken from [ScrollbarThemeData.lerp].
bool? _lerpBool(bool? a, bool? b, double t) => t < 0.5 ? a : b;

/// Alternative way of defining [PullDownButtonTheme].
///
/// Example:
///
/// ```dart
/// CupertinoApp(
///    builder: (context, child) => PullDownInheritedTheme(
///      data: const PullDownTheme(
///        ...
///      ),
///      child: child!,
///  ),
/// home: ...,
/// ```
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
