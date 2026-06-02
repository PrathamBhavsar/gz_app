import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GzLiveDot extends StatefulWidget {
  const GzLiveDot({super.key, this.size = 8, this.color});

  final double size;
  final Color? color;

  @override
  State<GzLiveDot> createState() => _GzLiveDotState();
}

class _GzLiveDotState extends State<GzLiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.ok;
    return SizedBox(
      width: widget.size + 8,
      height: widget.size + 8,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOut.transform(_controller.value);
          final ringSize = widget.size + (8 * t);
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: ringSize,
                height: ringSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: (1 - t) * 0.22),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          );
        },
      ),
    );
  }
}
