
import 'package:equatable/equatable.dart';

abstract class ApplyPremiumState extends Equatable {
  const ApplyPremiumState();

  @override
  List<Object?> get props => [];
}

class ApplyPremiumInitial extends ApplyPremiumState {}

class ApplyPremiumLoading extends ApplyPremiumState {}

class ApplyPremiumSuccess extends ApplyPremiumState {
  final String message;
  const ApplyPremiumSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ApplyPremiumFailure extends ApplyPremiumState {
  final String error;
  const ApplyPremiumFailure(this.error);

  @override
  List<Object?> get props => [error];
}
