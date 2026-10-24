# Lesson 10: Moving Between Screens

## The new idea

Last lesson `main.dart` swapped screens with one `if`. That works for two
screens, but it has no idea what a **back button** is. Today we hand the job
over to Flutter's **Navigator**.

Think of the Navigator as a **pile of paper**. The screen you can see is the
sheet on top.

### `push` — put a new sheet on the pile

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const NameScreen()),
);
```

The old screen is still underneath, which is why the back arrow appears all by
itself. Flutter also slides the new screen in for you.

### `pop` — take the top sheet off

```dart
Navigator.pop(context);
```

The `AppBar` back arrow does this automatically. We can also do it ourselves
from a button.

### `pushReplacement` — swap the top sheet

After the player has named their pet, going "back" to a blank form would be
silly. So the name screen uses:

```dart
Navigator.pushReplacement(context, MaterialPageRoute(...));
```

The form is thrown away as the home screen arrives.

### Sending an answer back

This is the best bit. `pop` can carry a message:

```dart
// on the stats screen
Navigator.pop(context, 'treat');
```

```dart
// on the home screen
final answer = await Navigator.push<String>(context, ...);
if (answer == 'treat') { ... }
```

`await` means **"pause here until that screen closes"**. The value it gives
back is whatever the other screen passed to `pop`. Pressing the back arrow
instead gives `null` — which is how we know the player did *not* want a treat.

### `mounted`

While we were away on the other screen, our screen might have been closed. So
before using it again we check:

```dart
if (!mounted) return;
```

Forget this and Flutter gives you a telling-off in red.

## Our three screens

```
WelcomeScreen  --push-->  NameScreen  --pushReplacement-->  HomeScreen
                                                                |
                                                      push / pop (with a treat)
                                                                |
                                                           AboutScreen
```

## Files added or changed

- `lib/screens/welcome_screen.dart` — **new.** Title, a sample pet, Get started.
- `lib/screens/about_screen.dart` — **new.** The pet's stats, some advice, and
  two buttons that `pop` with and without a treat.
- `lib/screens/name_screen.dart` — no more `onReady` callback; it navigates
  itself with `pushReplacement`.
- `lib/main.dart` — tiny again: `home: const WelcomeScreen()`.
- `lib/screens/home_screen.dart` — an info button in the `AppBar`, and
  `_openAbout()` which awaits the answer. The clock also slowed from 3 seconds
  to 6, so the pet does not starve while the player reads the stats screen.
- `test/helpers.dart` — **new.** Shared `useTallScreen`, `finishRouteChange`
  and `startWithPet` so the test files stay short.
- `test/navigation_test.dart` — **new.** Four tests for the whole journey.

## Build it live (teacher script)

1. Create `welcome_screen.dart` with just the title and the button, and set
   `home: const WelcomeScreen()` in `main.dart`. Delete `PetPalRoot`.
2. Make the button call `Navigator.push` to `NameScreen`. Tap it. Notice two
   things: the screen *slides*, and there is now a back arrow. We wrote neither.
3. Change `NameScreen` to navigate itself. First use `push` — then press back
   and show that you land on the form again, with the name still in it. Then
   change it to `pushReplacement` and show the difference.
4. Create `about_screen.dart`. Give it the pet and show the `StatBar`s again.
   Point out we are *reading* the pet, not changing it.
5. Add the info button to the home `AppBar` and open the stats screen with a
   plain `Navigator.push`. Works, but nothing comes back.
6. Now add the treat. `Navigator.pop(context, 'treat')` on one side,
   `final answer = await Navigator.push<String>(...)` on the other. Tap the
   treat and watch the hunger bar drop on the screen behind.
7. Press the back arrow instead and show that `answer` is `null`.
8. Add `if (!mounted) return;` and explain why.
9. Run `flutter analyze` and `flutter test`.

## Quick check

1. What is the difference between `push` and `pushReplacement`?
2. The stats screen says `Navigator.pop(context, 'treat')`. Where does the word
   `'treat'` end up?
3. What value comes back if the player taps the back arrow instead of a button?

## Homework

**Easy:** add a third button on the stats screen that pops with the word
`'nap'`, and make the home screen call `pet.sleep()` when it sees it.

**Bonus (older students):** replace the `MaterialPageRoute` calls with **named
routes**. Put `routes: {'/name': ..., '/home': ...}` in the `MaterialApp` and
navigate with `Navigator.pushNamed(context, '/name')`. What gets easier? What
gets harder when you need to pass the pet's name along?
