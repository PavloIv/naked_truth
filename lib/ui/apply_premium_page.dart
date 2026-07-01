import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../blocs/bloc/apply_premium_bloc.dart';
import '../blocs/event/apply_premium_event.dart';
import '../blocs/state/apply_premium_state.dart';
import '../l10n/app_localizations.dart';

class ApplyPremiumPage extends StatefulWidget {
  final String? myPremiumCode;
  final bool? havePremium;
  final DateTime? premiumTo;

  const ApplyPremiumPage({
    super.key,
    this.myPremiumCode,
    this.havePremium,
    this.premiumTo,
  });

  @override
  State<ApplyPremiumPage> createState() => _ApplyPremiumPageState();
}

class _ApplyPremiumPageState extends State<ApplyPremiumPage> {
  final _controllerPremium = TextEditingController();

  void _applyPremiumCode() {
    final code = _controllerPremium.text.trim();
    if (code.isNotEmpty) {
      context.read<ApplyPremiumBloc>().add(ApplyPremiumCode(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            height: screenH,
            decoration: const BoxDecoration(gradient: appBackgroundGradient),
          ),
          SafeArea(
            child: BlocConsumer<ApplyPremiumBloc, ApplyPremiumState>(
              listener: (context, state) {
                if (state is ApplyPremiumSuccess ||
                    state is ApplyPremiumFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state is ApplyPremiumSuccess
                            ? state.message
                            : (state as ApplyPremiumFailure).error,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is ApplyPremiumLoading;
                return Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: const BackButton(color: Colors.white),
                      title: Text(
                        AppLocalizations.of(context)!.activatePremium,
                        style: const TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                    const SizedBox(height: 16),
                    if (widget.myPremiumCode != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: purpleGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.key,
                                  color: Colors.white, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .yourPremiumCodeForFriend,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      widget.myPremiumCode!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _controllerPremium,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .enterPremiumCode,
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText:
                              AppLocalizations.of(context)!.premiumCodeExample,
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black26,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _applyPremiumCode(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _applyPremiumCode,
                        icon: isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Icon(Icons.star),
                        label: Text(
                          isLoading
                              ? AppLocalizations.of(context)!.applying
                              : AppLocalizations.of(context)!.activatePremium,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (widget.havePremium != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.havePremium == true
                                    ? AppLocalizations.of(context)!
                                        .premiumActive
                                    : AppLocalizations.of(context)!
                                        .premiumInactive,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.havePremium == true &&
                                  widget.premiumTo != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!
                                      .premiumValidUntil(
                                    widget.premiumTo.toString(),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
