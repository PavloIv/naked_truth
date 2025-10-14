import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../service/auth_service.dart';
import '../event/auth_event.dart';
import '../state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService service;
  StreamSubscription<User?>? _sub;

  AuthBloc({required this.service}) : super(const AuthState.unknown()) {
    _sub = service.authStateChanges().listen((user) {
      add(AuthUserChanged(user));
    });

    on<AuthUserChanged>((e, emit) {
      if (e.user != null) {
        emit(AuthState.authenticated(e.user!));
      } else {
        if (state.status != AuthStatus.authenticating) {
          emit(const AuthState.unauthenticated());
        }
      }
    });

    on<SignInWithGooglePressed>((e, emit) async {
      if (state.status == AuthStatus.authenticating) return;
      emit(const AuthState.authenticating());
      try {
        await service.signInWithGoogle(serverClientId: e.serverClientId);
      } catch (err) {
        emit(AuthState.failure(err.toString()));
        emit(const AuthState.unauthenticated());
      }
    });

    on<SignInWithApplePressed>((e, emit) async {
      if (state.status == AuthStatus.authenticating) return;
      emit(const AuthState.authenticating());
      try {
        await service.signInWithApple();
      } catch (err) {
        emit(AuthState.failure(err.toString()));
        emit(const AuthState.unauthenticated());
      }
    });

    on<SignOutRequested>((e, emit) async {
      await service.signOut();
      emit(const AuthState.unauthenticated());
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
