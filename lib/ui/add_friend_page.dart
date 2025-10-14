import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../constants.dart';
import '../blocs/bloc/add_friend_bloc.dart';
import '../blocs/event/add_friend_event.dart';
import '../blocs/state/add_friend_state.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final controllerFriend = TextEditingController();

    void _addFriend() {
      final code = controllerFriend.text.trim();
      if (code.isNotEmpty) {
        context.read<AddFriendBloc>().add(AddFriendByCode(code));
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
                if (state is AddFriendSuccess || state is AddFriendFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state is AddFriendSuccess
                            ? state.message
                            : (state as AddFriendFailure).error,
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
                      title: const Text(
                        'Додати друга',
                        style: TextStyle(color: Colors.white),
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
                                tooltip: 'Скопіювати',
                                icon: const Icon(Icons.copy,
                                    color: Colors.white),
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: myFriendCode!));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Код скопійовано'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                tooltip: 'Поділитися',
                                icon: const Icon(Icons.share,
                                    color: Colors.white),
                                onPressed: () {
                                  Share.share(myFriendCode!);
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
                        decoration: const InputDecoration(
                          labelText: 'Введіть friend-код друга',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'Наприклад: ABC123',
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addFriend(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _addFriend,
                        icon: isLoading
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Icon(Icons.check_circle_outline),
                        label: Text(isLoading ? 'Додаємо…' : 'Додати друга'),
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
