# Lesson 09: Name Your Pet

## The new idea

Every pet so far has been called Bolu, because we typed that into the code.
Today the **player** decides — and that means letting them type.

### `TextEditingController`

A text field needs somewhere to keep the letters. That somewhere is a
controller:

```dart
final _nameController = TextEditingController();
...
TextFormField(controller: _nameController)
...
final typed = _nameController.text;
```

And — third time now — **a controller must be disposed**. Timers, animation
controllers, text controllers: if you created it, you clean it up.

### `Form` and validators

A `Form` is a wrapper that knows about all the fields inside it. We pin a
`GlobalKey<FormState>` on it as a name tag so we can reach it later:

```dart
if (_formKey.currentState!.validate()) { ... }
```

Each field gets a **validator** — a function that looks at what was typed and
returns:

- an **error message** if something is wrong, or
- **`null`** if everything is fine.

That `null` trips people up. Remember: *no message means no problem.*

```dart
String? _checkName(String? value) {
  if (name.isEmpty) return 'Your pet needs a name!';
  if (name.length > 12) return 'That is too long — 12 letters at most.';
  return null;   // all good
}
```

We also use `.trim()` to throw away stray spaces, so `"  Bolu  "` becomes
`"Bolu"` and a name of nothing but spaces counts as empty.

### Handing the answer back

The name screen does not know what a pet is. It just calls the function it was
given:

```dart
widget.onReady(_nameController.text.trim(), _chosenColor);
```

This is the same trick as the Feed button in lesson 02 — **a widget reports
what happened, and somebody else decides what it means.**

For now `main.dart` holds the answers and swaps screens with a single `if`.
Next lesson we replace that with Flutter's real `Navigator`.

### Keys

Each colour circle gets `key: ValueKey(color)`. A key is a label that tells
Flutter (and our tests) which circle is which.

## Files added or changed

- `lib/screens/name_screen.dart` — **new.** The form, the validator and the
  six colour circles.
- `lib/main.dart` — new `PetPalRoot` that shows the name screen first, then the
  home screen.
- `lib/screens/home_screen.dart` — takes `petName` and `petColor`, and builds
  its `Pet` in `initState` with `late final`.
- `lib/widgets/play_area.dart`, `pet_view.dart`, `pet_painter.dart` — pass the
  chosen colour down; the mood now *tints* that colour with `Color.lerp`.
- `test/name_screen_test.dart` — **new.** Six tests for the form.
- `test/widget_test.dart` — a `startWithPet` helper so every home test gets
  past the name screen first.

## Build it live (teacher script)

1. Create `name_screen.dart`. Start with just a `Scaffold`, a heading and a
   plain `TextFormField` with a controller. Type into it. Nothing happens yet —
   that is fine.
2. Add `dispose()` with `_nameController.dispose()`. Ask the class what else we
   have had to dispose so far (timers, animation controllers).
3. Add the `FilledButton` and make `_submit()` just `print` the text. Show the
   typed name in the console.
4. Wrap everything in a `Form` with `key: _formKey` and add the `validator`.
   Press Start empty — the red message appears all by itself. This always gets
   a reaction.
5. Try a very long name. Then explain the `null` return: no message means no
   problem.
6. Add `.trim()` and test with `"   Bolu   "`.
7. Add the colour circles with a `for` inside the `Wrap`, and
   `onTap: () => setState(() => _chosenColor = color)`. Tap them and watch the
   tick move.
8. Change `onReady` from a print to a real callback. In `main.dart`, write
   `PetPalRoot` with `_petName`, `_petColor` and the `if`.
9. Give `HomeScreen` its two new parameters. Fix the red lines: `Pet` is now
   built in `initState` with `late final Pet pet;`. Explain `late` as "I
   promise to fill this in before anyone looks".
10. Pass the colour down to `PetView` and use `Color.lerp` for the moods.
    Restart, pick pink, let the pet get sad, and watch the pink go grey.
11. Run `flutter analyze` and `flutter test`.

## Quick check

1. What does a validator return when the value is **good**?
2. Why must we call `_nameController.dispose()`?
3. The name screen does not know what a `Pet` is. How does the name get to the
   home screen then?

## Homework

**Easy:** change the rules so a name must be at least 2 letters long, with your
own error message. Then add two more colours to `petColors`.

**Bonus (older students):** add a second field where the player types the pet's
age in years, and validate that it is a whole number between 0 and 20. Hint:
`int.tryParse(value)` returns `null` when the text is not a number.
