import 'dart:async';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../functional_widget/rotating_logo.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();

    _startTransition();
  }

  Future<void> _startTransition() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: appBackgroundGradient,
        ),
        child: Center(
          child: RotatingLogo(
            size: 164,
            rotations: 3,
            duration: Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}
