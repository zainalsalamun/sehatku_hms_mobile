import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/health_models.dart';

class AuthState {
  const AuthState({this.role = UserRole.patient, this.isLoading = false});
  final UserRole role;
  final bool isLoading;

  AuthState copyWith({UserRole? role, bool? isLoading}) => AuthState(
    role: role ?? this.role,
    isLoading: isLoading ?? this.isLoading,
  );
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void selectRole(UserRole role) => state = state.copyWith(role: role);

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isLoading: false);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
