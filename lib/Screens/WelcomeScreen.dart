import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/UserPreferredQuality.dart';
import 'package:harmony_hub/Functions/language.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Screens/HomeScreen.dart';
import 'package:harmony_hub/Widgets/CustomButton.dart';

class Welcomescreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends ConsumerState<Welcomescreen> {
  String _audioQuality = "360kbps";
  String _language = "kannada";
  late TextEditingController _textEditingController;

  // _showModalBottomSheetCustom(bool isQualitySelect, BuildContext context) {
  //   showModalBottomSheet<void>(
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //             child: Container(
  //           height: 400,
  //           padding: EdgeInsets.all(20),
  //           child: ListView.builder(
  //             itemCount: isQualitySelect
  //                 ? AudioQuality.values.length
  //                 : Language.values.length,
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 onTap: () {
  //                   setState(() {
  //                     if (isQualitySelect) {
  //                       _audioQuality = AudioQuality.values[index].kbps;
  //                     } else {
  //                       _language = Language.values[index].name;
  //                     }
  //                     Navigator.pop(context);
  //                   });
  //                 },
  //                 title: Text(isQualitySelect
  //                     ? AudioQuality.values[index].kbps
  //                     : Language.values[index].name),
  //               );
  //             },
  //           ),
  //         ));
  //       });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Theme.of(context).colorScheme.onPrimaryFixed,
              Colors.transparent,
            ])),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Icon(
              //     Icons.my_library_music_outlined,
              //     size: 100,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              // ),
              SizedBox(
                height: 15,
              ),
              Text("Harmony",
                  style: TextStyle(
                      height: 1,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary)),
              Text("Hub",
                  style: TextStyle(
                      height: 1,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary)),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          height: 1, fontSize: 70, fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                      text: "Music",
                    ),
                    TextSpan(
                      text: ".",
                    )
                  ])),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text("Unlimited Song Downloads")),
                  Chip(label: Text("High-Quality Streaming")),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(label: Text("Many More")),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                // height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 54, 54, 54)),
                child: Row(
                  children: [
                    Icon(Icons.account_circle_outlined),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        // cursorHeight: 30,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Your Name",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  ActionChip(
                    avatar: Icon(Icons.arrow_drop_down),
                    label: Text(_language),
                    onPressed: () async {
                      final data =
                          await UserPeferedLanguage.showLanguageSelectDialog(
                              context, ref,
                              isFromWlecomeScreen: true);
                      ;
                      setState(() {
                        _language = data[0];
                      });

                      // _showModalBottomSheetCustom(false, context);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ActionChip(
                      avatar: Icon(Icons.arrow_drop_down),
                      onPressed: () async {
                        final data =
                            await Userpreferredquality.showQualitySelectDialog(
                                context,
                                isFromWlecomeScreen: true);
                        setState(() {
                          _audioQuality = data[0];
                        });

                        // _showModalBottomSheetCustom(true, context);
                      },
                      label: Text(_audioQuality)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_textEditingController.text != "") {
                    await Boxes.createUser(
                        _textEditingController.text, _language, _audioQuality);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homescreen(),
                        ));
                  }
                },
                child: Text(
                  "Get Started",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Disclaimer: We Respect your privacy more than anything else, All your details will be Stored locally on your Device ",
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
