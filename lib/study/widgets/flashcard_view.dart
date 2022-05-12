import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  const FlashcardView({required this.content, Key? key}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
