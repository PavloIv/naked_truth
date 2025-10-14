abstract class AddFriendState {}

class AddFriendInitial extends AddFriendState {}

class AddFriendLoading extends AddFriendState {}

class AddFriendLoaded extends AddFriendState {
  final String myFriendCode;
  AddFriendLoaded(this.myFriendCode);
}

class AddFriendSuccess extends AddFriendState {
  final String message;
  AddFriendSuccess(this.message);
}

class AddFriendFailure extends AddFriendState {
  final String error;
  AddFriendFailure(this.error);
}
