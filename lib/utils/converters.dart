import 'package:flutter/material.dart';

import '../constants.dart';

class Converters{
  LinearGradient getGradientByTopic(String topicName) {
    return cardGradientsMap[topicName] ??
        const LinearGradient(
          colors: [Colors.grey, Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
  }

  String getDescriptionByTopic(String topicName) {
    return cardDescriptionMap[topicName] ??
        '';
  }
}