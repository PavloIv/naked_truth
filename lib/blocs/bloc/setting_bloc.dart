import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/share_preferences_user_data.dart';
import '../event/setting_event.dart';
import '../state/setting_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
  }

  Future<void> _onLoadSettings(
      LoadSettings event,
      Emitter<SettingsState> emit,
      ) async {
    try {
      final results = await Future.wait([
        SPUserData.getHavePremium(),
        SPUserData.getCodePremium(),
        SPUserData.getCodePremiumTo(),
        SPUserData.getFriendUid(),
        SPUserData.getFriendName(),
        SPUserData.getFriendCode(),
      ]);

      final isPremium = results[0] as bool;
      final myFriendPremiumCode = results[1] as String?;
      final premiumTo = results[2] as DateTime?;
      final friendUid = results[3] as String?;
      final friendName = results[4] as String?;
      final friendCode = results[5] as String?;

      emit(SettingsLoaded(
        isPremium: isPremium,
        friendUid: friendUid,
        friendName: friendName,
        friendCode: friendCode,
        myFriendPremiumCode: myFriendPremiumCode,
        premiumTo: premiumTo,
      ));
    } catch (e) {
      emit(const SettingsLoaded(isPremium: false));
    }
  }
}
