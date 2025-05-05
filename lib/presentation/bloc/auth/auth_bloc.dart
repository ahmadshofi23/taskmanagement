import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minitaskmanagementapps/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUp(
          email: event.email,
          password: event.password,
        );
        if (user != null) {
          emit(Authenticated(user.uid));
        } else {
          emit(AuthError('Failed to sign up'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signIn(
          email: event.email,
          password: event.password,
        );
        if (user != null) {
          emit(Authenticated(user.uid));
        } else {
          emit(AuthError('Failed to sign in'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
