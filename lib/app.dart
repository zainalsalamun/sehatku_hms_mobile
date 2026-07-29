import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/admin/presentation/admin_dashboard_screen.dart';
import 'features/authentication/presentation/login_screen.dart';
import 'features/doctor/presentation/doctor_dashboard_screen.dart';
import 'features/patient/presentation/patient_shell.dart';
import 'features/splash/presentation/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/patient', builder: (_, _) => const PatientShell()),
      GoRoute(
        path: '/doctor',
        builder: (_, _) => const DoctorDashboardScreen(),
      ),
      GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardScreen()),
    ],
  );
});

class SehatKuApp extends ConsumerWidget {
  const SehatKuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SehatKu HMS',
      theme: AppTheme.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
