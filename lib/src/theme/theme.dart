import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/pull_down_button.dart';

/// Defines the visual properties of the routes used to display iOS like menus
/// as well as any widgets that can be considered menu items.
///
/// [PullDownButtonTheme] should be specified in [ThemeData.extensions] or using
/// [PullDownButtonInheritedTheme] in the `builder` property of [MaterialApp],
/// [CupertinoApp] or [WidgetsApp].
///
/// All [PullDownButtonTheme] properties are `null` by default. When null,
/// or some properties of sub-themes are `null`, iOS 18 defaults specified in
/// each sub-theme will be used.
///
/// See also:
///
/// * [PullDownMenuDividerTheme], a sub-theme for the dividers and separators
/// in menus.
/// * [PullDownMenuItemTheme], a sub-theme for [PullDownMenuItem].
/// * [PullDownMenuRouteTheme], a sub-theme for overall menu visual.
/// * [PullDownMenuTitleTheme], a sub-theme for [PullDownMenuTitle].
/// * [PullDownButtonInheritedTheme], an alternative way of defining global
/// [PullDownButtonTheme].
@immutable
class PullDownButtonTheme extends ThemeExtension<PullDownButtonTheme>
    with Diagnosticable {
  /// Creates the set of properties used to configure [PullDownButtonTheme].
  const PullDownButtonTheme({
    this.routeTheme = const PullDownMenuRouteTheme(),
    this.itemTheme = const PullDownMenuItemTheme(),
    this.dividerTheme = const PullDownMenuDividerTheme(),
    this.titleTheme = const PullDownMenuTitleTheme(),
  });

  /// Sub-theme for visual properties of the routes used to display pull-down
  /// menus.
  final PullDownMenuRouteTheme routeTheme;

  /// Sub-theme for visual properties of the items in pull-down menus.
  final PullDownMenuItemTheme itemTheme;

  /// Sub-theme for visual properties of the dividers and separators in
  /// pull-down menus.
  final PullDownMenuDividerTheme dividerTheme;

  /// Sub-theme for visual properties of the titles in pull-down menus.
  final PullDownMenuTitleTheme titleTheme;

  /// Returns the current ambient [PullDownButtonTheme].
  ///
  /// At first tries to get [PullDownButtonTheme] from
  /// [PullDownButtonInheritedTheme]. If that's null, gets [PullDownButtonTheme]
  /// from the ambient [Theme] extensions.
  static PullDownButtonTheme? maybeOf(BuildContext context) =>
      PullDownButtonInheritedTheme.maybeOf(context) ??
      Theme.of(context).extension<PullDownButtonTheme>();

  /// Returns resolved ambient [PullDownButtonTheme] by mixing non-null values
  /// from each sub-themes from ambient [PullDownButtonTheme] with their
  /// respective default values.
  @internal
  static PullDownButtonTheme ambientOf(BuildContext context) {
    final PullDownButtonTheme? ambientTheme = maybeOf(context);

    final dividerDefaults = PullDownMenuDividerTheme.defaults(context);
    final titleDefaults = PullDownMenuTitleTheme.defaults(context);
    final routeDefaults = PullDownMenuRouteTheme.defaults(context);
    final itemDefaults = PullDownMenuItemTheme.defaults(context);

    if (ambientTheme == null) {
      return PullDownButtonTheme(
        routeTheme: routeDefaults,
        dividerTheme: dividerDefaults,
        itemTheme: itemDefaults,
        titleTheme: titleDefaults,
      );
    }

    return PullDownButtonTheme(
      routeTheme: _resolveRoute(routeDefaults, ambientTheme.routeTheme),
      itemTheme: _resolveItem(itemDefaults, ambientTheme.itemTheme),
      dividerTheme: _resolveDivider(dividerDefaults, ambientTheme.dividerTheme),
      titleTheme: _resolveTitle(titleDefaults, ambientTheme.titleTheme),
    );
  }

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  @override
  PullDownButtonTheme copyWith({
    PullDownMenuRouteTheme? routeTheme,
    PullDownMenuItemTheme? itemTheme,
    PullDownMenuDividerTheme? dividerTheme,
    PullDownMenuTitleTheme? titleTheme,
  }) => PullDownButtonTheme(
    routeTheme: routeTheme ?? this.routeTheme,
    itemTheme: itemTheme ?? this.itemTheme,
    dividerTheme: dividerTheme ?? this.dividerTheme,
    titleTheme: titleTheme ?? this.titleTheme,
  );

  /// Linearly interpolates between two [PullDownButtonTheme] themes.
  @override
  PullDownButtonTheme lerp(
    ThemeExtension<PullDownButtonTheme>? other,
    double t,
  ) {
    if (other is! PullDownButtonTheme || identical(this, other)) {
      return this;
    }

    return PullDownButtonTheme(
      routeTheme: PullDownMenuRouteTheme.lerp(routeTheme, other.routeTheme, t),
      itemTheme: PullDownMenuItemTheme.lerp(itemTheme, other.itemTheme, t),
      dividerTheme: PullDownMenuDividerTheme.lerp(
        dividerTheme,
        other.dividerTheme,
        t,
      ),
      titleTheme: PullDownMenuTitleTheme.lerp(titleTheme, other.titleTheme, t),
    );
  }

  @override
  int get hashCode => Object.hash(
    routeTheme,
    itemTheme,
    dividerTheme,
    titleTheme,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PullDownButtonTheme &&
        other.routeTheme == routeTheme &&
        other.itemTheme == itemTheme &&
        other.dividerTheme == dividerTheme &&
        other.titleTheme == titleTheme;
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
      );
  }
}

