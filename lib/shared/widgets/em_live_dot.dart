import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

class EmLiveDot extends StatelessWidget {
  const EmLiveDot({super.key, this.size = 8, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.ok;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .custom(
          duration: 1600.ms,
          builder: (context, value, child) {
            final scale = 1.0 + value * 0.5;
            return Transform.scale(scale: scale, child: child);
          },
        );
  }
}
