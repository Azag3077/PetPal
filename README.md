# PetPal 🐾

A virtual pet app built step by step as a Flutter teaching project.

Feed your pet, play with it, let it sleep — and watch its mood change.
Everything is drawn with Flutter code, so there are no pictures to download
and no extra packages to install. Just the Flutter SDK.

## How the lessons work

The project is split into **branches**. Each branch is one lesson, and each
branch contains everything from the lesson before it **plus one new idea**.

Switch to a lesson like this:

```bash
git checkout 00-blank
```

Then run the app:

```bash
flutter run
```

Every branch has its own `LESSON.md` with the lesson script, check questions
and homework.

## The lessons

| Branch | Lesson | What you learn |
| --- | --- | --- |
| `00-blank` | Lesson 00: An Empty App | Project structure, `main()` and `runApp` |
| `01-stateless-layout` | Lesson 01: Drawing Our Pet | Composing widgets with `Column`, `Row`, `Container` |
| `02-stateful-stats` | Lesson 02: Hunger, Happiness, Energy | State and `setState` |
| `03-pet-model` | Lesson 03: A Pet Class of Our Own | Classes, methods, logic away from UI |
| `04-mood` | Lesson 04: How Is My Pet Feeling? | Enums and `switch` in the UI |
| `05-timer` | Lesson 05: Time Keeps Ticking | `initState`, `dispose` and `Timer.periodic` |
| `06-animation` | Lesson 06: Make It Move | Implicit vs explicit animation |
| `07-custom-paint` | Lesson 07: Painting With Code | `CustomPainter` and `Canvas` |
| `08-drag-and-move` | Lesson 08: Drag Your Pet Around | Gestures and moving objects |
| `09-user-input` | Lesson 09: Name Your Pet | Forms, controllers and validation |
| `10-navigation` | Lesson 10: Moving Between Screens | `Navigator.push` / `pop` and passing data |
| `11-final-polish` | Lesson 11: Final Polish | Theming, reset and a game-over dialog |

`main` holds the **finished app**, so you can demo the end result first and
then go back to `00-blank` and build it together.

## Running the tests

```bash
flutter analyze
flutter test
```

Both should be clean on every branch.

## Platforms

Android, iOS, web and Windows desktop.
