# Pull-Down Button from iOS 14 for Flutter

[![Dart SDK Version](https://badgen.net/pub/sdk-version/pull_down_button)](https://pub.dev/packages/pull_down_button)
[![Pub Version](https://badgen.net/pub/v/pull_down_button?icon=flutter)](https://pub.dev/packages/pull_down_button)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

**pull_down_button** is a rework of Flutter's `PopupMenuButton` to be styled like
[Pop-Up](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pop-up-buttons) and
[Pull-Down](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons)
Buttons from iOS 14+ with some additional customisation options.

---

This package only tries to visually replicate native counterpart, some parts might be somewhat different.

#### Flutter availability:

Since this package uses new Flutter feature `ThemeExtension` for theming, minimum supported version is stable **3.0.0**.

---

### Contents:

- [PullDownButton](#pulldownbutton)
  - [PullDownMenuItem](#pulldownmenuitem)
  - [PullDownMenuItem.selectable](#pulldownmenuitemselectable)
  - [PullDownMenuActionsRow](#pulldownmenuactionsrow)
  - [PullDownMenuDivider](#pulldownmenudivider)
  - [PullDownMenuTitle](#pulldownmenutitle)
- [showPullDownMenu](#showpulldownmenu)
- [PullDownMenu](#pulldownmenu)
- [Theming](#theming)
  - [PullDownButtonTheme](#pulldownbuttontheme)
- [Contributions](#contributions)

---

## PullDownButton

![PullDownButton example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/usage.png)

`PullDownButton` is a widget used to show pull-down menu. Unlike `PopupMenuButton`, `PullDownButton` allows better customization of button that will be used to show pull-down menu via `buttonBuilder` builder function.

While pull-down menu is opened, button from where this menu was called will have lower opacity.

```dart
PullDownButton(
  itemBuilder: (context) => [
    PullDownMenuItem(
      title: 'Menu item',
      onTap: () {},
    ),
    const PullDownMenuDivider(),
    PullDownMenuItem(
      title: 'Menu item 2',
      onTap: () {},
    ),
  ],
  position: PullDownMenuPosition.under,
  buttonBuilder: (context, showMenu) => CupertinoButton(
    onPressed: showMenu,
    padding: EdgeInsets.zero,
    child: const Icon(CupertinoIcons.ellipsis_circle),
  ),
);
```

<details><summary>Properties table</summary>

| Properties    | Description                                                                                              |
| ------------- | -------------------------------------------------------------------------------------------------------- |
| itemBuilder   | Called when the button is pressed to create the items to show in the menu.                               |
| buttonBuilder | Builder that provides `BuildContext` as well as `showMenu` function to pass to any custom button widget. |
| onCanceled    | Called when the user dismisses the pull-down menu.                                                       |
| offset        | The offset is applied relative to the initial position set by the `position`.                            |
| position      | Whether the popup menu is positioned above, over or under the popup menu button.                         |
| itemsOrder    | Whether the popup menu orders its items from `itemBuilder` in downwards or upwards way.                  |
| routeTheme    | The theme of pull-down menu box.                                                                         |
| applyOpacity  | Whether to apply opacity on `buttonBuilder` when menu is open.                                           |

</details>

#### PullDownMenuPosition

The way `PullDownButton` positions its pull-down menu.

Available options:

- `over` - menu is positioned over an anchor. Will attempt to fill as much space as possible;
- `under` - menu is positioned under an anchor and is forced to be under an anchor;
- `above` - menu is positioned above an anchor and is forced to always be above an anchor;
- `automatic` - menu is positioned under or above an anchor depending on side that has more space available.

---

### PullDownMenuItem

![PullDownMenuItem example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/item.png)

`PullDownMenuItem` is a widget used to create cupertino style pull-down menu item.

```dart
PullDownMenuItem(
  title: 'Add to favourites',
  onTap: () {},
  icon: CupertinoIcons.star,
),
```

<details><summary>Properties table</summary>

| Properties    | Description                                      |
| ------------- | ------------------------------------------------ |
| onTap         | The action this item represents.                 |
| tapHandler    | Handler to resolve how `onTap` callback is used. |
| enabled       | Whether the user is permitted to tap this item.  |
| title         | Title of this `PullDownMenuItem`.                |
| icon          | Trailing icon of this `PullDownMenuItem`.        |
| iconColor     | Trailing icon's color.                           |
| iconWidget    | Custom trailing widget.                          |
| isDestructive | Whether this item represents destructive action. |
| itemTheme     | The theme of menu item.                          |

 </details>

---

### PullDownMenuItem.selectable

![PullDownMenuItem.selectable example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/selectable_item.png)

`PullDownMenuItem.selectable` is a widget used to create cupertino style pull-down menu item with selection state.

```dart
PullDownMenuItem.selectable(
  title: 'Grid',
  selected: true,
  onTap: () {},
  icon: CupertinoIcons.square_grid_2x2,
),
```

##### Note:

Based on [guidelines](https://developer.apple.com/design/human-interface-guidelines/components/menus-and-actions/pull-down-buttons), if menu items contains at least one tappable menu item of type `PullDownMenuItem.selectable` all of `PullDownMenuItem`s should also be of type `PullDownMenuItem.selectable` (to insert additional padding so all items have same). Although, manual change of all `PullDownMenuItem`s is not needed, it is done automatically.

<details><summary>Properties table</summary>

`PullDownMenuItem.selectable` uses all of `PullDownMenuItem` properties as well as a boolean value `selected`, to indicate whether menu item is selected or not.

</details>

---

### PullDownMenuActionsRow

![PullDownMenuActionsRow example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/actions_row.png)

`PullDownMenuActionsRow` is a widget used to create cupertino style pull-down menu row of actions
([small or medium size](https://developer.apple.com/documentation/uikit/uimenu/4013313-preferredelementsize)).

```dart
PullDownMenuActionsRow.medium(
  items: [
    PullDownMenuItem(
      enabled: false,
      onTap: () {},
      title: 'Inbox',
      icon: CupertinoIcons.tray_arrow_down,
    ),
    PullDownMenuItem(
      onTap: () {},
      title: 'Archive',
      icon: CupertinoIcons.archivebox,
    ),
    PullDownMenuItem(
      onTap: () {},
      title: 'Trash',
      isDestructive: true,
      icon: CupertinoIcons.delete,
    ),
  ],
),
```

`PullDownMenuItem` is used to populate `PullDownMenuActionsRow.items`.
Depending on `PullDownMenuActionsRow` size might be either icon only or icon and title in vertical array

| Properties   | Description                                      |
| ------------ | ------------------------------------------------ |
| items        | List of `PullDownMenuItem`.                      |
| dividerColor | Color of vertical dividers used to split `item`. |

---

### PullDownMenuDivider

![PullDownMenuDivider example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/dividers.png)

`PullDownMenuDivider` is a widget used to create cupertino style pull-down menu divider (small or large).

```dart
const PullDownMenuDivider(),
```

or to create large divider:

```dart
const PullDownMenuDivider.large(),
```

There is also convenience method to wrap multiple menu items with small dividers:

```dart
...PullDownMenuDivider.wrapWithDivider([
  PullDownMenuItem(
    enabled: false,
    title: 'Select',
    onTap: () {},
    icon: CupertinoIcons.checkmark_circle,
  ),
  PullDownMenuItem(
    title: 'Connect to remote server',
    onTap: () {},
    icon: CupertinoIcons.cloud_upload,
  ),
]),
```

---

### PullDownMenuTitle

![PullDownMenuTitle example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/title.png)

`PullDownMenuTitle` is a widget used to create cupertino style pull-down menu title (usually at the top of menu).

```dart
const PullDownMenuTitle(title: Text('Menu title')),
```

| Properties | Description              |
| ---------- | ------------------------ |
| title      | Title widget.            |
| titleStyle | Title widget text style. |

---

### showPullDownMenu

An alternative way of displaying pull-down menu via a function call.

```dart
onPressed: () async {
  /* get tap position and / or do something before opening menu */

  await showPullDownMenu(
    context: context,
    items: [...],
    position: position,
  );
}
```

<details><summary>Properties table</summary>

| Properties   | Description                                                                                          |
| ------------ | ---------------------------------------------------------------------------------------------------- |
| context      | For looking up `Navigator` for menu.                                                                 |
| items        | List of `PullDownMenuEntry` widgets.                                                                 |
| position     | The `RelativeRect` used to align top of the menu with top of the **position** rectangle.             |
| buttonSize   | Used to let menu know about additional bottom offset to use while calculating final menu's position. |
| menuPosition | Whether the popup menu is positioned above, over or under the calculated menu's position.            |
| itemsOrder   | Whether the popup menu orders its items from `itemBuilder` in downwards or upwards way.              |
| onCanceled   | Called when the user dismisses the pull-down menu.                                                   |
| routeTheme   | The theme of pull-down menu box.                                                                     |

</details>

### PullDownMenu

An another alternative way of displaying pull-down menu as a simple widget, with no animations or adding routes to navigation stack.

```dart
PullDownMenu(
  items: [
    PullDownMenuItem(
      title: 'Menu item',
      onTap: () {},
    ),
    const PullDownMenuDivider(),
    PullDownMenuItem(
      title: 'Menu item 2',
      onTap: () {},
    ),
  ]
)
```

<details><summary>Properties table</summary>

| Properties | Description                          |
| ---------- | ------------------------------------ |
| items      | List of `PullDownMenuEntry` widgets. |
| routeTheme | The theme of pull-down menu box.     |

</details>

---

## Theming

This package also provides additional customisation. By default, iOS16 theme is used, but it is also possible to override defaults with widget properties (see above) or with `PullDownButtonTheme` theme extension.

#### Default theme

| Light Theme                                                                                                               | Dark Theme                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| ![light default theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/usage.png) | ![dark default theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/usage_dark.png) |

### PullDownButtonTheme

To use `PullDownButtonTheme` define it in your `ThemeData` as follows:

```dart
ThemeData(
  ...,
  extensions: [
    PullDownButtonTheme(
      routeTheme: PullDownMenuRouteTheme(
        backgroundColor: Colors.grey,
      ),
      itemTheme: PullDownMenuItemTheme(
        iconSize: 24,
      ),
      dividerTheme: PullDownMenuDividerTheme(
        dividerColor: Colors.black,
      ),
    ),
  ],
),
```

`PullDownButtonTheme` uses a set of sub-themes (for items, dividers, menu itself etc.) to define needed theme. See below for every property each sub-theme provides.

<details><summary>PullDownButtonTheme</summary>

| Properties   | Description                                                                   |
| ------------ | ----------------------------------------------------------------------------- |
| routeTheme   | Menu container theme (`PullDownMenuRouteTheme`).                              |
| itemTheme    | `PullDownMenuItem` theme (`PullDownMenuItemTheme`).                           |
| dividerTheme | `PullDownMenuDivider` theme (`PullDownMenuDividerTheme`).                     |
| titleTheme   | `PullDownMenuTitle` theme (`PullDownMenuTitleTheme`).                         |
| applyOpacity | Whether to apply opacity on `PullDownButton.buttonBuilder` when menu is open. |

</details>

<details><summary>PullDownMenuRouteTheme</summary>

| Properties      | Description                                                         |
| --------------- | ------------------------------------------------------------------- |
| backgroundColor | The background color of pull-down menu.                             |
| borderRadius    | The border radius of the pull-down menu.                            |
| beginShadow     | The pull-down menu shadow at the moment of menu being opened.       |
| endShadow       | The pull-down menu shadow at the moment of menu being fully opened. |
| width           | Pull-down menu width.                                               |

`backgroundColor` usually has opacity in range of **0.7-0.8** so that menu has blur effect.
If `backgroundColor`'s is fully opaque (opacity set to **1**), no blur effect will be applied.

</details>

<details><summary>PullDownMenuItemTheme</summary>

| Properties          | Description                                                       |
| ------------------- | ----------------------------------------------------------------- |
| destructiveColor    | Color for destructive action.                                     |
| iconSize            | Size of trailing icon.                                            |
| checkmark           | Checkmark icon.                                                   |
| checkmarkWeight     | Weight of checkmark icon.                                         |
| checkmarkSize       | Size of checkmark icon.                                           |
| textStyle           | `PullDownMenuItem` text style.                                    |
| iconActionTextStyle | `PullDownMenuItem` text style inside of `PullDownMenuActionsRow`. |
| onHoverColor        | On hover color of `PullDownMenuItem`.                             |
| onHoverTextStyle    | On hover text style of `PullDownMenuItem`.                        |

</details>

<details><summary>PullDownMenuDividerTheme</summary>

| Properties        | Description          |
| ----------------- | -------------------- |
| dividerColor      | Small divider color. |
| largeDividerColor | Large divider color. |

`largeDividerColor` is usually lighter than `dividerColor`.

</details>

<details><summary>PullDownMenuTitleTheme</summary>

| Properties | Description                     |
| ---------- | ------------------------------- |
| style      | `PullDownMenuTitle` text style. |

</details>

#### PullDownButtonInheritedTheme

If defining `PullDownButtonTheme` in `ThemeData` is not possible, for example if you are using `CupertinoApp`, you can use `PullDownButtonInheritedTheme`:

```dart
CupertinoApp(
  builder: (context, child) => PullDownButtonInheritedTheme(
    data: const PullDownButtonTheme(
      ...
    ),
    child: child!,
  ),
  home: ...,
)
```

---

Here is example of using `PullDownButtonTheme` with Material 3 color scheme colors
(generated from `CupertinoColors.systemBlue` with `ColorScheme.fromSeed`) from [Material 3 Menu specs](https://m3.material.io/components/menus/specs).

| Custom Material 3 light theme                                                                                           | Custom Material 3 dark theme                                                                                          |
| ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ![light theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/theme_light.png) | ![dark theme example](https://raw.githubusercontent.com/notDmDrl/pull_down_button/main/readme_content/theme_dark.png) |

---

### Contributions

Feel free to contribute to this project.

Please file feature requests and bugs at the [issue tracker](https://github.com/notDmDrl/pull_down_button).

If you fixed a bug or implemented a feature by yourself, feel free to send a [pull request](https://github.com/notDmDrl/pull_down_button/pulls).
