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
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        fontFamily: 'Inter', // Assuming Inter based on general-layout docs
        useMaterial3: true,
      ),
      routerConfig: goRouter,
    );
  }
}
