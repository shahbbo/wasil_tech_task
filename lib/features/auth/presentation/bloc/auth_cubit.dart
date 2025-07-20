import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;

  AuthCubit({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    final result = await loginUser(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    
    final result = await registerUser(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    
    final result = await logoutUser();
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}