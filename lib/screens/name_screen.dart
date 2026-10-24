import 'package:flutter/material.dart';

import 'home_screen.dart';

/// The colours a player is allowed to choose for their pet.
/// A top-level `const` list like this is a tidy place to keep choices.
const List<Color> petColors = [
  Color(0xFFFFCC80), // orange
  Color(0xFFF48FB1), // pink
  Color(0xFF80DEEA), // cyan
  Color(0xFFA5D6A7), // green
  Color(0xFFCE93D8), // purple
  Color(0xFFFFF59D), // yellow
];

/// The second screen: "what will you call your pet?"
///
/// It collects a name and a colour, checks they make sense, and then opens
/// the home screen with them.
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

/// Holds the text being typed and the colour that is currently chosen.
class _NameScreenState extends State<NameScreen> {
  /// A key is like a name tag we pin on the Form so we can find it later and
  /// ask it "are all your fields filled in correctly?"
  final _formKey = GlobalKey<FormState>();

  /// A controller is the box the typed letters live in. We can read it any
  /// time with `_nameController.text`.
  final _nameController = TextEditingController();

  /// Which colour is chosen right now. We start on the first one.
  Color _chosenColor = petColors.first;

  /// Controllers must be disposed, just like timers and animation
  /// controllers. Same rule, third time we have met it.
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Checks one name and returns an error message, or null if it is fine.
  /// Returning `null` is how a validator says "this is good".
  String? _checkName(String? value) {
    final name = (value ?? '').trim();

    if (name.isEmpty) {
      return 'Your pet needs a name!';
    }
    if (name.length > 12) {
      return 'That is too long — 12 letters at most.';
    }
    return null;
  }

  /// Runs when Start is pressed.
  void _submit() {
    // `validate()` runs every validator in the Form. It returns true only if
    // they all said null.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // pushReplacement swaps this screen for the home screen instead of
    // stacking on top of it, so the back button cannot bring the player back
    // to a form they have already filled in.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          petName: _nameController.text.trim(),
          petColor: _chosenColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to PetPal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What will you call your pet?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                // The on-screen keyboard shows a "done" key instead of enter.
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: _checkName,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  labelText: 'Pet name',
                  hintText: 'Bolu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Pick a colour',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              // One tappable circle per colour. `Wrap` moves them onto a new
              // line if the phone is narrow.
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final color in petColors)
                    _ColorChoice(
                      // A key is a label Flutter (and our tests) can use to
                      // tell one circle from another.
                      key: ValueKey(color),
                      color: color,
                      chosen: color == _chosenColor,
                      onTap: () => setState(() => _chosenColor = color),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One coloured circle the player can tap. It grows a dark ring and a tick
/// when it is the chosen one.
class _ColorChoice extends StatelessWidget {
  const _ColorChoice({
    super.key,
    required this.color,
    required this.chosen,
    required this.onTap,
  });

  final Color color;
  final bool chosen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: chosen ? Colors.black87 : Colors.black12,
            width: chosen ? 4 : 2,
          ),
        ),
        child: chosen
            ? const Icon(Icons.check, color: Colors.black87)
            : null,
      ),
    );
  }
}
