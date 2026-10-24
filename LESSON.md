# Lesson 02: Hunger, Happiness, Energy

## The new idea

Until now our screen was frozen. Today it comes alive.

A **`StatelessWidget`** can never change. Once it is drawn, that is it.
A **`StatefulWidget`** is allowed to remember numbers and change them later.

A stateful widget comes in two pieces:

1. the widget itself (`HomeScreen`) — small and boring, it just says
   `createState()`;
2. the **state** class (`_HomeScreenState`) — this is where the numbers live
   and where the real code goes.

And the magic word is **`setState`**:

```dart
setState(() {
  hunger = hunger - 25;
});
```

`setState` means: "I changed something — please draw the screen again."
If you change a number *without* `setState`, the number really does change but
the screen never notices. That bug catches everyone once!

One more trick: `clamp(0, 100)`. It squeezes a number so it can never be
smaller than 0 or bigger than 100. Without it, hunger could become -85 and the
bar would break.

## Files added or changed

- `lib/widgets/stat_bar.dart` — **new.** A label, a `LinearProgressIndicator`
  and the number.
- `lib/screens/home_screen.dart` — now a `StatefulWidget` with `hunger`,
  `happiness` and `energy`, and three functions that change them.
- `test/widget_test.dart` — taps Feed and checks the number went down, and
  checks stats stop at 0.

## Build it live (teacher script)

1. In `home_screen.dart`, change `extends StatelessWidget` to
   `extends StatefulWidget`. The editor shows a red line — use the quick fix
   ("Create missing override") or type the two classes by hand.
2. Add the three numbers at the top of `_HomeScreenState`:
   `int hunger = 40; int happiness = 70; int energy = 80;`
3. Build `stat_bar.dart`. Explain the division: the bar wants `0.0` to `1.0`
   but humans like `0` to `100`, so `value / 100`.
4. Put the three `StatBar` widgets in the `Column`. Hot reload — three bars!
5. Write `feed()` **without** `setState` first. Tap the button: nothing
   happens. Let students puzzle over it. Then wrap it in `setState` and tap
   again. This is the moment of the lesson.
6. Add `play()` and `sleep()`. Decide together what each one should do.
6b. On a small phone you will now see the black-and-yellow "overflow" stripes:
   the content got taller than the screen. Swap the `Padding` around the
   `Column` for a `SingleChildScrollView` and the stripes disappear. Say it
   plainly: **if it does not fit, let it scroll.**
7. Tap Feed many times until hunger would go negative — show the broken bar,
   then add `_clamp` and fix it.
8. Give `_ActionButton` an `onPressed` parameter and pass `feed`, `play`,
   `sleep` in. Note we write `feed` with **no brackets** — we are handing over
   the function, not calling it.
9. Run `flutter analyze` and `flutter test`.

## Quick check

1. What is the one big difference between a `StatelessWidget` and a
   `StatefulWidget`?
2. What goes wrong if you change a number but forget `setState`?
3. Why do we pass `feed` and not `feed()` to the button?

## Homework

**Easy:** add a "Bath" button that raises happiness by 10. Then change the
starting numbers so your pet begins sad and starving.

**Bonus (older students):** make the Hunger bar turn red when hunger is over
70 and stay green below that. Hint: you can choose a colour with an `if` before
the `return`, or with `hunger > 70 ? Colors.red : Colors.green`.
