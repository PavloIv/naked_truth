import 'package:flutter/material.dart';
import '../../models/category_topic.dart';
import '../../utils/converters.dart';
import '../qustions/qustions_page.dart';

class CategoryPage extends StatelessWidget {
  static const _pagePadding = EdgeInsets.all(16);
  static const _cardPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 18);
  static const _titleStyle = TextStyle(
    fontSize: 17,
    fontFamily: 'Bitter',
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );
  static const _descriptionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.35,
  );

  final List<CategoryTopic> topics;
  final String category;

  const CategoryPage({
    super.key,
    required this.topics,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: _pagePadding,
      itemCount: topics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final t = topics[index];
        final gradient = Converters().getGradientByTopic('Default');

        return GestureDetector(
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuestionsPage(
                  category: category,
                  topic: t.topic,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                padding: _cardPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 18),
                          Text(
                            t.topic,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            Converters().getDescriptionByTopic(t.topic),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _descriptionStyle,
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
