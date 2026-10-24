# Lesson 03: A Pet Class of Our Own

## The new idea

Right now the rules of our game ("feeding takes 25 off hunger") are mixed into
the screen code. That works, but it is untidy, and it means we cannot test the
rules without building a whole screen.

So we make a **class**: `Pet`.

A class is a **blueprint**. It says what a thing *has* (fields) and what a
thing can *do* (methods):

```dart
class Pet {
  int hunger;          // something it HAS
  void feed() { ... }  // something it can DO
}
```

From one blueprint we can build as many pets as we like:
`Pet(name: 'Bolu')`, `Pet(name: 'Zara')`.

This is called **separating logic from UI**:

- `pet.dart` knows the *rules* — and nothing about buttons or colours.
  It does not even `import` Flutter!
- `home_screen.dart` knows how things *look* — and asks the pet to do the work.

The big win: because `Pet` has no widgets in it, we can test it with a plain
`test()` instead of a `testWidgets()`. These tests run instantly.

## Files added or changed

- `lib/models/pet.dart` — **new.** The `Pet` class with `name`, `hunger`,
  `happiness`, `energy` and the methods `feed()`, `play()`, `sleep()`.
- `lib/screens/home_screen.dart` — holds one `Pet` and reads `pet.hunger`
  instead of its own variables.
- `test/pet_test.dart` — **new.** Five unit tests for the rules.
- `test/widget_test.dart` — still checks the screen works.

## Build it live (teacher script)

1. Make the folder `lib/models/`. Explain the word "model": the part of the app
   that holds the real information, like the pet itself.
2. Create `pet.dart`. Point at the top of the file: **no import**. Say "this
   file does not know Flutter exists."
3. Write the fields, then the constructor with named parameters and defaults:
   `Pet({required this.name, this.hunger = 40, ...})`.
4. Move `feed()`, `play()` and `sleep()` from the screen into the class. Cut
   and paste — the bodies do not change, we just drop `setState`.
5. Move `clamp` in as well and make it `static` (it belongs to all pets, not to
   one particular pet).
6. In the screen, delete the three `int` variables and write
   `final Pet pet = Pet(name: 'Bolu');`
7. Fix every red line: `hunger` becomes `pet.hunger`, and the buttons become
   `onPressed: () => setState(() => pet.feed())`.
   Ask: why do we still need `setState`? (The pet changed, but only the screen
   can redraw itself.)
8. Create `test/pet_test.dart` and write the first test together. Run
   `flutter test` and watch how fast it is compared to a widget test.
9. Run `flutter analyze` and `flutter test`.

## Quick check

1. What is the difference between a *field* and a *method*?
2. `pet.dart` has no `import 'package:flutter/material.dart';`. Why is that a
   good thing?
3. We moved `feed()` into the `Pet` class but kept `setState` in the screen.
   Why can't `setState` live inside `Pet`?

## Homework

**Easy:** add a method `bath()` to `Pet` that raises happiness by 15, and write
a unit test for it. Then wire up a Bath button.

**Bonus (older students):** add an `int age = 0` field and a `birthday()`
method that adds one year and resets happiness to 100. Add a test that a pet
cannot have a negative age.
