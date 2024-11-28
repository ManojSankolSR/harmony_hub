import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Widgets/AppDialogs.dart';
import 'package:harmony_hub/Widgets/CustomSnackbar.dart';

class Userpreferredquality {
  static Future setUserpreferredquality({required AudioQuality quality}) async {
    if (Boxes.UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      user.audioQuality = quality.kbps;
      await user.save();
    }
  }

  static String getUserPereferedQualityLinkFomData(List<dynamic> data) {
    String link = data
        .firstWhere((e) => e["quality"] == getUserpreferredquality())["link"];

    return link;
  }

  static String getUserpreferredquality() {
    if (Boxes.UserBox.containsKey("user")) {
      UserModel user = Boxes.UserBox.get("user")!;
      return user.audioQuality;
    }
    return "320kbps";
  }

  static Future showQualitySelectDialog(
    BuildContext context, {
    bool isFromWlecomeScreen = false,
  }) async {
    final audioQualityList = AudioQuality.values
        .map(
          (e) => e.name,
        )
        .toList();
    // Userpreferredquality.getUserpreferredquality()
    final currentlySelectedItem = AudioQuality.values
        .firstWhere(
          (element) =>
              element.kbps == Userpreferredquality.getUserpreferredquality(),
        )
        .name;

    final String? result = await AppDialogs.showPickerDialog(
        pickerTitle: "Audio Quality",
        context: context,
        itemsList: audioQualityList,
        currentlySelecteditem: currentlySelectedItem);
    print(result);

    if (result != null) {
      if (isFromWlecomeScreen) {
        return result;
      }
      await setUserpreferredquality(
          quality: AudioQuality.values.firstWhere(
        (element) => element.name == result,
      ));

      Customsnackbar(
          title: "AudioQuality Updated",
          subTitle:
              "AudioQuality Changed to ${Userpreferredquality.getUserpreferredquality()}",
          context: context,
          type: ContentType.success);
    }

    // return showModalBottomSheet<dynamic>(
    //     isDismissible: true,
    //     useRootNavigator: true,
    //     enableDrag: true,
    //     backgroundColor: Colors.transparent,
    //     // shape: const RoundedRectangleBorder(
    //     //   borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    //     // ),
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //           margin: EdgeInsets.all(10),
    //           padding: EdgeInsets.all(10),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               color: Theme.of(context).colorScheme.surface),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Container(
    //                 height: 5,
    //                 width: 40,
    //                 margin: EdgeInsets.all(10),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(20),
    //                     color: Colors.grey),
    //               ),
    //               SizedBox(
    //                 height: 5,
    //               ),
    //               ...List.generate(
    //                 AudioQuality.values.length,
    //                 (index) {
    //                   bool isSelectedQuality =
    //                       Userpreferredquality.getUserpreferredquality() ==
    //                           AudioQuality.values[index].kbps;
    //                   return ListTile(
    //                     leading: Icon(Icons.high_quality),
    //                     onTap: () async {
    //                       if (isFromWlecomeScreen) {
    //                         Navigator.pop(
    //                             context, [AudioQuality.values[index].kbps]);
    //                         return;
    //                       }
    //                       await setUserpreferredquality(
    //                           quality: AudioQuality.values[index]);
    //                       Navigator.pop(context);
    //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                           backgroundColor: Colors.transparent,
    //                           elevation: 0,
    //                           content: AwesomeSnackbarContent(
    //                               color: Theme.of(context)
    //                                   .colorScheme
    //                                   .onPrimaryFixed,
    //                               title: " Audio Quality Changed",
    //                               message:
    // "AudioQuality Changed to ${Userpreferredquality.getUserpreferredquality()}",
    //                               contentType: ContentType.success)));
    //                     },
    //                     trailing: isSelectedQuality
    //                         ? Icon(Icons.verified_outlined)
    //                         : null,
    //                     title: Text(
    //                       AudioQuality.values[index].name.toUpperCase(),
    //                     ),
    //                   );
    //                 },
    //               )
    //               // ListView.builder(
    //               //   itemCount: AudioQuality.values.length,
    //               //   itemBuilder: (context, index) {
    //               //     bool isSelectedQuality =
    //               //         Userpreferredquality.getUserpreferredquality() ==
    //               //             AudioQuality.values[index].kbps;
    //               //     return ListTile(
    //               //       leading: Icon(Icons.high_quality),
    //               //       onTap: () async {
    //               //         if (isFromWlecomeScreen) {
    //               //           Navigator.pop(
    //               //               context, [AudioQuality.values[index].kbps]);
    //               //           return;
    //               //         }
    //               //         await setUserpreferredquality(
    //               //             quality: AudioQuality.values[index]);
    //               //         Navigator.pop(context);
    //               //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //               //             backgroundColor: Colors.transparent,
    //               //             elevation: 0,
    //               //             content: AwesomeSnackbarContent(
    //               //                 color: Theme.of(context)
    //               //                     .colorScheme
    //               //                     .onPrimaryFixed,
    //               //                 title: " Audio Quality Changed",
    //               //                 message:
    //               //                     "AudioQuality Changed to ${Userpreferredquality.getUserpreferredquality()}",
    //               //                 contentType: ContentType.success)));
    //               //       },
    //               //       trailing: isSelectedQuality
    //               //           ? Icon(Icons.verified_outlined)
    //               //           : null,
    //               //       title: Text(
    //               //         AudioQuality.values[index].name.toUpperCase(),
    //               //       ),
    //               //     );
    //               //   },
    //               // ),
    //             ],
    //           )
    //           //  CustomScrollView(
    //           //   physics: NeverScrollableScrollPhysics(),
    //           //   slivers: [
    //           //     SliverAppBar(
    //           //       pinned: true,
    //           //       scrolledUnderElevation: 0,
    //           //       elevation: 0,
    //           //       automaticallyImplyLeading: false,
    //           //       centerTitle: true,
    //           //       titleSpacing: 0,
    //           //       toolbarHeight: 30,
    //           //       primary: false,
    //           //       title: Container(
    //           //         height: 5,
    //           //         width: 40,
    //           //         decoration: BoxDecoration(
    //           //             borderRadius: BorderRadius.circular(20),
    //           //             color: Colors.grey),
    //           //       ),
    //           //     ),
    //           //     SliverList.builder(
    //           //       itemCount: AudioQuality.values.length,
    //           //       itemBuilder: (context, index) {
    //           //         bool isSelectedQuality =
    //           //             Userpreferredquality.getUserpreferredquality() ==
    //           //                 AudioQuality.values[index].kbps;
    //           //         return ListTile(
    //           //           leading: Icon(Icons.high_quality),
    //           //           onTap: () async {
    //           //             if (isFromWlecomeScreen) {
    //           //               Navigator.pop(
    //           //                   context, [AudioQuality.values[index].kbps]);
    //           //               return;
    //           //             }
    //           //             await setUserpreferredquality(
    //           //                 quality: AudioQuality.values[index]);
    //           //             Navigator.pop(context);
    //           //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //           //                 backgroundColor: Colors.transparent,
    //           //                 elevation: 0,
    //           //                 content: AwesomeSnackbarContent(
    //           //                     color: Theme.of(context)
    //           //                         .colorScheme
    //           //                         .onPrimaryFixed,
    //           //                     title: " Audio Quality Changed",
    //           //                     message:
    //           //                         "AudioQuality Changed to ${Userpreferredquality.getUserpreferredquality()}",
    //           //                     contentType: ContentType.success)));
    //           //           },
    //           //           trailing: isSelectedQuality
    //           //               ? Icon(Icons.verified_outlined)
    //           //               : null,
    //           //           title: Text(
    //           //             AudioQuality.values[index].name.toUpperCase(),
    //           //           ),
    //           //         );
    //           //       },
    //           //     ),
    //           //   ],
    //           // ),
    //           );
    //     });
  }
}
