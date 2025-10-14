import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naked_truth/service/user_service.dart';

import '../event/add_friend_event.dart';
import '../state/add_friend_state.dart';


class AddFriendBloc extends Bloc<AddFriendEvent, AddFriendState> {
  final UserService userService;
  final FirebaseAuth auth;

  AddFriendBloc({required this.userService, required this.auth})
      : super(AddFriendInitial()) {
    on<LoadMyFriendCode>(_onLoadMyFriendCode);
    on<AddFriendByCode>(_onAddFriendByCode);
  }

  Future<void> _onLoadMyFriendCode(
      LoadMyFriendCode event, Emitter<AddFriendState> emit) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    final code = await userService.getFriendCode(user.uid);
    emit(AddFriendLoaded(code!));
  }

  Future<void> _onAddFriendByCode(
      AddFriendByCode event, Emitter<AddFriendState> emit) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    emit(AddFriendLoading());

    final success = await userService.addFriendByCode(user.uid, event.code);

    if (success) {
      emit(AddFriendSuccess('Друг доданий!'));
      add(LoadMyFriendCode());
    } else {
      emit(AddFriendFailure('Код не знайдено або не можна додати себе'));
    }
  }
}
