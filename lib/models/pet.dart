/// Our pet, as a plain Dart class — no widgets, no Flutter, just rules.
///
/// The screen asks the pet to do things (`feed()`, `play()`, `sleep()`) and
/// the pet looks after its own numbers. The screen never changes hunger by
/// hand any more.
class Pet {
  Pet({
    required this.name,
    this.hunger = 40,
    this.happiness = 70,
    this.energy = 80,
  });

  /// What we call our pet.
  final String name;

  /// How hungry the pet is. 0 = full tummy, 100 = starving.
  int hunger;

  /// How happy the pet is. 100 = delighted, 0 = very sad.
  int happiness;

  /// How much energy the pet has left. 100 = bouncing, 0 = exhausted.
  int energy;

  /// Keeps a number inside 0 and 100 so stats never go silly.
  static int clamp(int value) => value.clamp(0, 100);

  /// Feeding fills the tummy and cheers the pet up a little.
  void feed() {
    hunger = clamp(hunger - 25);
    happiness = clamp(happiness + 5);
  }

  /// Playing is fun but tiring, and it makes the pet hungry.
  void play() {
    happiness = clamp(happiness + 20);
    energy = clamp(energy - 15);
    hunger = clamp(hunger + 10);
  }

  /// Sleeping gives back a lot of energy, but you wake up hungry.
  void sleep() {
    energy = clamp(energy + 30);
    hunger = clamp(hunger + 10);
  }
}
