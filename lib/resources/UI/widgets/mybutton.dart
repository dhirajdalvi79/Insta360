import 'package:flutter/material.dart';
import '../../utilities/colors.dart';

// Reusable custom button.
class MyButton extends StatelessWidget {
  const MyButton(
      {Key? key,
      this.buttonHeight = 35,
      this.buttonWidth = 150,
      required this.buttonText,
      required this.onButtonPressed,
      this.color = primaryColor})
      : super(key: key);
  final double buttonHeight;
  final double buttonWidth;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(color),
          foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
          fixedSize:
              MaterialStatePropertyAll<Size>(Size(buttonWidth, buttonHeight)),
          minimumSize: const MaterialStatePropertyAll<Size>(Size(1, 1)),
          maximumSize: const MaterialStatePropertyAll<Size>(Size(200, 200)),
        ),
        onPressed: onButtonPressed,
        child: Text(buttonText));
  }
}
