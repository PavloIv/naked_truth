import 'package:flutter/material.dart';

class RotatingLogo extends StatefulWidget {
  final double size;
  final int rotations;
  final Duration duration;

  const RotatingLogo({
    super.key,
    required this.size,
    required this.rotations,
    required this.duration,
  });

  @override
  State<RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<RotatingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.size * 32 / 164);

    return RotationTransition(
      turns: Tween(begin: 0.0, end: widget.rotations.toDouble())
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          'assets/icon/app_icon.png',
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}
