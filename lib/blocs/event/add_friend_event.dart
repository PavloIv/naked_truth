abstract class AddFriendEvent {}

class LoadMyFriendCode extends AddFriendEvent {}

class AddFriendByCode extends AddFriendEvent {
  final String code;
  final bool replaceExistingFriend;

  AddFriendByCode(this.code, {this.replaceExistingFriend = false});
}

class AcceptIncomingFriendRequest extends AddFriendEvent {}

class DeclineIncomingFriendRequest extends AddFriendEvent {}

class CancelOutgoingFriendRequest extends AddFriendEvent {}
