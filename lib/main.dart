import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:naked_truth/service/questions_importer.dart';
import 'package:naked_truth/ui/auth_gate.dart';
import 'package:naked_truth/ui/main/main_page.dart';
import 'package:naked_truth/utils/app_globals.dart';
import 'package:naked_truth/utils/database_provider.dart';
import 'package:naked_truth/utils/language_change_controller.dart';
import 'package:provider/provider.dart';

import 'database/nt_database.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  final dbProvider = DatabaseProvider();
  await dbProvider.init();
  final database = dbProvider.database;


  await QuestionImporter.importIfNeeded(database);
  runApp(MustHaveTalksApp(
    database: database,
    navigatorKey: AppGlobals.navigatorKey,
    locale: 'uk',
  ));
}

class MustHaveTalksApp extends StatelessWidget {
  final NTDatabase database;
  final GlobalKey<NavigatorState> navigatorKey;
  final String? locale;

  const MustHaveTalksApp({
    super.key,
    required this.database,
    required this.navigatorKey,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    String selectedLocale = locale ?? 'uk';

    return MultiProvider(
      providers: [
        Provider<NTDatabase>.value(value: database),
        ChangeNotifierProvider(
          create: (_) => LanguageChangeController(Locale(selectedLocale)),
        ),
      ],
      child: Consumer<LanguageChangeController>(
        builder: (context, provider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: provider.appLocale,
            supportedLocales: const [Locale('en'), Locale('uk')],
            initialRoute: '/',
            routes: _buildAppRoutes(),
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/': (context) => const AuthGate(),
      '/main': (context) => const MainPage(),
    };
  }
}
