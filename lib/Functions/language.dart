import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Widgets/AppDialogs.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';

class UserPeferedLanguage {
  static String getUserPreferedlanguage() {
    if (Boxes.UserBox.containsKey('user')) {
      String langauage = Boxes.UserBox.get("user")!.perfferdLanguage;

      return langauage;
    }
    return "kannada";
  }

  static Future setUserPreferedlanguage(String langauage) async {
    if (Boxes.UserBox.containsKey('user')) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.perfferdLanguage = langauage;
      await user.save();
    }
  }

  static Future<String?> showLanguageSelectDialog(
    BuildContext context,
    WidgetRef ref, {
    bool isFromWlecomeScreen = false,
  }) async {
    final languagesList = Language.values
        .map(
          (e) => e.name,
        )
        .toList();

    final String? result = await AppDialogs.showPickerDialog(
        pickerTitle: "Language",
        context: context,
        itemsList: languagesList,
        currentlySelecteditem: getUserPreferedlanguage());
    print(result);
    if (result != null) {
      if (isFromWlecomeScreen) {
        return result;
      }
      await setUserPreferedlanguage(result);
      ref.invalidate(HomeScreenDataProvider);

      Customsnackbar(
          title: "Content Updated",
          subTitle:
              "Langauge Changed to ${UserPeferedLanguage.getUserPreferedlanguage()}",
          context: context,
          type: ContentType.success);
    }
    return null;
    // return showModalBottomSheet(
    //     context: context,
    //     // isScrollControlled: true,
    //     useRootNavigator: true,
    //     constraints: BoxConstraints(maxHeight: 300),
    //     builder: (context) {
    //       return Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 Opacity(
    //                     opacity: 0,
    //                     child:
    //                         TextButton(onPressed: () {}, child: Text("Save"))),
    //                 Text(
    //                   "Language",
    //                   style: Theme.of(context).textTheme.titleLarge,
    //                 ),
    //                 CupertinoButton(onPressed: () {}, child: Text("Save"))
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             child: CupertinoPicker.builder(
    //               magnification: 1.2,
    //               useMagnifier: true,
    //               squeeze: 1.1,
    //               itemExtent: 30,
    //               scrollController: FixedExtentScrollController(
    //                 initialItem: Language.values.indexWhere(
    //                   (element) => element.name == getUserPreferedlanguage(),
    //                 ),
    //               ),
    //               childCount: Language.values.length,
    //               onSelectedItemChanged: (value) {
    //                 print(value);
    //               },
    //               itemBuilder: (context, index) {
    //                 return Center(
    //                     child: Text(Language.values[index].name.toUpperCase()));
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //     });

    // showModalBottomSheet<dynamic>(
    //     isScrollControlled: true,
    //     isDismissible: true,
    //     useRootNavigator: true,
    //     backgroundColor: Colors.transparent,
    //     // shape: const RoundedRectangleBorder(
    //     //   borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    //     // ),
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //         margin: EdgeInsets.all(10),
    //         padding: EdgeInsets.all(10),
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10),
    //             color: Theme.of(context).colorScheme.surface),
    //         child: DraggableScrollableSheet(
    //           initialChildSize: 0.4,
    //           minChildSize: 0.2,
    //           maxChildSize: 0.4,
    //           expand: false,
    //           snap: true,
    //           builder: (context, scrollController) {
    //             return CustomScrollView(
    //               physics: ScrollPhysics(),
    //               controller: scrollController,
    //               slivers: [
    //                 SliverAppBar(
    //                   pinned: true,
    //                   scrolledUnderElevation: 0,
    //                   elevation: 0,
    //                   shadowColor: Colors.transparent,
    //                   backgroundColor: Theme.of(context).colorScheme.surface,
    //                   automaticallyImplyLeading: false,
    //                   centerTitle: true,
    //                   titleSpacing: 0,
    //                   toolbarHeight: 30,
    //                   primary: false,
    //                   title: Container(
    //                     height: 5,
    //                     width: 40,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(20),
    //                         color: Colors.grey),
    //                   ),
    //                 ),
    //                 SliverList.builder(
    //                   itemCount: Language.values.length,
    //                   itemBuilder: (context, index) {
    //                     bool isSelectedLanguage =
    //                         UserPeferedLanguage.getUserPreferedlanguage() ==
    //                             Language.values[index].name;
    //                     return Material(
    //                       color: Colors.transparent,
    //                       child: ListTile(
    //                         leading: Icon(Icons.language_outlined),
    //                         trailing: isSelectedLanguage
    //                             ? Icon(Icons.verified_outlined)
    //                             : null,
    //                         onTap: () async {
    //                           if (isFromWlecomeScreen) {
    //                             Navigator.pop(
    //                                 context, [Language.values[index].name]);
    //                             return;
    //                           }
    //                           await setUserPreferedlanguage(
    //                               Language.values[index].name);
    //                           ref.invalidate(HomeScreenDataProvider);
    //                           Navigator.pop(context);
    //                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                               backgroundColor: Colors.transparent,
    //                               elevation: 0,
    //                               content: AwesomeSnackbarContent(
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onPrimaryFixed,
    // title: "Content Updated",
    // message:
    //     "Langauge Changed to ${UserPeferedLanguage.getUserPreferedlanguage()}",
    //                                   contentType: ContentType.success)));
    //                         },
    //                         title:
    //                             Text(Language.values[index].name.toUpperCase()),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ],
    //             );
    //           },
    //         ),
    //       );

    //       // showDragHandle: true,
    //       // constraints: BoxConstraints(
    //       //   maxWidth: MediaQuery.of(context).size.width - 30,
    //       // ),
    //       // context: context,
    //       // builder: (BuildContext context) {
    //       //   return Container(
    //       //     height: 400,
    //       //     padding: EdgeInsets.all(20),
    //       //     child: ListView.builder(
    //       //       itemCount: Language.values.length,
    //       //       itemBuilder: (context, index) {
    //       //         return ListTile(
    //       //           leading: Icon(Icons.language_outlined),
    //       //           onTap: () async {
    //       //             if (isFromWlecomeScreen) {
    //       //               Navigator.pop(context, [Language.values[index].name]);
    //       //               return;
    //       //             }
    //       //             await setUserPreferedlanguage(Language.values[index].name);
    //       //             ref.invalidate(HomeScreenDataProvider);
    //       //             Navigator.pop(context);
    //       //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //                 backgroundColor: Colors.transparent,
    //       //                 elevation: 0,
    //       //                 content: AwesomeSnackbarContent(
    //       //                     color: Theme.of(context).colorScheme.onPrimaryFixed,
    //       //                     title: "Content Updated",
    //       //                     message:
    //       //                         "Langauge Changed to ${UserPeferedLanguage.getUserPreferedlanguage()}",
    //       //                     contentType: ContentType.success)));
    //       //           },
    //       //           title: Text(Language.values[index].name.toUpperCase()),
    //       //         );
    //       //       },
    //       //     ),
    //       //   );
    //       // }
    //     });
  }
}
