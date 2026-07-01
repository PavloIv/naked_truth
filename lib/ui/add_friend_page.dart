import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../constants.dart';
import '../blocs/bloc/add_friend_bloc.dart';
import '../blocs/event/add_friend_event.dart';
import '../blocs/state/add_friend_state.dart';
import '../l10n/app_localizations.dart';

class AddFriendPage extends StatelessWidget {
  final bool replaceExistingFriend;

  const AddFriendPage({
    super.key,
    this.replaceExistingFriend = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final controllerFriend = TextEditingController();

    void addFriend() {
      final code = controllerFriend.text.trim();
      if (code.isNotEmpty) {
        context.read<AddFriendBloc>().add(
              AddFriendByCode(
                code,
                replaceExistingFriend: replaceExistingFriend,
              ),
            );
      }
    }

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
            child: BlocConsumer<AddFriendBloc, AddFriendState>(
              listener: (context, state) {
                if (state is AddFriendSuccess) {
                  Navigator.of(context).pop(true);
                  return;
                }

                if (state is AddFriendFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                String? myFriendCode;
                bool isLoading = state is AddFriendLoading;

                if (state is AddFriendLoaded) {
                  myFriendCode = state.myFriendCode;
                }

                return Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: const BackButton(color: Colors.white),
                      title: Text(
                        replaceExistingFriend
                            ? AppLocalizations.of(context)!.changeFriend
                            : AppLocalizations.of(context)!.addFriend,
                        style: const TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                    const SizedBox(height: 16),
                    if (myFriendCode != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
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
                                child: SelectableText(
                                  myFriendCode,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: AppLocalizations.of(context)!.copy,
                                icon: const Icon(Icons.copy,
                                    color: Colors.white),
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: myFriendCode!));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(context)!.codeCopied,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                tooltip: AppLocalizations.of(context)!.share,
                                icon: const Icon(Icons.share,
                                    color: Colors.white),
                                onPressed: () {
                                  SharePlus.instance.share(
                                    ShareParams(text: myFriendCode!),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controllerFriend,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.enterFriendCode,
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText:
                              AppLocalizations.of(context)!.friendCodeExample,
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black26,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => addFriend(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: pinkPurpleGradient,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : addFriend,
                            icon: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              isLoading
                                  ? (replaceExistingFriend
                                      ? AppLocalizations.of(context)!.changing
                                      : AppLocalizations.of(context)!.adding)
                                  : (replaceExistingFriend
                                      ? AppLocalizations.of(context)!
                                          .changeFriend
                                      : AppLocalizations.of(context)!.addFriend),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                          ),
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
