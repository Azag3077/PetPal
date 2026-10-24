# Lesson 07: Painting With Code

## The new idea

Our pet is made of boxes. Boxes are great for buttons and cards, but they are a
clumsy way to draw a face — you cannot make a *curved* smile out of a
rectangle.

So today we put the boxes away and pick up a **crayon**.

A **`CustomPainter`** gives us a blank sheet of paper (the **canvas**) and lets
us draw shapes wherever we like:

```dart
canvas.drawCircle(middle, radius, body);
canvas.drawLine(start, end, closed);
canvas.drawPath(path, mouth);
```

Three new words:

- **`Canvas`** — the paper. It has a `size` so we know how big the paper is.
- **`Paint`** — the crayon. It holds a colour, and a `style` that is either
  `fill` (colour the shape in) or `stroke` (just the outline).
- **`Path`** — a route for the crayon to follow. `moveTo` lifts the crayon to a
  starting point, and `quadraticBezierTo` draws a smooth curve.

### The smile

This is the nicest part. A curved mouth is one line with a *bend*:

```dart
Path()
  ..moveTo(centre - 38, mouthY)
  ..quadraticBezierTo(centre, mouthY + bend, centre + 38, mouthY);
```

`bend` is a positive number for a smile (the curve sags downwards in the
middle), a negative number for a frown, and `0` for a flat, bored mouth. One
number, every expression.

### `shouldRepaint`

Flutter asks the painter "do I need to draw this again?" If we always said yes,
the pet would be redrawn 60 times a second for no reason. So we compare:

```dart
bool shouldRepaint(PetPainter old) =>
    old.mood != mood || old.bodyColor != bodyColor;
```

### Keeping the fade

`AnimatedContainer` is gone, so how does the colour still fade between moods?
`TweenAnimationBuilder` with a `ColorTween`. It hands us a colour part-way
between the old and the new one on every frame, and we pass that to the
painter. Same idea as last lesson, but for a value we own rather than a
widget's property.

## Files added or changed

- `lib/widgets/pet_painter.dart` — **new.** The whole pet, drawn with
  `drawCircle`, `drawLine` and a curved `Path`.
- `lib/widgets/pet_view.dart` — the Containers are gone; it now returns a
  `CustomPaint` wrapped in a `TweenAnimationBuilder`.
- `test/widget_test.dart` — checks the pet is painted by a `PetPainter`, and
  tests `shouldRepaint` directly.

## Build it live (teacher script)

1. Create `pet_painter.dart` with an empty `paint` method and a
   `shouldRepaint` that returns `true` for now.
2. In `pet_view.dart`, replace `_buildBody()`'s contents with
   `CustomPaint(size: const Size(200, 200), painter: PetPainter(...))`.
   Hot reload — the pet vanishes! Blank paper. Perfect teaching moment.
3. Draw the body: work out `middle` and `radius`, make a `fill` Paint, and call
   `canvas.drawCircle`. Reload — an orange circle.
4. Add the `stroke` Paint and draw the same circle again for the outline.
   Change `strokeWidth` to 20 and back so everyone sees what stroke means.
5. Draw the eyes with `drawCircle`. Let students change `0.35` and `0.65` and
   watch the eyes slide apart. Explain why we use fractions of `size` and not
   fixed numbers: the pet then works at any size.
6. Add the sleepy branch with `drawLine` and `StrokeCap.round`.
7. Now the mouth. Draw it first with `bend = 0` (a flat line), then set
   `bend = 40`. The pet smiles. Then `-30`. The pet frowns. Let them pick the
   numbers for each mood.
8. Fix `shouldRepaint` to compare mood and colour.
9. Add the `TweenAnimationBuilder` to bring the colour fade back.
10. Run `flutter analyze` and `flutter test`.

## Quick check

1. What are the three things a `CustomPainter` works with — what do `Canvas`,
   `Paint` and `Path` each do?
2. In the mouth code, what does a negative `bend` look like on screen?
3. Why do we use `size.width * 0.35` for the eye instead of just `70`?

## Homework

**Easy:** give the pet a tummy — a second, smaller, lighter circle near the
bottom of the body. Then change the mouth `bend` numbers until you like the
faces.

**Bonus (older students):** draw two triangle ears on top of the head using a
`Path` with `moveTo` and `lineTo`, and make them droop when the pet is sad by
changing the triangle's points.
