import 'package:flutter/material.dart';

class EmScrollContent extends StatelessWidget {
  const EmScrollContent({
    super.key,
    required this.child,
    this.padded = false,
  });

  final Widget child;

  /// If true, wraps content in EdgeInsets.fromLTRB(16, 4, 16, 24).
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: const _NoScrollbarBehavior(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: padded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: child,
                )
              : child,
        ),
      ),
    );
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
