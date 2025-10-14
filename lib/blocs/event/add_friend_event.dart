abstract class AddFriendEvent {}

class LoadMyFriendCode extends AddFriendEvent {}

class AddFriendByCode extends AddFriendEvent {
  final String code;
  AddFriendByCode(this.code);
}
