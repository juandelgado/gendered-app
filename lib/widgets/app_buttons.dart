import 'package:flutter/material.dart';
import 'package:gendered/widgets/semantics/app_button_semantics.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.hint,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.style,
    super.key,
  });

  final String hint;
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return AppButtonSemantics(
      hint: hint,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        ),
      ),
    );
  }
}

class PrimaryTextButton extends PrimaryButton {
  PrimaryTextButton({
    required String text,
    required super.hint,
    super.onPressed,
    super.key,
  }) : super(
          child: Text(text),
        );
}

class CircularWidgetButton extends PrimaryButton {
  CircularWidgetButton({
    required super.hint,
    required super.onPressed,
    required super.child,
    super.width,
    super.height,
    super.key,
  }) : super(
          style: ButtonStyle(
            shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
              (Set<WidgetState> states) {
                return const CircleBorder();
              },
            ),
          ),
        );
}

class CircularTextButton extends CircularWidgetButton {
  CircularTextButton({
    required String text,
    required super.hint,
    required super.onPressed,
    super.width,
    super.height,
    super.key,
    TextStyle? style,
  }) : super(
          child: Text(
            text,
            style: style,
          ),
        );
}
