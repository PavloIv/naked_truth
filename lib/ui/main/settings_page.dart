import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:naked_truth/l10n/app_localizations.dart';
import 'package:naked_truth/service/auth_service.dart';
import 'package:naked_truth/ui/apply_premium_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/bloc/add_friend_bloc.dart';
import '../../blocs/bloc/apply_premium_bloc.dart';
import '../../blocs/bloc/setting_bloc.dart';
import '../../blocs/event/add_friend_event.dart';
import '../../blocs/event/setting_event.dart';
import '../../blocs/state/setting_state.dart';
import '../../constants.dart';
import '../../service/friend_code_service.dart';
import '../../service/location_service.dart';
import '../../service/user_service.dart';
import '../add_friend_page.dart';
import '../friend_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(LoadSettings()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            decoration: const BoxDecoration(gradient: appBackgroundGradient),
          ),
          SafeArea(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                if (state is SettingsLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: const BackButton(color: Colors.white),
                          title: Text(
                            l10n.settings,
                            style: const TextStyle(color: Colors.white),
                          ),
                          centerTitle: true,
                        ),
                        const SizedBox(height: 24),
                        if (!state.isPremium!)
                          _sectionTitle(l10n.settings),
                        if (!state.isPremium!)
                          _settingsTile(
                              'assets/icon/settings/crown.png', l10n.getPremium,
                              () {
                            Navigator.of(context).pushNamed('/subscription');
                          }),
                        if (!state.isPremium!)
                          _settingsTile('assets/icon/settings/restore.png',
                              l10n.restorePurchase, () async {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.purchaseRestored)),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(l10n.purchaseRestoreFailed)),
                              );
                            }
                          }),
                        _sectionTitle(l10n.friends),
                        _settingsTile(
                            'assets/icon/add_friend.png', l10n.addFriend, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => AddFriendBloc(
                                  userService: UserService(),
                                  auth: FirebaseAuth.instance,
                                )..add(LoadMyFriendCode()),
                                child: const AddFriendPage(),
                              ),
                            ),
                          );
                        }),
                        if (state.friendUid != null)
                          _settingsTile(
                              'assets/icon/friends.png', l10n.myFriend,
                              () async {
                            final s = state;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MyFriendPage(
                                  friendUid: s.friendUid!,
                                  friendName: s.friendName ?? 'Friend',
                                  friendCode: s.friendCode ?? '',
                                ),
                              ),
                            );
                          }),
                        if (state.friendUid != null)
                          _settingsTile(
                              'assets/icon/friends.png', l10n.usePremiumCode,
                              () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => ApplyPremiumBloc(
                                        service: FriendCodeService(),
                                        auth: FirebaseAuth.instance,
                                      ),
                                      child: ApplyPremiumPage(
                                        myPremiumCode: state.myFriendPremiumCode,
                                        havePremium: state.isPremium,
                                        premiumTo: state.premiumTo,
                                      ),
                                    ),
                                  ),
                                );
                          }),
                        const SizedBox(height: 24),
                        _sectionTitle(l10n.other),
                        _settingsTile(
                            'assets/icon/settings/rate.png', l10n.rateThisApp,
                            () async {
                          final inAppReview = InAppReview.instance;
                          if (await inAppReview.isAvailable()) {
                            await inAppReview.requestReview();
                          } else {
                            await inAppReview.openStoreListing();
                          }
                        }),
                        _settingsTile('assets/icon/settings/terms.png',
                            l10n.termsAndConditions, () {
                          _launchUrl(
                            Platform.isIOS
                                ? 'https://www.apple.com/legal/internet-services/terms/site.html'
                                : 'https://docs.google.com/document/d/13M8c7gOeY4LNjowFYbYR10o7FkNr5Am9nbgPFGb0D3c/edit?usp=sharing',
                          );
                        }),
                        _settingsTile('assets/icon/settings/privace.png',
                            l10n.privacyPolicy, () {
                          _launchUrl(
                            'https://docs.google.com/document/d/1yUzN-fx8M_pPYyq8X6brdIOI_yD_c28Uv5G7RzmlQOk/edit?usp=sharing',
                          );
                        }),
                        _settingsTile(
                            'assets/icon/settings/privace.png', 'LogOut',
                            () async {
                          await AuthService().signOut();
                          LocationService().stop();
                          SystemNavigator.pop();
                        }),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _settingsTile(String assetPath, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: settingTitleGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading:
            Image.asset(assetPath, color: Colors.white, width: 20, height: 20),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        trailing:
            Image.asset('assets/icon/arrow_forward.png', width: 12, height: 12),
        onTap: onTap,
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch: $urlString';
    }
  }
}
