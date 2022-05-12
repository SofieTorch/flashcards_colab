import 'package:flutter/material.dart';

class DeckFinishedMessage extends StatelessWidget {
  const DeckFinishedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎉',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 8),
          Text(
            "Great! You're done for this session 🥳",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Return to deck'),
          ),
        ],
      ),
    );
  }
}
