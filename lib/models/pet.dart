/// The four feelings our pet can have.
/// An enum is just a short list of named choices — you cannot misspell one,
/// which is why it is safer than using the words 'happy', 'sad' as text.
enum Mood { happy, okay, sad, sleepy }

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

  /// Works out how the pet is feeling from its three numbers.
  /// This is a *getter*: it looks like a field when you use it
  /// (`pet.mood`) but it does a little thinking first.
  ///
  /// The order of the checks matters! A very tired pet is sleepy even if it
  /// is also happy, because we check energy first.
  Mood get mood {
    if (energy < 25) return Mood.sleepy;
    if (hunger > 70 || happiness < 30) return Mood.sad;
    if (happiness >= 70) return Mood.happy;
    return Mood.okay;
  }

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

  /// One "tick" of time passing. Living costs the pet a little of everything:
  /// it gets hungrier, slightly less cheerful, and slightly more tired.
  void tick() {
    hunger = clamp(hunger + 5);
    happiness = clamp(happiness - 2);
    energy = clamp(energy - 2);
  }

  /// True when the pet is so hungry that we should warn the player.
  bool get isStarving => hunger >= 80;
}
