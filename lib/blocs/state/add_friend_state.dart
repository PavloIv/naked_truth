import 'package:naked_truth/service/user_service.dart';

abstract class AddFriendState {}

class AddFriendInitial extends AddFriendState {}

class AddFriendLoading extends AddFriendState {}

class AddFriendLoaded extends AddFriendState {
  final String myFriendCode;
  final FriendRequestInfo? incomingRequest;
  final FriendRequestInfo? outgoingRequest;

  AddFriendLoaded(
    this.myFriendCode, {
    this.incomingRequest,
    this.outgoingRequest,
  });
}

class AddFriendSuccess extends AddFriendState {
  final String message;
  final bool shouldClose;

  AddFriendSuccess(this.message, {this.shouldClose = false});
}

class AddFriendFailure extends AddFriendState {
  final String error;
  AddFriendFailure(this.error);
}
