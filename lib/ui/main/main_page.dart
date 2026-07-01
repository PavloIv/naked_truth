import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naked_truth/ui/main/category_page.dart';

import '../../blocs/bloc/main_bloc.dart';
import '../../blocs/event/main_event.dart';
import '../../blocs/state/main_state.dart';
import '../../constants.dart';
import '../../database/nt_database.dart';
import '../../l10n/app_localizations.dart';
import '../../models/category_topic.dart';
import '../functional_widget/app_bar.dart';
import '../functional_widget/custom_tab_bar_with_label.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> _tabTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [l10n.adult, l10n.couples, l10n.friends];
  }

  List<String> get categoryKeys => ['дорослі', 'пари', 'друзі'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categoryKeys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabTitles = _tabTitles(context);
    return BlocProvider(
      create: (_) =>
          MainBloc(database: context.read<NTDatabase>())..add(LoadMain()),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoaded) {
            return _buildMain(state.topicsByCategory, tabTitles);
          }
          return Container(
            decoration: const BoxDecoration(
              gradient: appBackgroundGradient,
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMain(
    Map<String, List<CategoryTopic>> topicsByCategory,
    List<String> tabTitles,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: appBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const MainAppBar(),

        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(categoryKeys.length, (index) {
                  final key = categoryKeys[index];
                  final topics = topicsByCategory[key] ?? [];
                  return CategoryPage(
                    category: categoryKeys[index],
                    topics: topics,
                  );
                }),
              ),
            ),
            CustomTabBarWithLabels(
              tabController: _tabController,
              labels: tabTitles,
            ),
          ],
        ),
      ),
    );
  }
}
