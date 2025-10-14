import 'package:equatable/equatable.dart';

abstract class ApplyPremiumEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyPremiumCode extends ApplyPremiumEvent {
  final String code;
  ApplyPremiumCode(this.code);

  @override
  List<Object?> get props => [code];
}