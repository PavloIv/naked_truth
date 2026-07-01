import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../blocs/bloc/add_friend_bloc.dart';
import '../blocs/event/add_friend_event.dart';
import '../blocs/state/add_friend_state.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../service/user_service.dart';

class AddFriendPage extends StatefulWidget {
  final bool replaceExistingFriend;

  const AddFriendPage({
    super.key,
    this.replaceExistingFriend = false,
  });

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  late final TextEditingController _controllerFriend;

  @override
  void initState() {
    super.initState();
    _controllerFriend = TextEditingController();
  }

  @override
  void dispose() {
    _controllerFriend.dispose();
    super.dispose();
  }

  void _addFriend() {
    final code = _controllerFriend.text.trim();
    if (code.isEmpty) return;

    context.read<AddFriendBloc>().add(
          AddFriendByCode(
            code,
            replaceExistingFriend: widget.replaceExistingFriend,
          ),
        );
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
            child: BlocConsumer<AddFriendBloc, AddFriendState>(
              listener: (context, state) {
                if (state is AddFriendSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  if (state.shouldClose) {
                    Navigator.of(context).pop(true);
                  }
                  return;
                }

                if (state is AddFriendFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                String? myFriendCode;
                FriendRequestInfo? incomingRequest;
                FriendRequestInfo? outgoingRequest;

                final isLoading = state is AddFriendLoading;

                if (state is AddFriendLoaded) {
                  myFriendCode = state.myFriendCode;
                  incomingRequest = state.incomingRequest;
                  outgoingRequest = state.outgoingRequest;
                }

                final hasPendingRequest =
                    incomingRequest != null || outgoingRequest != null;

                return Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: const BackButton(color: Colors.white),
                      title: Text(
                        widget.replaceExistingFriend
                            ? AppLocalizations.of(context)!.changeFriend
                            : AppLocalizations.of(context)!.addFriend,
                        style: const TextStyle(color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          children: [
                            if (myFriendCode != null && myFriendCode.isNotEmpty)
                              _MyCodeCard(myFriendCode: myFriendCode),
                            if (incomingRequest != null) ...[
                              const SizedBox(height: 18),
                              _IncomingRequestCard(
                                request: incomingRequest,
                                isLoading: isLoading,
                              ),
                            ],
                            if (outgoingRequest != null) ...[
                              const SizedBox(height: 18),
                              _OutgoingRequestCard(
                                request: outgoingRequest,
                                isLoading: isLoading,
                              ),
                            ],
                            const SizedBox(height: 24),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: hasPendingRequest ? 0.55 : 1,
                              child: IgnorePointer(
                                ignoring: hasPendingRequest || isLoading,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _controllerFriend,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .enterFriendCode,
                                        labelStyle: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                        hintText: AppLocalizations.of(context)!
                                            .friendCodeExample,
                                        hintStyle: const TextStyle(
                                          color: Colors.white54,
                                        ),
                                        filled: true,
                                        fillColor: Colors.black26,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _addFriend(),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: pinkPurpleGradient,
                                          borderRadius:
                                              BorderRadius.circular(26),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: isLoading ? null : _addFriend,
                                          icon: isLoading
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
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
                                                ? (widget.replaceExistingFriend
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .changing
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .adding)
                                                : (widget.replaceExistingFriend
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .sendFriendRequest
                                                    : AppLocalizations.of(
                                                            context)!
                                                        .sendFriendRequest),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (hasPendingRequest) ...[
                              const SizedBox(height: 14),
                              Text(
                                AppLocalizations.of(context)!
                                    .pendingRequestBlocksNewOne,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.45,
                                ),
                              ),
                            ],
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

class _MyCodeCard extends StatelessWidget {
  final String myFriendCode;

  const _MyCodeCard({
    required this.myFriendCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.key, color: Colors.white, size: 28),
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
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: myFriendCode));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.codeCopied,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.share,
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              SharePlus.instance.share(
                ShareParams(text: myFriendCode),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _IncomingRequestCard extends StatelessWidget {
  final FriendRequestInfo request;
  final bool isLoading;

  const _IncomingRequestCard({
    required this.request,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _RequestCard(
      icon: Icons.mark_email_unread_outlined,
      title: l10n.incomingFriendRequest,
      subtitle: l10n.friendRequestFrom(request.otherName ?? l10n.user),
      requestCode: request.otherCode,
      trailingNote: request.replaceExistingFriend
          ? l10n.friendWillReplaceCurrent
          : null,
      actions: [
        Expanded(
          child: _RequestActionButton(
            label: l10n.declineFriendRequest,
            gradient: settingTitleGradient,
            onPressed: isLoading
                ? null
                : () {
                    context
                        .read<AddFriendBloc>()
                        .add(DeclineIncomingFriendRequest());
                  },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RequestActionButton(
            label: l10n.acceptFriendRequest,
            gradient: pinkPurpleGradient,
            onPressed: isLoading
                ? null
                : () {
                    context
                        .read<AddFriendBloc>()
                        .add(AcceptIncomingFriendRequest());
                  },
          ),
        ),
      ],
    );
  }
}

class _OutgoingRequestCard extends StatelessWidget {
  final FriendRequestInfo request;
  final bool isLoading;

  const _OutgoingRequestCard({
    required this.request,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _RequestCard(
      icon: Icons.schedule_send_outlined,
      title: l10n.outgoingFriendRequest,
      subtitle: l10n.friendRequestTo(request.otherName ?? l10n.user),
      requestCode: request.otherCode,
      trailingNote: l10n.waitingForFriendConfirmation,
      actions: [
        SizedBox(
          width: double.infinity,
          child: _RequestActionButton(
            label: l10n.cancelFriendRequest,
            gradient: settingTitleGradient,
            onPressed: isLoading
                ? null
                : () {
                    context
                        .read<AddFriendBloc>()
                        .add(CancelOutgoingFriendRequest());
                  },
          ),
        ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? requestCode;
  final String? trailingNote;
  final List<Widget> actions;

  const _RequestCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actions,
    this.requestCode,
    this.trailingNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: settingTitleGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (requestCode != null && requestCode!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              '${AppLocalizations.of(context)!.friendCodeLabel}: $requestCode',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (trailingNote != null) ...[
            const SizedBox(height: 10),
            Text(
              trailingNote!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(children: actions),
        ],
      ),
    );
  }
}

class _RequestActionButton extends StatelessWidget {
  final String label;
  final Gradient gradient;
  final VoidCallback? onPressed;

  const _RequestActionButton({
    required this.label,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white60,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
