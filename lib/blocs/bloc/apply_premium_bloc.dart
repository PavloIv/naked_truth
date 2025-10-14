import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../service/friend_code_service.dart';
import '../event/apply_premium_event.dart';
import '../state/apply_premium_state.dart';

class ApplyPremiumBloc extends Bloc<ApplyPremiumEvent, ApplyPremiumState> {
  final FriendCodeService service;
  final FirebaseAuth auth;

  ApplyPremiumBloc({required this.service, required this.auth})
      : super(ApplyPremiumInitial()) {
    on<ApplyPremiumCode>(_onApplyPremiumCode);
  }

  Future<void> _onApplyPremiumCode(
      ApplyPremiumCode event, Emitter<ApplyPremiumState> emit) async {
    emit(ApplyPremiumLoading());

    final user = auth.currentUser;
    if (user == null) {
      emit(const ApplyPremiumFailure('Ви не авторизовані'));
      return;
    }

    final result = await service.applyFriendCode(
      code: event.code,
      friendUid: user.uid,
    );

    if (result == null) {
      emit(const ApplyPremiumSuccess('Преміум код застосовано!'));
    } else {
      emit(ApplyPremiumFailure('❌ $result'));
    }
  }
}