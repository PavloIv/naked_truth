
import 'package:flutter/material.dart';

class HighlightText{
  Widget highlightText(
      String text,
      String searchText, {
        TextStyle? defaultStyle,
        TextStyle? highlightStyle,
        int? maxLines,
        TextOverflow? overflow,
      }) {
    if (searchText.isEmpty ||
        !text.toLowerCase().contains(searchText.toLowerCase())) {
      return Text(
        text,
        style: defaultStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    } else {
      List<TextSpan> spans = [];
      int start = 0;
      int index;
      while ((index =
          text.toLowerCase().indexOf(searchText.toLowerCase(), start)) != -1) {
        if (index > start) {
          spans.add(TextSpan(text: text.substring(start, index)));
        }
        spans.add(TextSpan(
          text: text.substring(index, index + searchText.length),
          style: const TextStyle(backgroundColor: Colors.yellow),
        ));
        start = index + searchText.length;
      }
      spans.add(TextSpan(text: text.substring(start)));

      return RichText(
        text: TextSpan(
          style: defaultStyle,
          children: spans,
        ),
      );
    }
  }
}

