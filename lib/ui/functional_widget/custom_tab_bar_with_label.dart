import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomTabBarWithLabels extends StatefulWidget {
  final TabController tabController;
  final List<String> labels;

  const CustomTabBarWithLabels({
    super.key,
    required this.tabController,
    required this.labels,
  });

  @override
  State<CustomTabBarWithLabels> createState() => _CustomTabBarWithLabelsState();
}

class _CustomTabBarWithLabelsState extends State<CustomTabBarWithLabels> {
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    widget.tabController.animation?.addListener(_handleAnimation);
  }

  void _handleAnimation() {
    setState(() {
      _animationValue = widget.tabController.animation!.value;
    });
  }

  @override
  void dispose() {
    widget.tabController.animation?.removeListener(_handleAnimation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _animationValue.round();

    return Container(
      height: 72,
      width: double.infinity,
      color: tabBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.labels.length, (index) {
          final isSelected = currentIndex == index;
          final iconAsset = _getIconAsset(index);

          return GestureDetector(
            onTap: () {
              final roundedIndex = _animationValue.round();
              if (index != roundedIndex) {
                widget.tabController.animateTo(index);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconAsset,
                  width: 24,
                  height: 24,
                  color: isSelected ? pinkMain : Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? pinkMain : Colors.white,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getIconAsset(int index) {
    switch (index) {
      case 0:
        return 'assets/icon/adult.png';
      case 1:
        return 'assets/icon/couples.png';
      case 2:
        return 'assets/icon/friends.png';
      default:
        return 'assets/icon/adult.png';
    }
  }
}
