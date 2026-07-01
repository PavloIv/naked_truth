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
    on<AcceptIncomingFriendRequest>(_onAcceptIncomingFriendRequest);
    on<DeclineIncomingFriendRequest>(_onDeclineIncomingFriendRequest);
    on<CancelOutgoingFriendRequest>(_onCancelOutgoingFriendRequest);
  }

  Future<void> _onLoadMyFriendCode(
      LoadMyFriendCode event, Emitter<AddFriendState> emit) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    final data = await userService.loadAddFriendPageData(user.uid);
    emit(
      AddFriendLoaded(
        data.myFriendCode,
        incomingRequest: data.incomingRequest,
        outgoingRequest: data.outgoingRequest,
      ),
    );
  }

  Future<void> _onAddFriendByCode(
      AddFriendByCode event, Emitter<AddFriendState> emit) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    emit(AddFriendLoading());

    final result = await userService.addFriendByCode(
      user.uid,
      event.code,
      replaceExistingFriend: event.replaceExistingFriend,
    );

    if (result.success) {
      emit(AddFriendSuccess(result.message, shouldClose: result.shouldClose));
      add(LoadMyFriendCode());
    } else {
      emit(AddFriendFailure(result.message));
    }
  }

  Future<void> _onAcceptIncomingFriendRequest(
    AcceptIncomingFriendRequest event,
    Emitter<AddFriendState> emit,
  ) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    emit(AddFriendLoading());
    final result = await userService.acceptIncomingFriendRequest(user.uid);

    if (result.success) {
      emit(AddFriendSuccess(result.message, shouldClose: result.shouldClose));
      if (!result.shouldClose) {
        add(LoadMyFriendCode());
      }
    } else {
      emit(AddFriendFailure(result.message));
      add(LoadMyFriendCode());
    }
  }

  Future<void> _onDeclineIncomingFriendRequest(
    DeclineIncomingFriendRequest event,
    Emitter<AddFriendState> emit,
  ) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    emit(AddFriendLoading());
    final result = await userService.declineIncomingFriendRequest(user.uid);

    if (result.success) {
      emit(AddFriendSuccess(result.message, shouldClose: result.shouldClose));
      add(LoadMyFriendCode());
    } else {
      emit(AddFriendFailure(result.message));
      add(LoadMyFriendCode());
    }
  }

  Future<void> _onCancelOutgoingFriendRequest(
    CancelOutgoingFriendRequest event,
    Emitter<AddFriendState> emit,
  ) async {
    final user = auth.currentUser;
    if (user == null) {
      emit(AddFriendFailure('Ви не авторизовані'));
      return;
    }

    emit(AddFriendLoading());
    final result = await userService.cancelOutgoingFriendRequest(user.uid);

    if (result.success) {
      emit(AddFriendSuccess(result.message, shouldClose: result.shouldClose));
      add(LoadMyFriendCode());
    } else {
      emit(AddFriendFailure(result.message));
      add(LoadMyFriendCode());
    }
  }
}
