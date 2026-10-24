# Lesson 11: Final Polish

## The new idea

The app works. Today we make it feel **finished** — and finishing is a real
skill, not an afterthought.

Four jobs:

### 1. One theme, one place

Look back through the old code and count how many times we typed
`fontSize: 20` or `EdgeInsets.all(12)`. Every screen was guessing. Now there is
`lib/theme.dart`:

```dart
filledButtonTheme: FilledButtonThemeData(
  style: FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 18),
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
),
```

Every `FilledButton` in the app is now that size and shape, so the screens got
*shorter*: `child: const Text('Start')` and nothing else. If we want bigger
buttons tomorrow, we change one file.

### 2. The name under the icon

The name on your phone's home screen is not set in Dart at all — each platform
keeps its own. We changed `petpal` to `PetPal` in four places:

| Platform | File |
| --- | --- |
| Android | `android/app/src/main/AndroidManifest.xml` (`android:label`) |
| iOS | `ios/Runner/Info.plist` (`CFBundleDisplayName`) |
| Web | `web/manifest.json` and `web/index.html` |
| Windows | `windows/runner/main.cpp` |

### 3. A dialog that asks first

A reset cannot be undone, so we ask. `showDialog` can **give an answer back**,
exactly like a screen can:

```dart
final yes = await showDialog<bool>(...);
if (yes == true) { _restartGame(); }
```

`Navigator.pop(context, true)` on the Yes button, `false` on the No button, and
`null` if the player taps outside. Note we write `yes == true` rather than
`if (yes)` — because `null` is a real possibility and a `bool?` cannot go
straight into an `if`.

### 4. Game over

Our pet can finally be lost:

```dart
bool get hasRunAway => hunger >= 100 && happiness <= 0 && energy <= 0;
```

All three have to be at their worst. One bad number is just a bad afternoon —
that is a design decision, and it is the kind of decision students should argue
about.

When it happens we **stop the clock first** (no point starving a pet that has
already left), then show a dialog with `barrierDismissible: false` so the player
has to answer, and reset on the way out.

## Files added or changed

- `lib/theme.dart` — **new.** Colours, text sizes, button and card shapes.
- `lib/main.dart` — uses `buildPetPalTheme()` and hides the debug banner.
- `lib/models/pet.dart` — new `hasRunAway` getter and `reset()` method.
- `lib/screens/home_screen.dart` — a reset button in the `AppBar`,
  `_confirmReset()`, `_checkIfPetRanAway()` and `_restartGame()`; the clock is
  now started and stopped by named methods.
- `lib/screens/welcome_screen.dart`, `name_screen.dart`, `about_screen.dart` —
  hand-written sizes and paddings removed; the theme does it.
- `android/…/AndroidManifest.xml`, `ios/Runner/Info.plist`,
  `web/manifest.json`, `web/index.html`, `windows/runner/main.cpp` — the app is
  called **PetPal**.
- `test/polish_test.dart` — **new.** Tests the reset dialog (both answers) and
  neglects a pet for 40 ticks until it runs away.
- `test/helpers.dart` — a `finishDialog` helper.

## Build it live (teacher script)

1. Create `theme.dart` and move the `ThemeData` out of `main.dart`. Change the
   seed colour to something awful (bright red) and reload so everyone sees how
   far one colour reaches.
2. Add the `filledButtonTheme`. Then go to each screen and **delete** the
   `Padding` and `TextStyle` around the button labels. Deleting code and having
   the app look *better* is a great feeling to share.
3. Add `pet.reset()` and the `restart_alt` button with no dialog at all. Tap it
   by accident. Agree that this is annoying.
4. Add `_confirmReset()` with `showDialog<bool>`. Walk through all three
   possible answers: Yes, No, and tapping outside.
5. Add `hasRunAway` to `Pet` and a unit test for it. Discuss the rule: should
   one bad stat be enough? Let the class vote, then write their rule.
6. Add `_checkIfPetRanAway()`. Test it in the app by setting the starting stats
   terribly low for a moment (`Pet(name: ..., hunger: 95, happiness: 2,
   energy: 2)`), watching the pet leave, then putting the numbers back.
7. Change the app name in the four platform files. Run on a device or the web
   and show the title bar.
8. Run `flutter analyze` and `flutter test` one last time, then merge into
   `main` so the finished app is what people see first.

## Quick check

1. Name two things that got **shorter** because of the theme file.
2. `showDialog<bool>` can give back three different things. What are they?
3. Why do we cancel the clock before showing the "ran away" dialog?

## Homework

**Easy:** change the theme's seed colour and the button corner radius to make
the app your own. Then change the game-over rule so the pet runs away if
hunger is 100 and happiness is 0, ignoring energy.

**Bonus (older students):** add a `darkTheme:` to the `MaterialApp` and a
moon/sun button in the `AppBar` that switches between light and dark. Hint:
`MaterialApp` takes a `themeMode`, and the switch has to live *above* the
`MaterialApp` for the whole app to change.

## You finished PetPal 🎉

Twelve branches, from an empty screen to a game with animation, painting,
gestures, forms, navigation and dialogs — and not one extra package.
