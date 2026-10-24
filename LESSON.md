# Lesson 00: An Empty App

## The new idea

Every Flutter app is really just **one widget inside another widget**, all the
way down. Today we throw away the demo app Flutter gave us and start with the
smallest app that still works.

Three words to remember:

- **`main()`** — the first function that runs. Every Dart program has one.
- **`runApp()`** — hands a widget to Flutter and says "put this on screen".
- **`MaterialApp`** — the wrapper that gives our app colours, fonts and screens.

Think of it like a school play: `main()` is the bell that starts the show,
`runApp()` opens the curtain, and `MaterialApp` is the stage itself.

## What is in the project

```
petpal/
├── lib/
│   └── main.dart        <- the only code file for now
├── test/
│   └── widget_test.dart <- our first test
├── pubspec.yaml         <- the app's shopping list (name, version, packages)
├── LESSON.md            <- this file
└── README.md            <- the list of all lessons
```

Files added or changed this lesson:

- `lib/main.dart` — stripped down to a bare `MaterialApp`.
- `test/widget_test.dart` — replaced the counter test with our own.
- `README.md`, `LESSON.md` — new.

## Build it live (teacher script)

1. Run `flutter create --org com.teaching --project-name petpal petpal` and
   show the students the demo counter app with `flutter run`.
2. Open `lib/main.dart`. Say out loud: "we are going to delete almost all of
   this." Delete everything.
3. Type the import together: `import 'package:flutter/material.dart';`
   Explain that this is how we borrow Flutter's ready-made widgets.
4. Write `void main() { runApp(const PetPalApp()); }`.
   Save. The app breaks — `PetPalApp` does not exist yet. That is fine!
5. Write the `PetPalApp` class extending `StatelessWidget` with its `build`
   method returning a `MaterialApp`.
6. Inside it put `home: const Scaffold(body: Center(child: Text('PetPal')))`.
   Save and hot reload. One word, in the middle of the screen. Done.
7. Run `flutter analyze` and `flutter test` so everyone sees green from day one.

## Quick check

1. Which function runs first when a Flutter app starts?
2. What does `runApp()` actually do?
3. Why do we wrap `Text` inside `Center`?

## Homework

**Easy:** change the word on the screen to your own pet's name, and change
`colorSchemeSeed: Colors.teal` to your favourite colour. Take a screenshot.

**Bonus (older students):** add a second line of text under `PetPal` using a
`Column`, and give it a bigger font with
`style: TextStyle(fontSize: 32)`. Why can't a `Center` hold two children on
its own?
