import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/SeedColor.dart';
import 'package:harmony_hub/Functions/UserPreferredQuality.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Functions/language.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:hive_flutter/adapters.dart';

class Settingsscreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends ConsumerState<Settingsscreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          title: Row(
            children: [
              Text(
                "Sett",
              ),
              Text("ings",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ))
            ],
          ),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.horizontal_split_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ValueListenableBuilder(
                valueListenable: Boxes.UserBox.listenable(),
                builder: (context, value, child) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          UserPeferedLanguage.showLanguageSelectDialog(
                              context, ref);
                        },
                        leading: Icon(Icons.language),
                        title: Text("Language"),
                        subtitle: Text(
                            UserPeferedLanguage.getUserPreferedlanguage()
                                .toUpperCase()),
                      ),
                      ListTile(
                        onTap: () {
                          Userpreferredquality.showQualitySelectDialog(context);
                          // _showModalBottomSheetCustom(true, context);
                        },
                        leading: Icon(Icons.high_quality_outlined),
                        title: Text("Audio Quality"),
                        subtitle: Text(
                            Userpreferredquality.getUserpreferredquality()),
                      ),
                      ListTile(
                        onTap: () {
                          SeedColor.showseedColorSelectorSheet(context, ref);
                        },
                        leading: Icon(Icons.color_lens_outlined),
                        title: Text("Aceent Color"),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: SeedColor.getSeedColor(),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        subtitle: Text("Color Will Be Applied Globally"),
                      ),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}

// class ColorsSelectorScreen extends ConsumerWidget {
//   final List<Color> _colors = [
//     Colors.red,
//     Colors.redAccent,
//     Colors.pink,
//     Colors.pinkAccent,
//     Colors.purple,
//     Colors.purpleAccent,
//     Colors.deepPurple,
//     Colors.deepPurpleAccent,
//     Colors.indigo,
//     Colors.indigoAccent,
//     Colors.blue,
//     Colors.blueAccent,
//     Colors.lightBlue,
//     Colors.lightBlueAccent,
//     Colors.cyan,
//     Colors.cyanAccent,
//     Colors.teal,
//     Colors.tealAccent,
//     Colors.green,
//     Colors.greenAccent,
//     Colors.lightGreen,
//     Colors.lightGreenAccent,
//     Colors.lime,
//     Colors.limeAccent,
//     Colors.yellow,
//     Colors.yellowAccent,
//     Colors.amber,
//     Colors.amberAccent,
//     Colors.orange,
//     Colors.orangeAccent,
//     Colors.deepOrange,
//     Colors.deepOrangeAccent,
//     Colors.brown,
//     Colors.grey,
//     Colors.blueGrey
//   ];

//   void changeSeedColor(WidgetRef ref, Color color) {
//     ref.read(seedColorProvider.notifier).updateColor(color);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // TODO: implement build
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar.medium(

//               // centerTitle: true,
//               pinned: true,
//               title: Row(
//                 children: [
//                   Text(
//                     "Col",
//                   ),
//                   Text("ors",
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                       ))
//                 ],
//               )),
//           SliverGrid.builder(
//               gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//               itemCount: _colors.length,
//               itemBuilder: (context, index) => InkWell(
//                     onTap: () {
//                       changeSeedColor(ref, _colors[index]);
//                     },
//                     child: Stack(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                               color: _colors[index],
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         if (ref.read(seedColorProvider.notifier).loadColor() ==
//                             _colors[index])
//                           Positioned(
//                               top: 1,
//                               left: 1,
//                               child: Icon(
//                                 Icons.verified,
//                                 size: 30,
//                               ))
//                       ],
//                     ),
//                   ))
//         ],
//       ),
//     );
//   }
// }
