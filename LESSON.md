# Lesson 04: How Is My Pet Feeling?

## The new idea

Our pet has three numbers, but a child looking at the screen wants one simple
answer: **is my pet happy or not?**

So we add a `mood`. A mood is not a number and it is not free text — it is one
of exactly four choices. That is what an **enum** is for:

```dart
enum Mood { happy, okay, sad, sleepy }
```

Why an enum instead of a `String`? Because `'happpy'` with three p's compiles
fine and then quietly breaks your app. `Mood.happpy` does not compile at all.
The computer catches the typo for you.

We work the mood out with a **getter**:

```dart
Mood get mood {
  if (energy < 25) return Mood.sleepy;
  ...
}
```

A getter is a method that pretends to be a field. You write `pet.mood`, not
`pet.mood()`. We never *store* the mood, we always *work it out* from the
current numbers — so it can never get out of date.

Then in the UI we **choose a widget with a `switch`**: one colour per mood, one
mouth shape per mood, eyes open or closed.

Watch out for the **order of the `if`s**. We check energy first, so a very
tired pet is sleepy even if it is also happy. Change the order and the app
behaves differently — that is a great thing to try live.

## Files added or changed

- `lib/models/pet.dart` — adds the `Mood` enum and the `mood` getter.
- `lib/widgets/pet_view.dart` — takes a `mood`, and changes colour, eyes and
  mouth to match. Shows the mood word under the pet.
- `lib/screens/home_screen.dart` — passes `pet.mood` down to `PetView`.
- `test/pet_test.dart` — four new tests, one per mood.
- `test/widget_test.dart` — plays until the pet is tired and checks the word
  changes to "Sleepy".

## Build it live (teacher script)

1. At the top of `pet.dart`, write `enum Mood { happy, okay, sad, sleepy }`.
   Note it goes *outside* the class — a mood is not owned by one pet.
2. Add the `mood` getter with the four `if`s. Read them out loud like English:
   "if energy is under 25 the pet is sleepy".
3. In `pet_view.dart`, add `required this.mood` to the constructor. Everything
   goes red because `home_screen` is not passing it yet — fix that next:
   `PetView(mood: pet.mood)`.
4. Add the `_bodyColor` getter with a `switch`. Delete one of the four `case`s
   on purpose: the compiler complains that the switch is not exhaustive. Put it
   back. Explain that this safety net is the whole point of an enum.
5. Give `_Eye` a `closed` parameter and use `closed ? 5 : 26` for the height.
   Hot reload and tap Play until the pet falls asleep.
6. Change `_Mouth` so the width comes from a `switch` expression and a happy
   mouth gets a rounded bottom.
7. Swap the order of the `if`s in `mood` and show how the behaviour changes.
   Put it back.
8. Run `flutter analyze` and `flutter test`.

## Quick check

1. Why is `Mood.happy` safer than the text `'happy'`?
2. What is the difference between `pet.mood` and `pet.mood()`?
3. Our pet has 100 happiness but only 10 energy. What mood is it, and which
   line of code decides that?

## Homework

**Easy:** add a fifth mood called `excited` for when happiness is 100, and give
it a bright pink body colour.

**Bonus (older students):** add eyebrows that slant downwards when the pet is
sad. Hint: wrap a thin `Container` in a `Transform.rotate` and give it an angle
that depends on the mood.
