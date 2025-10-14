import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool? isPremium;
  final String? friendUid;
  final String? friendName;
  final String? friendCode;
  final String? myFriendPremiumCode;
  final DateTime? premiumTo;

  const SettingsLoaded({
    this.isPremium,
    this.friendUid,
    this.friendName,
    this.friendCode,
    this.myFriendPremiumCode,
    this.premiumTo,
  });
}