/// An alternative way of defining global [PullDownButtonTheme].
///
/// Useful for the cases when defining [PullDownButtonTheme] inside of
/// [ThemeData.extensions] is not possible (for example while using
/// [CupertinoApp]).
///
/// Example:
///
/// ```dart
/// CupertinoApp(
///   builder: (context, child) => PullDownInheritedTheme(
///     data: const PullDownButtonTheme(...),
///     child: child!,
///   ),
///   home: ...,
/// )
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

  /// Returns the current [PullDownButtonTheme] from the closest
  /// [PullDownButtonInheritedTheme] ancestor.
  ///
  /// If there is no ancestor, it returns `null`.
  static PullDownButtonTheme? maybeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PullDownButtonInheritedTheme>()
          ?.data;

  @override
  bool updateShouldNotify(PullDownButtonInheritedTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      PullDownButtonInheritedTheme(
        data: data,
        child: child,
      );
}

/// Resolves [PullDownMenuDividerTheme] with current [ambient] divider theme.
PullDownMenuDividerTheme _resolveDivider(
  PullDownMenuDividerTheme defaults,
  PullDownMenuDividerTheme ambient,
) => defaults.copyWith(
  dividerColor: ambient.dividerColor,
  largeDividerColor: ambient.largeDividerColor,
);

/// Resolves [PullDownMenuTitleTheme] with current [ambient] title theme.
PullDownMenuTitleTheme _resolveTitle(
  PullDownMenuTitleTheme defaults,
  PullDownMenuTitleTheme ambient,
) => defaults.copyWith(
  style: defaults.style!.merge(ambient.style),
);

/// Resolves [PullDownMenuRouteTheme] with current [ambient] route theme.
PullDownMenuRouteTheme _resolveRoute(
  PullDownMenuRouteTheme defaults,
  PullDownMenuRouteTheme ambient,
) => defaults.copyWith(
  backgroundColor: ambient.backgroundColor,
  borderRadius: ambient.borderRadius,
  borderClipper: ambient.borderClipper,
  shadow: ambient.shadow,
  width: ambient.width,
  accessibilityWidth: ambient.accessibilityWidth,
);

PullDownMenuItemTheme _resolveItem(
  PullDownMenuItemTheme defaults,
  PullDownMenuItemTheme ambient,
) => defaults.copyWith(
  destructiveColor: ambient.destructiveColor,
  checkmark: ambient.checkmark,
  textStyle: defaults.textStyle!.merge(ambient.textStyle),
  subtitleStyle: defaults.subtitleStyle!.merge(ambient.subtitleStyle),
  iconActionTextStyle: defaults.iconActionTextStyle!.merge(
    ambient.iconActionTextStyle,
  ),
  onHoverBackgroundColor: ambient.onHoverBackgroundColor,
  onPressedBackgroundColor: ambient.onPressedBackgroundColor,
  onHoverTextColor: ambient.onHoverTextColor,
);
