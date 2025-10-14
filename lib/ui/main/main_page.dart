import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naked_truth/ui/main/category_page.dart';

import '../../blocs/bloc/main_bloc.dart';
import '../../blocs/event/main_event.dart';
import '../../blocs/state/main_state.dart';
import '../../constants.dart';
import '../../database/nt_database.dart';
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

  final Map<String, String> categoriesTitle = {
    'adult': 'Adult',
    'couples': 'Couples',
    'friends': 'Friends',
  };

  List<String> get tabTitles => categoriesTitle.values.toList();

  List<String> get categoryKeys => categoriesTitle.keys.toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MainBloc(database: context.read<NTDatabase>())..add(LoadMain()),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainLoaded) {
            return _buildMain(state.topicsByCategory,state.isSubscription);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMain(Map<String, List<CategoryTopic>> topicsByCategory,bool isSubscription) {
    return Container(
      decoration: const BoxDecoration(
        gradient: appBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: MainAppBar(isSubscription: isSubscription),

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
                    isSubscription: isSubscription
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
