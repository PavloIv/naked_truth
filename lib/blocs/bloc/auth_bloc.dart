import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../service/auth_service.dart';
import '../event/auth_event.dart';
import '../state/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService service;
  StreamSubscription<User?>? _sub;

  AuthBloc({required this.service}) : super(const AuthState.unknown()) {
    _sub = service.authStateChanges().listen((user) {
      debugPrint('AuthBloc.authStateChanges: user=${user?.uid}');
      add(AuthUserChanged(user));
    });

    on<AuthUserChanged>((e, emit) {
      debugPrint('AuthBloc.AuthUserChanged: user=${e.user?.uid}');
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
      debugPrint('AuthBloc.SignOutRequested: start');
      try {
        await service.signOut();
        debugPrint('AuthBloc.SignOutRequested: service.signOut complete');
        emit(const AuthState.unauthenticated());
      } catch (err) {
        debugPrint('AuthBloc.SignOutRequested: failed: $err');
        emit(AuthState.failure(err.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
