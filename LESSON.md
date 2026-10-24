# Lesson 06: Make It Move

## The new idea

Our pet changes colour the instant the mood changes — *snap*. Real things do
not snap, they glide. Today we make the pet move.

Flutter has **two kinds of animation**, and knowing when to use which is the
whole lesson.

### 1. Implicit animation — Flutter does the work

Change `Container` to `AnimatedContainer`, add a `duration`, and that is it.
Whenever a value changes, Flutter slides smoothly from the old one to the new
one.

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 400),
  decoration: BoxDecoration(color: _bodyColor),
)
```

You do not say *how* to animate. You just say "take 400ms to get there".
Use this whenever something changes from A to B. It is almost free.

### 2. Explicit animation — we do the work

For a bounce that repeats for ever, or a shake that happens once, there is no
"from A to B". We need to control each frame ourselves with an
**`AnimationController`**:

```dart
_bounce = AnimationController(
  duration: const Duration(milliseconds: 700),
  vsync: this,
);
_bounce.repeat(reverse: true);
```

The controller counts from `0.0` to `1.0` over its duration. We read
`_bounce.value` and turn it into movement:
`Transform.translate(offset: Offset(0, -12 * _bounce.value))`.

Three things come with an `AnimationController`:

- **`vsync: this`** — it needs a ticker, which is why the state class says
  `with TickerProviderStateMixin`.
- **`dispose()`** — just like the timer last lesson. Dispose it or it leaks.
- **`AnimatedBuilder`** — rebuilds only the moving part, not the whole screen.

### Noticing a change: `didUpdateWidget`

How does `PetView` know the pet has just been fed? The home screen keeps a
counter `_shakeCount` and adds one on every feed. `PetView` compares the old
number with the new one inside `didUpdateWidget` and shakes when they differ.
It does not care what the number *is*, only that it **changed**.

## Files added or changed

- `lib/widgets/pet_view.dart` — now a `StatefulWidget` with a bounce
  controller, a shake controller, and `AnimatedContainer`s for the body, eyes
  and mouth.
- `lib/screens/home_screen.dart` — keeps `_shakeCount` and bumps it on feed.
- `test/widget_test.dart` — taps Feed, jumps 60ms into the shake, and checks
  the pet really moved sideways.

## Build it live (teacher script)

1. Start with the easy win: change the three `Container`s in `pet_view.dart`
   into `AnimatedContainer`s and give each a `duration`. Hot reload and tap
   Play until the mood changes. The colour fades! One word of code.
2. Note the small fix to `_Eye`: `AnimatedContainer` cannot slide between
   `BoxShape.circle` and a rectangle, so we use `borderRadius` instead
   (13 for a circle, 3 for a closed eye).
3. Now the explicit part. Turn `PetView` into a `StatefulWidget` and add
   `with TickerProviderStateMixin`.
4. Create `_bounce` in `initState`, call `_bounce.repeat(reverse: true)`, and
   wrap the body in `AnimatedBuilder` + `Transform.translate`. Hot restart —
   the pet bounces!
5. Add `dispose()` immediately. Ask the class what last lesson taught us.
6. Add `_syncBounce()` and call it from `didUpdateWidget` so the pet only
   bounces while it is happy. Tap Play / let it get hungry and watch it settle.
7. Add the `_shake` controller. Explain the `sin()` line by drawing a wave on
   the board: `sin` swings left and right, and `(1 - value)` makes the wobble
   fade out.
8. Add `shakeCount` to `PetView`, pass `_shakeCount` from the home screen, and
   bump it in the Feed button. Tap Feed — the pet wobbles.
9. Run `flutter analyze` and `flutter test`.

## Quick check

1. When would you use `AnimatedContainer` instead of an `AnimationController`?
2. What does `vsync: this` need, and what do we add to the state class to
   provide it?
3. `PetView` shakes when `shakeCount` changes. Why does the actual number not
   matter?

## Homework

**Easy:** make the bounce bigger by changing `-12` to `-30`, and slower by
changing the duration to 1500ms. Which looks more like a happy pet?

**Bonus (older students):** make the pet grow slightly when it is happy using
`AnimatedScale`, and spin once when it is fed using
`RotationTransition` driven by the shake controller.
