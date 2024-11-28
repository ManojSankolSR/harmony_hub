import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  static Future<String?> showPickerDialog(
      {required String pickerTitle,
      required List<String> itemsList,
      required BuildContext context,
      required String currentlySelecteditem}) {
    return showModalBottomSheet<String>(
        context: context,
        // isScrollControlled: true,
        useRootNavigator: true,
        constraints: const BoxConstraints(maxHeight: 280),
        builder: (context) {
          String selectedItem = currentlySelecteditem;
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Opacity(
                          opacity: 0,
                          child: TextButton(
                              onPressed: () {}, child: const Text("Save"))),
                      Text(
                        pickerTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      CupertinoButton(
                          onPressed: () {
                            Navigator.pop(context, selectedItem);
                          },
                          child: const Text("Save"))
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker.builder(
                    magnification: 1.2,
                    useMagnifier: true,
                    squeeze: .9,
                    itemExtent: 30,
                    scrollController: FixedExtentScrollController(
                      initialItem: itemsList.indexWhere(
                        (element) => element == selectedItem,
                      ),
                    ),
                    childCount: itemsList.length,
                    onSelectedItemChanged: (value) {
                      setState(
                        () {
                          selectedItem = itemsList[value];
                        },
                      );
                    },
                    itemBuilder: (context, index) {
                      return Center(
                          child: Text(
                              itemsList[index].characters.first.toUpperCase() +
                                  itemsList[index].substring(1)));
                    },
                  ),
                ),
              ],
            );
          });
        });
  }
}
