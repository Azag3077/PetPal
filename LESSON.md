# Lesson 08: Drag Your Pet Around

## The new idea

So far the player can only press buttons. Today they can **touch the pet
itself** — drag it around a patch of grass, and tap it to make it giggle.

### `GestureDetector`

Wrap anything in a `GestureDetector` and it starts noticing fingers:

```dart
GestureDetector(
  onTap: widget.onPetTapped,
  onPanUpdate: (details) => _movePet(details.delta, area),
  child: PetView(...),
)
```

- **`onTap`** — a quick touch.
- **`onPanUpdate`** — fires over and over while a finger slides across the
  screen.

The important word is **`details.delta`**. It is *not* where the finger is — it
is the little **step** the finger just took. So we never set the position, we
always **add** the step to the position we already had. That is why the pet
follows the finger instead of jumping to it.

### `Stack` and `Positioned`

A `Column` decides where its children go. We do not want that any more — we
want to say "the pet is exactly 130 pixels from the left and 40 from the top".
That needs a **`Stack`** (children can overlap and float) and a
**`Positioned`** (`left:` and `top:`).

`Positioned` **only works inside a `Stack`**. That is a rule worth writing on
the board.

### `LayoutBuilder` and keeping the pet on the grass

How do we know where the edge of the grass is? **`LayoutBuilder`** tells us how
much room we were given (`area.maxWidth`, `area.maxHeight`). Then `clamp` keeps
the pet inside:

```dart
(_position.dx + delta.dx).clamp(0, area.maxWidth - _petWidth)
```

Same `clamp` as the stats in lesson 02 — a tool we already own, used for a
completely different job.

## Files added or changed

- `lib/widgets/play_area.dart` — **new.** The grass, the `Stack`, the
  `Positioned` pet, and the drag maths.
- `lib/models/pet.dart` — new `giggle()` method (a small happiness boost).
- `lib/screens/home_screen.dart` — shows `PlayArea` instead of `PetView`, and
  giggles when the pet is tapped.
- `test/widget_test.dart` — drags the pet, checks it cannot leave the grass,
  and taps it to check happiness rises.

## Build it live (teacher script)

1. Add `giggle()` to `Pet`: `happiness + 5`, `energy - 1`. Small on purpose, so
   tapping is not a cheat code.
2. Create `play_area.dart` with just the green `Container` (height 300,
   rounded, bordered) and `PetView` inside it. Hot reload — the pet is standing
   on grass.
3. Swap the plain child for a `Stack` with a `Positioned`. Hard-code
   `left: 30, top: 24` and show that changing those numbers moves the pet.
   Delete the `Stack` for a second so students see the error that `Positioned`
   must live in a `Stack`.
4. Turn `left`/`top` into a state field: `Offset _position = Offset(30, 24);`
5. Wrap the pet in a `GestureDetector` with only `onPanUpdate` and write
   `_movePet` **without** the clamp:
   `_position = _position + delta;`
   Drag the pet right off the screen. Everyone will try it. This is the fun
   part.
6. Add `LayoutBuilder` and the `clamp`. Now the pet stops at the fence.
7. Add `onTap: widget.onPetTapped` and wire it up in `home_screen.dart` with
   `setState(() => pet.giggle())`. Tap the pet and watch the happiness bar.
8. Ask: why does `PlayArea` not know what a giggle is? (Same reason the buttons
   do not — the screen owns the pet, the widgets just report touches.)
9. Run `flutter analyze` and `flutter test`.

## Quick check

1. What is the difference between where a finger *is* and `details.delta`?
2. Which widget must a `Positioned` be inside?
3. We used `clamp` in lesson 02 for hunger and again today for position. What
   does `clamp` do in both cases?

## Homework

**Easy:** make the grass taller (height 400) and start the pet in a different
corner. Then add `onDoubleTap` so a double tap feeds the pet.

**Bonus (older students):** add `onPanEnd` so that when the player lets go, the
pet slides gently back to the middle of the grass. Hint: you will need an
`AnimationController` and a `Tween<Offset>`, or `AnimatedPositioned`.
