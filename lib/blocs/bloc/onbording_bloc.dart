import 'package:bloc/bloc.dart';
import 'package:naked_truth/utils/share_preferences_user_data.dart';

import '../../l10n/app_localizations.dart';
import '../event/onbording_event.dart';
import '../state/onbording_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AppLocalizations l10n;

  late final List<Map<String, String>> pages;
  int _currentIndex = 0;

  OnboardingBloc(this.l10n) : super(OnboardingInitial()) {
    pages = [
      {
        'title': l10n.onboardingFirstTitle,
        'description': l10n.onboardingFirstText,
        'button': l10n.buttonNext,
        'image': 'assets/onboarding_image/onboarding1.png',
      },
      {
        'title': l10n.onboardingSecondTitle,
        'description': l10n.onboardingSecondText,
        'button': l10n.buttonNext,
        'image': 'assets/onboarding_image/onboarding2.png',
      },
      {
        'title': l10n.onboardingThirdTitle,
        'description': l10n.onboardingThirdText,
        'button': l10n.buttonNext,
        'image': 'assets/onboarding_image/onboarding3.png',
      },
      {
        'title': l10n.onboardingFourthTitle,
        'description': l10n.onboardingFourthText,
        'button': l10n.buttonStart,
        'image': 'assets/onboarding_image/onboarding4.png',
      },
    ];

    on<StartOnboarding>((event, emit) {
      _emitPage(emit);
    });

    on<NextOnboardingPage>((event, emit) async {
      if (_currentIndex < pages.length - 1) {
        _currentIndex++;
        _emitPage(
          emit,
          showRateDialog: _currentIndex == 2,
        );
      } else {
        await SPUserData.setHasSeenOnboarding(false);
        emit(OnboardingCompleted());
      }
    });
  }

  void _emitPage(Emitter<OnboardingState> emit, {bool showRateDialog = false}) {
    final page = pages[_currentIndex];

    final state = showRateDialog
        ? OnboardingShowRateDialog(
      currentIndex: _currentIndex,
      totalPages: pages.length,
      title: page['title']!,
      description: page['description']!,
      buttonText: page['button']!,
      imageAsset: page['image']!,
    )
        : OnboardingLoaded(
      currentIndex: _currentIndex,
      totalPages: pages.length,
      title: page['title']!,
      description: page['description']!,
      buttonText: page['button']!,
      imageAsset: page['image']!,
    );

    emit(state);
  }
}
