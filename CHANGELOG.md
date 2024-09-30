## 0.10.2

##### 2024-09-30 - Desktop scrollbar fixes

### Fixed

-   Fix `ScrollController` related warnings ([#58](https://github.com/notDmDrl/pull_down_button/issues/58)).
-   Fix desktop platforms having a duplicate scrollbar.

## 0.10.1

##### 2024-08-06 - Fixes for nested navigators

### Fixed

-   Fix incorrect menu position inside of nested navigators ([#54](https://github.com/notDmDrl/pull_down_button/issues/54), [#55](https://github.com/notDmDrl/pull_down_button/pull/55)). Thanks to [@kekland](https://github.com/kekland).

## 0.10.0

##### 2024-08-03 - Multiple small improvements

### Changed

-   Bump Flutter minimum supported version from **3.0** to **3.19.0**.
-   Bump Dart minimum supported version from **2.17.0** to **3.3.0**.
-   Change the default font family of pull-down menu items to `CupertinoSystemText` as it is the current default font family in Flutter's cupertino widgets.

### Added

-   Add `useRootNavigator` to `PullDownButton` and `showPullDownMenu` ([#49](https://github.com/notDmDrl/pull_down_button/pull/49)). Thanks to [@gborges9](https://github.com/gborges9).
-   Add `routeSettings` to `PullDownButton` and `showPullDownMenu` ([#53](https://github.com/notDmDrl/pull_down_button/issues/53)).
-   Add `isOpen` helper getter to `PullDownMenuButtonBuilder` ([#52](https://github.com/notDmDrl/pull_down_button/pull/52)). Thanks to [@vizakenjack](https://github.com/vizakenjack).
-   Add `PullDownMenuHeader.leadingBuilder` to allow a more flexible creation of the header's leading widget ([#50](https://github.com/notDmDrl/pull_down_button/issues/50)).

## 0.9.4

##### 2024-04-18 - Menu animation alignment override

### Added

-   Add `animationAlignmentOverride` to `PullDownButton`. _This feature is experimental and may be removed in the future versions._
-   Add example for `PullDownButton.animationAlignmentOverride`.

## 0.9.3

##### 2023-07-28 - Menu scroll controller

### Added

-   Add `scrollController` to `PullDownButton`, `PullDownMenu` and `showPullDownMenu` to allow passing custom scroll controller ([#31](https://github.com/notDmDrl/pull_down_button/issues/31)).

### Removed

-   **Breaking:** remove `initialScrollOffset` from `PullDownButton`, `PullDownMenu` and `showPullDownMenu` to allow more precise scroll controller customization using `scrollController`.

## 0.9.2

##### 2023-07-20 - Add support for menu offsets

### Fixed

-   Fix menu items being "stuck" in the highlighted mode in scrollable menus (partially [#29](https://github.com/notDmDrl/pull_down_button/issues/29)).

### Added

-   Add `menuOffset` to `PullDownButton` and `showPullDownMenu` to allow customizing the menu's horizontal offset ([#32](https://github.com/notDmDrl/pull_down_button/issues/32)).
-   Expose `initialScrollOffset` from internal scrollable to `PullDownButton`, `PullDownMenu` and `showPullDownMenu` to allow customizing initial scroll offset ([#31](https://github.com/notDmDrl/pull_down_button/issues/31)).

## 0.9.1

###### 2023-05-05 - README images fixes

### Changed

-   Use correct image for `PullDownMenuHeader` in README.

## 0.9.0

###### 2023-05-05 - Match guidelines from the Apple Design Resources Sketch file

### Changed

-   Update the following stuff based on guidelines defined in the Apple Design Resources Sketch file:
    -   Update menu blur to include color saturation.
    -   Update the `PullDownMenuItem` layout.
    -   Update the `PullDownMenuTitle` layout.
    -   Update default height for `PullDownMenuActionsRow`.
    -   Update default height for `PullDownMenuTitle`.
    -   Update default theme values for all sub-themes.
-   Update the example app to include newly added stuff.
-   Deprecate `PullDownMenuDivider` and `PullDownMenuDivider.wrapWithDivider`. _Menu now inserts small dividers automatically._
-   **Breaking:** rename `PullDownMenuRouteTheme.largeTextScaleWidth` to `PullDownMenuRouteTheme.accessibilityWidth`.

### Added

-   Add `PullDownMenuHeader`. Based on [UIDocumentProperties](https://developer.apple.com/documentation/uikit/uidocumentproperties) from iOS 16.
-   Add `subtitle` to `PullDownMenuItem` and `PullDownMenuItem.selectable`.
-   Add `PullDownMenuTitle.alignment` to allow customizing alignment of `PullDownMenuTitle`.
-   Add `subtitleStyle`, `onHoverBackgroundColor`, `onPressedBackgroundColor`, and `onHoverTextColor` to `PullDownMenuItemTheme`.

### Removed

-   **Breaking:** remove `dividerColor` from `PullDownMenuActionsRow`.
-   **Breaking:** remove `iconSize`, `checkmarkWeight`, `checkmarkSize` from `PullDownMenuItemTheme`.
-   **Breaking:** remove `onHoverColor` from `PullDownMenuItemTheme`. _Use `onHoverBackgroundColor` instead._
-   **Breaking:** remove `onHoverTextStyle` from `PullDownMenuItemTheme`. _Use `onHoverTextColor` instead._
-   **Breaking:** remove `beginShadow` and `endShadow` from `PullDownMenuRouteTheme`. _Use `shadow` instead._

## 0.8.3

###### 2023-04-21 - Support iOS 16 "Large Text" accessibility options

### Changed

-   Update menu items layouts to support all options in iOS 16 "Large Text" accessibility menu.

### Added

-   `PullDownMenuRouteTheme.largeTextScaleWidth` to allow customizing the menu's "accessibility" width.

## 0.8.2

###### 2023-04-11 - "Anchoring" to specific button side

### Changed

-   Rename all nullable `of(context)` methods to `maybeOf(context)` to follow Flutter repo style.

### Added

-   Add `PullDownButton.buttonAnchor` to allow "anchoring" menu to specific button side ([#22](https://github.com/notDmDrl/pull_down_button/issues/22)).
-   Add an example for `PullDownButton.buttonAnchor`. See _Examples -> Advanced_ in the example app.
-   Add haptic feedback when sliding between items (as seen in iOS).

## 0.8.1

###### 2023-03-30 - Fixes for menu position calculations

### Added

-   Add precautions to menu position calculations for cases when `PullDownButton.buttonBuilder`'s height is bigger than the screen height ([#21](https://github.com/notDmDrl/pull_down_button/issues/21)).

    _Consider using `showPullDownMenu` if the end position calculated using those precautions is not what was desired._

## 0.8.0

###### 2023-03-30 - Improved menu positioning, new customization options

### Changed

-   **Breaking:** `showPullDownMenu` _position_ now requires `Rect` instead of `RelativeRect`.
-   Reworked the way the pull-down menu calculates its position on the screen:
    -   Updated menu's scale transition alignment calculation to closely match native.
    -   If opened from the left or right side of the screen (but not directly near the edge), additionally move the menu to the left or right by a certain amount of pixels (based on the native compare tool).

### Added

-   Add `PullDownMenuItem.delayedTapHandler`.
-   Add `PullDownButton.animationBuilder` to allow customization of animation for `PullDownButton.buttonBuilder` when the pull-down menu is opening or closing.
-   Add an example for `PullDownButton.animationBuilder`. See _Examples -> Advanced_ in the example app.

### Removed

-   **Breaking:** remove `PullDownMenuPosition.under` and `PullDownMenuPosition.above`.
    _`PullDownMenuPosition.automatic` should be used instead (new default)._
-   **Breaking:** remove `buttonSize` and `menuPosition` from `showPullDownMenu`.
-   **Breaking:** `PullDownButton.applyOpacity` and `PullDownButtonTheme.applyOpacity`.
    _To remove opacity animation from `PullDownButton.buttonBuilder` set `PullDownButton.animationBuilder` to **null**._
-   **Breaking:** remove `PullDownButton.offset`.

## 0.7.0

###### 2023-03-15 - Continuous swipe

### Added

-   Add "continuous swipe" support to menus (see [demo](https://github.com/notDmDrl/pull_down_button/issues/19)) ([#19](https://github.com/notDmDrl/pull_down_button/issues/19), [#18](https://github.com/notDmDrl/pull_down_button/pull/18)).

    Thanks to [@iSa1vatore](https://github.com/iSa1vatore).

## 0.6.5

###### 2023-03-15 - PullDownMenu

### Changed

-   Update `PullDownMenuItem.defaultTapHandler` to work with `PullDownMenu`.

### Added

-   Add `PullDownMenu` - a pull-down menu as a simple widget, with no animations or adding routes to the navigation stack ([#17](https://github.com/notDmDrl/pull_down_button/issues/17)).

## 0.6.4

###### 2023-03-14 - PullDownMenuItem.tapHandler

### Added

-   Add `PullDownMenuItem.tapHandler` to allow customization of how
    `PullDownMenuItem.onTap` is handled ([#16](https://github.com/notDmDrl/pull_down_button/issues/16)).
-   Add an example for `PullDownMenuItem.tapHandler`. See _Examples -> Advanced_ in the example app.

## 0.6.3+1

###### 2023-03-08 - Animation improvements

### Changed

-   Add clamped animation for menu animations, updated shadow animation.

### Fixed

-   Fix `PullDownMenuItemTheme.lerp` using incorrect text styles for lerping.

## 0.6.2

###### 2023-02-26 - Animation improvements

### Changed

-   Add menu height transition and updated open animation curve ([#14](https://github.com/notDmDrl/pull_down_button/issues/14), [#15](https://github.com/notDmDrl/pull_down_button/pull/15)).

    Thanks to [@iSa1vatore](https://github.com/iSa1vatore).

## 0.6.1

###### 2023-02-24 - Layout fixes

### Fixed

-   Fix the `PullDownMenuActionsRow` items content not being centered.

## 0.6.0

###### 2023-02-23 - Bringing looks closer to native

### Changed

-   Update padding values for `PullDownMenuItem`.
-   Update open/close animation curves - open curve now includes "bouncy" effect native counterpart has ([#13](https://github.com/notDmDrl/pull_down_button/issues/13)).
    -   _Note: new curves are still not 100% equal to native, but slightly more similar than before._
-   Apply an additional small amount of padding for menu positioning if the button is smaller than 44px.
-   Update text style, checkmark configuration in `PullDownMenuItemTheme` defaults.
-   Update shadows for dark mode in `PullDownMenuRouteTheme` defaults.

### Added

-   Add `PullDownMenuItemsOrder` - an ordering logic for `PullDownButton` and `showPullDownMenu` items.
-   Add native compare tool.

## 0.5.1

###### 2023-01-23 - Text style merge fixes

### Fixed

-   Fix `PullDownMenuItem.itemTheme.textStyle` being overridden by global `PullDownButtonTheme.itemTheme.textStyle` during text styles marge in `PullDownMenuItem` and `PullDownMenuTitle` if both are not null.

## 0.5.0

###### 2023-01-11 - Bringing looks closer to native

### Changed

-   **Breaking:** `PullDownMenuEntry` no longer extends `StatelessWidget`, it now extends `Widget`. This was done to allow `StatefulWidget`s to be used as `PullDownMenuEntry` ([#11](https://github.com/notDmDrl/pull_down_button/issues/11)).
-   **Breaking:** `PullDownMenuEntry` no longer provides fields to override due to their redundancy.
-   Following things have been updated to be a lot closer to native variant:
    -   Menu open / close animation to use scaling transition.
    -   `PullDownMenuTitle` - minimum height to be equal to native variant.
    -   Default colors for `PullDownMenuDividerTheme` and `PullDownMenuRouteTheme`.
    -   On menu open opacity for `PullDownButton.buttonBuilder`.
    -   `PullDownMenuItem` text style and icon color opacity when `PullDownMenuItem.enabled` is **false**.
-   `PullDownMenuItem` and `PullDownMenuTitle` - merge default text styles with provided ones (via theme or widget parameters).

### Added

-   Add `showPullDownMenu` - an alternative way to display menu ([#12](https://github.com/notDmDrl/pull_down_button/issues/12)).

## 0.4.1

###### 2022-12-03 - Blur fixes

### Changed

-   Update menu to not use `BackdropFilter` for blur used in pull-down menu if menu's background color is fully opaque ([#9](https://github.com/notDmDrl/pull_down_button/issues/9)).

## 0.4.0

###### 2022-11-22 - Theming overhaul

### Changed

_Please see [README](README.md#theming) for detailed info about new sub-themes._

-   Modularize `PullDownButtonTheme` - all properties where split into 4 sub-themes:
    -   routeTheme - menu container theme (`PullDownMenuRouteTheme`).
    -   itemTheme - `PullDownMenuItem` theme (`PullDownMenuItemTheme`).
    -   dividerTheme - `PullDownMenuDivider` theme (`PullDownMenuDividerTheme`).
    -   titleTheme - `PullDownMenuTitle` theme (`PullDownMenuTitleTheme`).
-   All customization options that were previously available on menu items are now also using sub-themes.

<details><summary>Migration</summary>

##### Before

```dart
PullDownButtonTheme(
  backgroundColor: colorScheme.surface,
  dividerColor: colorScheme.outline,
  largeDividerColor: colorScheme.outlineVariant,
  destructiveColor: colorScheme.error,
  textStyle: TextStyle(
    color: colorScheme.onSurface,
  ),
  titleStyle: TextStyle(
    color: colorScheme.onSurface,
  ),
  widthConfiguration: const PullDownMenuWidthConfiguration(280),
)
```

##### After

```dart
PullDownButtonTheme(
  routeTheme: PullDownMenuRouteTheme(
    backgroundColor: colorScheme.surface,
    width: 280,
  ),
  dividerTheme: PullDownMenuDividerTheme(
    dividerColor: colorScheme.outline,
    largeDividerColor: colorScheme.outlineVariant,
  ),
  itemTheme: PullDownMenuItemTheme(
    destructiveColor: colorScheme.error,
    textStyle: TextStyle(
      color: colorScheme.onSurface,
    ),
  ),
  titleTheme: PullDownMenuTitleTheme(
    style: TextStyle(
      color: colorScheme.onSurface,
    ),
  ),
)
```

</details>

### Added

-   Add customization of menu's border radius, begin and end shadows to `PullDownMenuRouteTheme` ([#8](https://github.com/notDmDrl/pull_down_button/issues/8)).

### Removed

-   **Breaking:** replace `SelectablePullDownMenuItem` with `PullDownMenuItem.selectable`.
-   **Breaking:** remove `PullDownMenuIconAction` - `PullDownMenuActionsRow` now uses `PullDownMenuItem`.
-   **Breaking:** remove `PullDownMenuWidthConfiguration` - use `PullDownMenuRouteTheme.width`.

## 0.3.1

###### 2022-10-11 - Fixes for RTL

### Fixed

-   Fix incorrect padding values for RTL ([#7](https://github.com/notDmDrl/pull_down_button/issues/7)).

## 0.3.0

###### 2022-10-03 - PullDownMenuActionsRow

### Added

-   Add `PullDownMenuActionsRow` - displays multiple actions in a row (from [iOS 16](https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize)).
-   Add new example app.

## 0.2.0-beta.1.1

###### 2022-09-27 - PullDownMenuPosition.automatic

### Changed

-   **Breaking:** update `PullDownMenuDivider`'s constructors - deprecate (removed any usages) `dividerColor` and `largeDividerColor` from `PullDownMenuDivider` and `PullDownMenuDivider.large` respectively. Both constructors now use same `color` property.
-   Default `PullDownMenuPosition` of `PullDownButton` is now `under` since this behaviour is the most frequent across iOS system apps.
-   Rework the way menus are rendered on screen (position and size) and added new position mode `automatic` ([#5](https://github.com/notDmDrl/pull_down_button/issues/5)):
    -   `over` - will attempt to fill as much space as possible.
    -   `under` - is forced to be under an anchor. If there is no available space, will be placed above an anchor.
    -   `above` - is forced to be above an anchor. If there is no available space, will be placed under an anchor.
    -   `automatic` - is positioned under or above an anchor depending on side that has more space available.

### Fixed

-   Fix issue where it was not possible to open pull-down menu when no items where provided to `PullDownMenuDivider.wrapWithDivider`.

## 0.1.0-beta.8

###### 2022-09-07 - PullDownMenuItem on hover support part 2

### Added

-   Add `onHoverTextStyle` to `PullDownButtonTheme` ([#6](https://github.com/notDmDrl/pull_down_button/issues/6)).

## 0.1.0-beta.7

###### 2022-09-06 - PullDownMenuItem on hover support part 1

### Added

-   Add support for mouse pointers for `PullDownMenuItem`.
-   Add `onHoverColor` to `PullDownButtonTheme` ([#6](https://github.com/notDmDrl/pull_down_button/issues/6)).

## 0.1.0-beta.6

###### 2022-07-14 - Opacity for PullDownButton.buttonBuilder

### Added

-   Add ability to choose to whether apply opacity on menu open for `PullDownButton.buttonBuilder` or not ([#4](https://github.com/notDmDrl/pull_down_button/issues/4)).

## 0.1.0-beta.5

###### 2022-07-06 - Menu width

### Added

-   Add `PullDownMenuWidthConfiguration` to allow customizing pull-down menu's width ([#3](https://github.com/notDmDrl/pull_down_button/issues/3)).

## 0.1.0-beta.4

###### 2022-06-29 - Various fixes

### Changed

-   Replace `SizedBox` with `ConstrainedBox` in `PullDownMenuTitle` to allow `PullDownMenuTitle` to have adaptive height.
-   Update `largeDividerColor` in `PullDownButtonThemeDefaults` to more correct value.
-   Bump Flutter minimum supported version from **beta 2.13.0-0** to **3.0**.

### Added

-   Add `iconColor` and `iconWidget` parameters to `PullDownMenuItem` and `SelectablePullDownMenuItem`.

### Fixed

-   Fix menu background color "jumping" during open animation.
-   Fix `showDialog` (and other actions that change navigation stack) to work directly without any workarounds ([#1](https://github.com/notDmDrl/pull_down_button/issues/1)):

<details><summary>Migration</summary>

Instead of

```dart
onTap: () async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await showDialog<void>(
        context: context,
        builder: (context) => ...,
    );
},
```

Now is possible to write it like this:

```dart
onTap: () => showDialog<void>(
    context: context,
    builder: (context) => ...,
),
```

</details>

## 0.1.0-beta.3

###### 2022-06-16 - PullDownButtonInheritedTheme

### Added

-   Add `PullDownButtonInheritedTheme` as an additional way of defining global `PullDownButtonTheme` ([#2](https://github.com/notDmDrl/pull_down_button/issues/2)).

## 0.1.0-beta.2

###### 2022-05-26 - Improvements

### Changed

-   Update pull-down menu show/hide animations to be more similar to native version.
-   Improve pull-down menu positioning on screen.
-   Add shadow behind pull-down menu.

### Fixed

-   Fix pull-down menu animating from the top instead of bottom for `PullDownMenuPosition.above`.

## 0.1.0-beta.1

###### 2022-05-25 - Initial release
