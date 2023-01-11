## 0.5.0

- Added `showPullDownMenu` - an alternative way to display menu [#12](https://github.com/notDmDrl/pull_down_button/issues/12).
- Following things have been updated to be a lot closer to native variant:
  - Menu open / close animation to use scaling transition.
  - `PullDownMenuTitle` - minimum height to be uqual to native variant.
  - Default colors for `PullDownMenuDividerTheme` and `PullDownMenuRouteTheme`.
  - On menu open opacity for `PullDownButton.buttonBuilder`.
  - `PullDownMenuItem` text style and icon color opacity when `PullDownMenuItem.enabled` is **false**.
- `PullDownMenuItem` and `PullDownMenuTitle` - merge default text styles with provided ones (via theme or widget parameters).

**BREAKING CHANGES**:

- `PullDownMenuEntry` no longer provides fields to override due to their redundancy.
- `PullDownMenuEntry` no longer extends `StatelessWidget`, it now extends `Widget`. This was done to allow `StatefulWidget`s to be used as `PullDownMenuEntry` [#11](https://github.com/notDmDrl/pull_down_button/issues/11).

  Migration:

  ##### Before

  ```dart
  class PullDownMenuItem extends PullDownMenuEntry {
  ```

  ##### After

  ```dart
  class PullDownMenuItem extends StatelessWidget implements PullDownMenuEntry {
  ```

## 0.4.1

- Do not use `BackdropFilter` for blur used in pull-down menu if menu's background color is fully opaque
  [#9](https://github.com/notDmDrl/pull_down_button/issues/9)

## 0.4.0

**BREAKING CHANGES**:

#### Menu items

- Simplified API - action related menu items below are being replaced with `PullDownMenuItem`:
  - Replaced `SelectablePullDownMenuItem` with `PullDownMenuItem.selectable`.
  - Removed `PullDownMenuIconAction` - `PullDownMenuActionsRow` now uses `PullDownMenuItem`.

#### Theming

- Modularize `PullDownButtonTheme` - since `PullDownButtonTheme` was becoming a bit overcrowded all properties where split into 4 sub-themes:

  - routeTheme - menu container theme (`PullDownMenuRouteTheme`).
  - itemTheme - `PullDownMenuItem` theme (`PullDownMenuItemTheme`).
  - dividerTheme - `PullDownMenuDivider` theme (`PullDownMenuDividerTheme`).
  - titleTheme - `PullDownMenuTitle` theme (`PullDownMenuTitleTheme`).

  All customization options that were previously available on menu items are now also using sub-themes.

  Please see [README](README.md#theming) for detailed info about new sub-themes.

  Migration:

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

- Removed `PullDownMenuWidthConfiguration` - use `PullDownMenuRouteTheme.width`.
- `PullDownMenuRouteTheme` - added customization of menu's border radius, begin and end shadows [#8](https://github.com/notDmDrl/pull_down_button/issues/8).

## 0.3.1

- Fixed incorrect padding values for RTL [#7](https://github.com/notDmDrl/pull_down_button/issues/7)

## 0.3.0

- Added `PullDownMenuActionsRow` - displays multiple actions in a row (from iOS 16),
  [iOS docs](https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize).
- New examples.
- Updated readme images.

## 0.2.0-beta.1.1

- Fix issue where it was not possible to open pull-down menu when no items where provided to `PullDownMenuDivider.wrapWithDivider`.
- Updated examples.

**BREAKING CHANGES**:

- Update `PullDownMenuDivider`'s constructors - deprecate (removed any usages) `dividerColor` and `largeDividerColor` from `PullDownMenuDivider` and `PullDownMenuDivider.large` respectively. Both constructors now use same `color` property.

  Migration:

  ```dart
    PullDownMenuDivider(dividerColor: Colors.black) -> PullDownMenuDivider(color: Colors.black)

    PullDownMenuDivider.large(largeDividerColor: Colors.black) -> PullDownMenuDivider.large(color: Colors.black)
  ```

- Default `PullDownMenuPosition` of `PullDownButton` is now `under` since this behaviour is the most frequent across iOS system apps.
- Reworked the way menus are rendered on screen (position and size) and added new position mode `automatic` [#5](https://github.com/notDmDrl/pull_down_button/issues/5):
  - `over` - will attempt to fill as much space as possible.
  - `under` - is forced to be under an anchor. If there is no available space, will be placed above an anchor.
  - `above` - is forced to be above an anchor. If there is no available space, will be placed under an anchor.
  - `automatic` - is positioned under or above an anchor depending on side that has more space available.

## 0.1.0-beta.8

- Added `onHoverTextStyle` to `PullDownButtonTheme`
  [#6](https://github.com/notDmDrl/pull_down_button/issues/6).

## 0.1.0-beta.7

- Added `onHoverColor` to `PullDownButtonTheme` + support for mouse pointers for `PullDownMenuItem`
  [#6](https://github.com/notDmDrl/pull_down_button/issues/6).

## 0.1.0-beta.6

- Added ability to choose to whether apply opacity on menu open for `PullDownButton.buttonBuilder` or not
  [#4](https://github.com/notDmDrl/pull_down_button/issues/4).

## 0.1.0-beta.5

- Added `PullDownMenuWidthConfiguration` to allow customizing pull-down menu's width
  [#3](https://github.com/notDmDrl/pull_down_button/issues/3).

## 0.1.0-beta.4

- Fix `showDialog` (and other actions that change navigation stack) to work directly without any workarounds
  [#1](https://github.com/notDmDrl/pull_down_button/issues/1):

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

- `PullDownMenuItem` and `SelectablePullDownMenuItem` - added `iconColor` and `iconWidget` parameters.
- `PullDownMenuTitle` replace `SizedBox` with `ConstrainedBox` to allow `PullDownMenuTitle` to have adaptive height.
- Update `largeDividerColor` in `PullDownButtonThemeDefaults` to more correct value.
- Fix menu background color "jumping" during open animation.
- Remove Flutter **beta 2.13.0-0** as minimum supported version - now it's **3.0**.

## 0.1.0-beta.3

- Added `PullDownButtonInheritedTheme` as an additional way of defining global `PullDownButtonTheme`
  [#2](https://github.com/notDmDrl/pull_down_button/issues/2).

## 0.1.0-beta.2

- Added shadow behind pull-down menu.
- Update pull-down menu show/hide animations to be more similar to native version.
- `PullDownMenuItem` and `SelectablePullDownMenuItem` - replace `InkWell` with `GestureDetector`.
- Improve pull-down menu positioning on screen.
- Fix pull-down animating from the top instead of bottom for `PullDownMenuPosition.above`.

## 0.1.0-beta.1

- Initial release.
