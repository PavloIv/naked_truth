import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectDate {
  Future<String> selectYear(
      BuildContext context, TextEditingController dateController) async {
    final List<String>? pickedYear = await _showPicker(
      context: context,
      columns: 1,
      title: 'Select Year',
      items: [
        List.generate(51, (index) => (2000 + index).toString()),
      ],
    );

    if (pickedYear != null) {
      dateController.text = pickedYear.toString();
      return pickedYear[0].toString();
    }
    return '';
  }

  Future<String> selectYearAndMonth(
      BuildContext context, TextEditingController dateController) async {
    final List<String>? pickedData = await _showPicker(
      context: context,
      columns: 2,
      title: 'Select Year and Month',
      items: [
        List.generate(51, (index) => (2000 + index).toString()),
        List.generate(12, (index) => (index + 1).toString()),
      ],
    );

    if (pickedData != null) {
      final String year = pickedData[0];
      final String month = pickedData[1].padLeft(2, '0');
      dateController.text = '$year-$month';
      return '$year-$month';
    }
    return '';
  }

  Future<String> selectYearMonthAndDay(
      BuildContext context, TextEditingController dateController) async {
    final List<String>? pickedData = await _showPicker(
      context: context,
      columns: 3,
      title: 'Select Year, Month, and Day',
      items: [
        List.generate(51, (index) => (2000 + index).toString()),
        List.generate(12, (index) => (index + 1).toString()),
        List.generate(31, (index) => (index + 1).toString()),
      ],
    );

    if (pickedData != null) {
      final String year = pickedData[0];
      final String month = pickedData[1].padLeft(2, '0');
      final String day = pickedData[2].padLeft(2, '0');
      dateController.text = '$year-$month-$day';
      return '$year-$month-$day';
    }
    return '';
  }

  Future<List<String>?> _showPicker({
    required BuildContext context,
    required int columns,
    required String title,
    required List<List<String>> items,
  }) async {
    final List<int> selectedIndexes = List<int>.generate(columns, (index) => 0);

    return showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: 200,
            child: Row(
              children: List<Widget>.generate(columns, (index) {
                return Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedIndexes[index],
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (int value) {
                      selectedIndexes[index] = value;
                    },
                    children: items[index]
                        .map((item) => Center(child: Text(item)))
                        .toList(),
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  List<String>.generate(
                    columns,
                        (index) => items[index][selectedIndexes[index]],
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
