import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(
    const ProviderScope(
      child: GamingZoneApp(),
    ),
  );
}

class GamingZoneApp extends ConsumerWidget {
  const GamingZoneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Gaming Zone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.buttonBg,
          surface: AppColors.surface,
          error: AppColors.err,
          onPrimary: AppColors.buttonFg,
          onSurface: AppColors.textPrimary,
        ),
        fontFamily: 'Geist',
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      routerConfig: goRouter,
    );
  }
}
