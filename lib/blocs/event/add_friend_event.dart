abstract class AddFriendEvent {}

class LoadMyFriendCode extends AddFriendEvent {}

class AddFriendByCode extends AddFriendEvent {
  final String code;
  final bool replaceExistingFriend;

  AddFriendByCode(this.code, {this.replaceExistingFriend = false});
}
