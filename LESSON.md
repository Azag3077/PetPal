# Lesson 05: Time Keeps Ticking

## The new idea

A real pet gets hungry whether you are looking at it or not. So our app needs
a **clock**.

Flutter gives every `StatefulWidget` two special moments, called **lifecycle
methods**:

- **`initState()`** — runs **once**, the moment the screen is born.
  Start things here.
- **`dispose()`** — runs **once**, the moment the screen is thrown away.
  Stop things here.

And the tool we start is a **`Timer.periodic`**:

```dart
_clock = Timer.periodic(const Duration(seconds: 3), (timer) {
  setState(() => pet.tick());
});
```

That means "every 3 seconds, run this code". It keeps going for ever — which is
exactly why we must cancel it:

```dart
@override
void dispose() {
  _clock?.cancel();
  super.dispose();
}
```

**A timer you forget to cancel is like a tap left running.** The screen is
gone, but the timer keeps firing and keeps calling `setState` on a screen that
no longer exists. Flutter will shout at you in red.

We also meet a **`SnackBar`** — the little message that slides up from the
bottom — to warn the player when the pet is starving.

Notice the `?` in `Timer? _clock;`. It means "this might be nothing yet", and
`_clock?.cancel()` means "cancel it, but only if it exists".

## Files added or changed

- `lib/models/pet.dart` — new `tick()` method (time passing) and an
  `isStarving` getter.
- `lib/screens/home_screen.dart` — `initState` starts the clock, `dispose`
  cancels it, and `_warnIfStarving` shows the `SnackBar`.
- `test/pet_test.dart` — tests for `tick()` and `isStarving`.
- `test/widget_test.dart` — jumps forward in time and checks hunger grows and
  the warning appears.

## Build it live (teacher script)

1. Add `tick()` to `Pet`. Keep the numbers small (5, 2, 2) so the game is not
   brutal. Add `isStarving` as a getter too.
2. In `home_screen.dart`, add `import 'dart:async';` at the very top. Point out
   it is `dart:async`, not a Flutter import — timers are plain Dart.
3. Declare `Timer? _clock;`.
4. Write `initState` and start the periodic timer. Hot **restart** (not
   reload — `initState` already ran!) and watch the bars creep.
5. Now the important bit. **Do not** write `dispose` yet. Press the back button
   or hot restart a few times and show the red error in the console about
   `setState() called after dispose()`. Let it sink in.
6. Add `dispose` with `_clock?.cancel()`. The error goes away.
7. Add `_warnIfStarving()` with the `SnackBar`. Explain `_hasWarned`: without
   it the message pops up every three seconds and nobody can use the app.
8. In the test, show `await tester.pump(const Duration(seconds: 3))` — in a
   test you can *jump* through time instead of waiting. Students love this.
9. Run `flutter analyze` and `flutter test`.

## Quick check

1. How many times does `initState()` run for one screen?
2. What goes wrong if you start a `Timer.periodic` and never cancel it?
3. What does the `?` in `Timer? _clock;` mean?

## Homework

**Easy:** make time pass faster by changing `Duration(seconds: 3)` to
`Duration(seconds: 1)`. Then make `tick()` kinder, so hunger only grows by 2.

**Bonus (older students):** add a Pause button in the `AppBar` that cancels the
clock, and turns into a Play button that starts it again. Hint: keep a
`bool _paused` and use `_clock?.cancel()` / start a fresh timer.
