import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../blocs/bloc/onbording_bloc.dart';
import '../../blocs/event/onbording_event.dart';
import '../../blocs/state/onbording_state.dart';
import '../../constants.dart';
import '../../l10n/app_localizations.dart';
import '../functional_widget/animated_gradient_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late OnboardingBloc _bloc;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;
      _bloc = OnboardingBloc(l10n)..add(StartOnboarding());
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingCompleted) {
              Navigator.of(context).pushReplacementNamed('/subscription');
            }
          },
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingLoaded) {
                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                final containerHeight = screenHeight * 0.5;

                return Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: onboardingBackgroundGradient,
                      ),
                    ),

                    Positioned(
                      bottom: containerHeight,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Image.asset(
                          state.imageAsset,
                          width: screenWidth - 40,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: containerHeight,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: onboardingContainerGradient,
                          border: Border(
                            top: BorderSide(
                              color: onboardingContainerBorderColor,
                              width: 2,
                            ),
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 30,
                                bottom: 24,
                              ),
                              child: Text(
                                state.title,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontFamily: 'Bitter',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              state.description,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(state.totalPages, (i) {
                                final isActive = i == state.currentIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: isActive ? 16 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white38,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 64,
                                child: AnimatedGradientButton(
                                  text: state.buttonText,
                                  onTap: () async {
                                    if (state.currentIndex == 1) {
                                      final review = InAppReview.instance;
                                      if (await review.isAvailable()) {
                                        await review.requestReview();
                                      } else {
                                        await review.openStoreListing();
                                      }
                                    }
                                    context
                                        .read<OnboardingBloc>()
                                        .add(NextOnboardingPage());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
