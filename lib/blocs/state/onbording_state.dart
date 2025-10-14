abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final String imageAsset;
  final String title;
  final String description;
  final String buttonText;
  final int currentIndex;
  final int totalPages;

  OnboardingLoaded({
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.currentIndex,
    required this.totalPages,
  });
}

class OnboardingShowRateDialog extends OnboardingLoaded {
  OnboardingShowRateDialog({
    required int currentIndex,
    required int totalPages,
    required String title,
    required String description,
    required String buttonText,
    required String imageAsset,
  }) : super(
    currentIndex: currentIndex,
    totalPages: totalPages,
    title: title,
    description: description,
    buttonText: buttonText,
    imageAsset: imageAsset,
  );
}

class OnboardingCompleted extends OnboardingState {}
