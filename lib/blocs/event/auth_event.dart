
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final User? user;
  const AuthUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class SignInWithGooglePressed extends AuthEvent {
  final String? serverClientId;
  const SignInWithGooglePressed({this.serverClientId});
}

class SignInWithApplePressed extends AuthEvent {
  const SignInWithApplePressed();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
