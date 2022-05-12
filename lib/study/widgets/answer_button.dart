import 'package:flashcards_colab/theme/theme.dart';
import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    this.onPressed,
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  final void Function()? onPressed;
  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.snuff),
        foregroundColor: MaterialStateProperty.all(AppColors.body),
        padding: MaterialStateProperty.all(const EdgeInsets.all(4)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon),
            const SizedBox(height: 4),
            Text(text),
          ],
        ),
      ),
    );
  }
}
