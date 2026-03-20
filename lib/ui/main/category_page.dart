import 'package:flutter/material.dart';
import '../../models/category_topic.dart';
import '../../utils/converters.dart';
import '../qustions/qustions_page.dart';

class CategoryPage extends StatelessWidget {
  final List<CategoryTopic> topics;
  final String category;
  final bool isSubscription;

  const CategoryPage({
    super.key,
    required this.topics,
    required this.category,
    required this.isSubscription
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: topics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final t = topics[index];
        final gradient = Converters().getGradientByTopic('Default');

        return GestureDetector(
          onTap: () async {
            // if (!t.isFree) {
            //   if (isSubscription) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuestionsPage(
                      category: category,
                      topic: t.topic,
                    ),
                  ),
                );
              // }
              // else {
              //   Navigator.of(context).pushNamed('/subscription');
              // }
            // } else {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (_) => QuestionsPage(
            //         category: category,
            //         topic: t.topic,
            //       ),
            //     ),
            //   );
            // }
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 30,),
                          Text(
                            t.topic,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontFamily: 'Bitter',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30,),
                          Text(
                            Converters().getDescriptionByTopic(t.topic),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
