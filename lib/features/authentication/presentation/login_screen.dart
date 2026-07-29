import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/health_models.dart';
import '../application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController(text: 'demo@sehatku.id');
  final passwordController = TextEditingController(text: 'password');
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await ref.read(authControllerProvider.notifier).signIn();
    if (!mounted) return;
    final role = ref.read(authControllerProvider).role;
    context.go('/${role.name}');
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundColor: Color(0xFFE0F4F2),
                          child: Icon(
                            Icons.health_and_safety_rounded,
                            color: AppTheme.primary,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Selamat datang',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 7),
                      const Text('Masuk ke ekosistem layanan SehatKu.'),
                      const SizedBox(height: 24),
                      SegmentedButton<UserRole>(
                        segments: UserRole.values
                            .map(
                              (role) => ButtonSegment(
                                value: role,
                                label: Text(role.label),
                                icon: Icon(switch (role) {
                                  UserRole.patient => Icons.person_outline,
                                  UserRole.doctor =>
                                    Icons.medical_services_outlined,
                                  UserRole.admin =>
                                    Icons.admin_panel_settings_outlined,
                                }),
                              ),
                            )
                            .toList(),
                        selected: {auth.role},
                        onSelectionChanged: (value) => ref
                            .read(authControllerProvider.notifier)
                            .selectRole(value.first),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Lupa password?'),
                        ),
                      ),
                      FilledButton(
                        onPressed: auth.isLoading ? null : _login,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: auth.isLoading
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Masuk'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _login,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                        label: const Text('Lanjutkan dengan Google'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Demo: pilih role apa pun lalu tekan Masuk.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
