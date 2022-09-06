## 0.1.0-beta.7

- Added `onHoverColor` to `PullDownButtonTheme` + support for mouse pointers for `PullDownMenuItem` -
  [issue](https://github.com/notDmDrl/pull_down_button/issues/6).

## 0.1.0-beta.6

- Added ability to choose to whether apply opacity on menu open for `PullDownButton.buttonBuilder` or not -
  [issue](https://github.com/notDmDrl/pull_down_button/issues/4).

## 0.1.0-beta.5

- Added `PullDownMenuWidthConfiguration` to allow customizing pull-down menu's width -
  [issue](https://github.com/notDmDrl/pull_down_button/issues/3).

## 0.1.0-beta.4.1

- Lower `meta` version (to avoid conflicts since it's pinned in Flutter SDK).

## 0.1.0-beta.4

- Fix `showDialog` (and other actions the change navigation stack) to work directly without any workarounds -
  [issue](https://github.com/notDmDrl/pull_down_button/issues/1):

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
- `PullDownMenuTitle` replace `SizedBox` with `ConstrainedBox` to allow `PullDownMenuTitle` to have adaptive heigth;
- Update `largeDividerColor` in `PullDownButtonThemeDefaults` to more correct value.
- Fix menu background color "jumping" during open animation.
- Temporarily remove menu open curve due to some animation issues with menus with large amount of items.
- Remove Flutter **beta 2.13.0-0** as minimum supported version - now it's **3.0**.

## 0.1.0-beta.3

- Added `PullDownButtonInheritedTheme` as an additional way of defining global `PullDownButtonTheme` -
  [issue](https://github.com/notDmDrl/pull_down_button/issues/2).

## 0.1.0-beta.2

- Added shadow behind pull-down menu.
- Update pull-down menu show/hide animations to be more similar to native version.
- `PullDownMenuItem` and `SelectablePullDownMenuItem` - replace `InkWell` with `GestureDetector`.
- Improve pull-down menu positioning on screen.
- Fix pull-down animating from the top instead of bottom for `PullDownMenuPosition.above`.

## 0.1.0-beta.1

- Initial release.
