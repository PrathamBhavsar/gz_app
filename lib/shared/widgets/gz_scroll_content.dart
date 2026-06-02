import 'package:flutter/material.dart';

class GzScrollContent extends StatelessWidget {
  const GzScrollContent({super.key, required this.child, this.padded = false});

  final Widget child;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
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
    );
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
