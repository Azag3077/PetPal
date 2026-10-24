# Lesson 01: Drawing Our Pet

## The new idea

Flutter apps are built by **putting small widgets inside bigger widgets**. We
never draw a whole screen in one go — we build little pieces and stack them.

The three pieces we use today:

- **`Column`** — puts its children one *above* another (like a tower).
- **`Row`** — puts its children one *beside* another (like a queue).
- **`Container`** — a box we can colour, round off and give a size.

And one habit: when a piece of the screen gets long, **move it into its own
widget in its own file**. Our pet goes in `pet_view.dart`, our screen goes in
`home_screen.dart`. `main.dart` stays tiny.

A trick worth saying out loud: a circle is just a `Container` with
`shape: BoxShape.circle`. Two small circles in a `Row` are eyes. That is the
whole pet!

## Files added or changed

- `lib/widgets/pet_view.dart` — **new.** The pet: body, two eyes, a mouth.
- `lib/screens/home_screen.dart` — **new.** AppBar, pet, name, three buttons.
- `lib/main.dart` — now shows `HomeScreen` instead of a bare `Text`.
- `test/widget_test.dart` — checks the pet, the name and the three labels.

## Build it live (teacher script)

1. Make the folders `lib/widgets/` and `lib/screens/`. Explain why: code is
   easier to find when it is sorted, exactly like school subjects in folders.
2. Create `pet_view.dart`. Write the outer `Container` first with
   `width: 200, height: 200` and an orange colour. Hot reload — an orange
   square. Students will laugh.
3. Add `shape: BoxShape.circle` to the decoration. Reload — now it is a face.
4. Add the `border`. Reload.
5. Add a `Column` inside with a `Row` of two `_Eye` widgets. Write `_Eye` as
   its own tiny class so everyone sees "one widget = one job".
6. Put a `SizedBox(width: 36)` between the eyes and ask students to change the
   number. 0? 100? This is how we space things out in Flutter.
7. Add `_Mouth` under the eyes with `borderRadius` and reload.
8. Create `home_screen.dart`. `Scaffold` → `AppBar` → `body` → `Padding` →
   `Column`. Drop `PetView()` in, then the name `Text`, then the `Row` of
   buttons.
9. Write `_ActionButton` once, use it three times. Point out that this is why
   making your own widget is worth it — write once, use everywhere.
10. Change `main.dart` to `home: const HomeScreen()`.
11. Run `flutter analyze` and `flutter test`.

## Quick check

1. What is the difference between a `Column` and a `Row`?
2. How do you turn a square `Container` into a circle?
3. Our three buttons are all `_ActionButton`. Why is that better than writing
   the same button code three times?

## Homework

**Easy:** give the pet ears. Hint: a small `Container` on each side — try a
`Row` above the face, or use a `Stack`. Also change the pet's colour and name.

**Bonus (older students):** add a fourth button called `Bath` with the icon
`Icons.shower`, and make the buttons wrap neatly on a narrow phone by swapping
the `Row` for a `Wrap`.
