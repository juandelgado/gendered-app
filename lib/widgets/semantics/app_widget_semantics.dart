import 'package:flutter/material.dart';

class AppWidgetSemantics extends StatelessWidget {
  const AppWidgetSemantics({
    required this.value,
    required this.child,
    this.isLiveRegion = false,
    super.key,
  });

  final String value;
  final Widget child;
  final bool isLiveRegion;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      value: value,
      focusable: isLiveRegion,
      focused: isLiveRegion,
      liveRegion: isLiveRegion,
      child: ExcludeSemantics(
        child: child,
      ),
    );
  }
}
