import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';

class SeedColor {
  static final List<Color> _colors = [
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey
  ];
  static Color getSeedColor() {
    if (Boxes.UserBox.containsKey('user')) {
      Color data = Boxes.UserBox.get("user")!.seedColor;
      return data;
    }
    return const Color.fromARGB(255, 74, 0, 87);
  }

  static Future updateSeedColor(Color seedcolor) async {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.seedColor = seedcolor;
      await user.save();
    }
  }

  static void showseedColorSelectorSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      useRootNavigator: true,
      context: context,
      builder: (context) => CustomScrollView(
        slivers: [
          // SliverAppBar.medium(

          //     // centerTitle: true,
          //     pinned: true,
          //     title: Row(
          //       children: [
          //         Text(
          //           "Col",
          //         ),
          //         Text("ors",
          //             style: TextStyle(
          //               color: Theme.of(context).colorScheme.primary,
          //             ))
          //       ],
          //     )),
          SliverGrid.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: _colors.length,
              itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      ref
                          .read(seedColorProvider.notifier)
                          .updateColor(_colors[index]);
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: _colors[index],
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        if (ref.read(seedColorProvider.notifier).loadColor() ==
                            _colors[index])
                          const Positioned(
                              top: 1,
                              left: 1,
                              child: Icon(
                                Icons.verified,
                                size: 30,
                              ))
                      ],
                    ),
                  ))
        ],
      ),
    );
  }
}
