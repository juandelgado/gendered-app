import 'package:flutter/material.dart';
import 'package:gendered/widgets/semantics/app_button_semantics.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.hint,
    required this.text,
    this.onPressed,
    super.key,
  });

  final String hint;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButtonSemantics(
      hint: hint,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
