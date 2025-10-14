
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { unknown, unauthenticated, authenticating, authenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState._({required this.status, this.user, this.error});

  const AuthState.unknown()         : this._(status: AuthStatus.unknown);
  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticating()  : this._(status: AuthStatus.authenticating);
  const AuthState.failure(String e) : this._(status: AuthStatus.failure, error: e);
  const AuthState.authenticated(User u) : this._(status: AuthStatus.authenticated, user: u);

  @override
  List<Object?> get props => [status, user, error];
}
