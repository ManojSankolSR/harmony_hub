import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harmony_hub/Functions/SeedColor.dart';
import 'package:harmony_hub/Functions/ThemeModeHelper.dart';
import 'package:harmony_hub/Functions/UserPreferredQuality.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Functions/language.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/ThemeProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/AboutScreen.dart';
import 'package:harmony_hub/Screens/WelcomeScreen.dart';
import 'package:harmony_hub/Widgets/AppDialogs.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settingsscreen extends ConsumerStatefulWidget {
  const Settingsscreen({super.key});

  @override
  ConsumerState<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends ConsumerState<Settingsscreen> {
  Icon _themeModeRelatedIconDecider(ThemeMode thememode) {
    if (thememode == ThemeMode.light) {
      return Icon(Icons.brightness_5_rounded);
    } else if (thememode == ThemeMode.dark) {
      return Icon(Icons.brightness_2_sharp);
    } else {
      return Icon(Icons.phone_iphone_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _audioPlayer = ref.watch(globalPlayerProvider);

    final _themeMode = ref.watch(ThemeModeProvider);
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    // TODO: implement build
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          floating: true,
          leading: Icon(
            AntDesign.setting_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 23.sp,
          ),
          titleSpacing: 3,
          // actions: [
          //   SizedBox(
          //     height: 22.sp,
          //     width: 22.sp,
          //     child: Image.asset(
          //       "assets/splash.png",
          //     ),
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          // ],
          title: Row(
            children: [
              Text(
                "Sett",
                style: GoogleFonts.permanentMarker(
                    // color: Theme.of(context).colorScheme.primary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w100),
              ),
              Text(
                "ings ",
                style: GoogleFonts.permanentMarker(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),

        // SliverAppBar(
        //   stretch: true,
        //   flexibleSpace: FlexibleSpaceBar(
        //     centerTitle: true,
        //     stretchModes: [StretchMode.fadeTitle],
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       "Sett",
        //     ),
        //     Text("ings  ",
        //         style: TextStyle(
        //           color: Theme.of(context).colorScheme.primary,
        //         )),
        //     Icon(
        //       Icons.settings,
        //       color: Theme.of(context).colorScheme.primary,
        //     )
        //   ],
        // ),
        //   ),
        //   // expandedHeight: 130,
        //   centerTitle: true,
        //   // leading: Builder(
        //   //   builder: (context) {
        //   //     return IconButton(
        //   //       icon: Icon(Icons.horizontal_split_rounded),
        //   //       onPressed: () {
        //   //         Scaffold.of(context).openDrawer();
        //   //       },
        //   //     );
        //   //   },
        //   // ),
        //   pinned: true,
        // ),

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
                      ListTile(
                        onTap: () async {
                          ThemeModeHelper.themeModeSelectorDialog(
                              context: context, ref: ref);
                        },
                        leading: Icon(Icons.brightness_4_outlined),
                        trailing: _themeModeRelatedIconDecider(_themeMode),
                        title: Text("Theme"),
                        subtitle: Text(_themeMode.name),
                      ),
                      ListTile(
                        onTap: () async {
                          await Boxes.deleteUser(context: context);
                        },
                        leading: Icon(Icons.logout_outlined),
                        title: Text("Logout"),
                        subtitle: Text("Current user will be deleted"),
                      ),
                      ListTile(
                        onTap: () {
                          pushScreenWithoutNavBar(context, Aboutscreen());
                        },
                        leading: Image.asset(
                          "assets/splash.png",
                          height: 26,
                          color: isLightMode ? Colors.black : Colors.white,
                        ),
                        title: Text("About"),
                        subtitle: Text("App, Creator, Developer"),
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
