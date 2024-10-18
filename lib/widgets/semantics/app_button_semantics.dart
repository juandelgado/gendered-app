import 'package:flutter/material.dart';

class AppButtonSemantics extends StatelessWidget {
  const AppButtonSemantics({
    required this.child,
    required this.hint,
    super.key,
  });

  final Widget child;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      hint: hint,
      child: ExcludeSemantics(
        child: child,
      ),
    );
  }
}
