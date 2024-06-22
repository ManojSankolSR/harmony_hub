import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/AppPermissions.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/ThemeProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/HomeScreen.dart';
import 'package:harmony_hub/Screens/SongPlayScreen.dart';
import 'package:harmony_hub/Screens/WelcomeScreen.dart';
import 'package:harmony_hub/Widgets/ArtWorkWidget.dart';
import 'package:harmony_hub/Widgets/MiniAudioPlayer.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
// import 'package:metadata_god/metadata_god_web.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Boxes.InitilizeBoxes();
  AppPermissions.requestStoragePermissions();
  FlutterNativeSplash.remove();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeMode = ref.watch<ThemeMode>(ThemeModeProvider);
    final _brightness =
        _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    final Color _seedColor = ref.watch(seedColorProvider);
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        themeMode: _themeMode,
        // builder: (context, child) => Stack(
        //       children: [child!, Miniaudioplayer()],
        //     ),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          physics: BouncingScrollPhysics(),
        ),
        theme: ThemeData.light(useMaterial3: true).copyWith(
          brightness: Brightness.light,

          colorScheme: ColorScheme.fromSeed(
              onPrimary: ColorScheme.fromSeed(
                      seedColor: _seedColor, brightness: Brightness.light)
                  .primaryContainer,
              seedColor: _seedColor,
              brightness: Brightness.light),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeInOutTransition(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          listTileTheme: ListTileThemeData().copyWith(
              textColor: Colors.black,
              iconColor: Colors.black,
              contentPadding: EdgeInsets.only(left: 10, right: 5),
              titleTextStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              subtitleTextStyle: TextStyle(fontWeight: FontWeight.w300)),
          scaffoldBackgroundColor: ColorScheme.fromSeed(
                  seedColor: _seedColor, brightness: Brightness.light)
              .surface,
          // appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
                seedColor: _seedColor, brightness: Brightness.dark),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: FadeInOutTransition(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
            iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: Colors.white)),
            listTileTheme: ListTileThemeData().copyWith(
                contentPadding: EdgeInsets.only(left: 10, right: 5),
                textColor: Colors.white,
                iconColor: Colors.white,
                titleTextStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                subtitleTextStyle: TextStyle(fontWeight: FontWeight.w300)),
            iconTheme: IconThemeData().copyWith(color: Colors.white),
            scaffoldBackgroundColor: ColorScheme.fromSeed(
                    seedColor: _seedColor, brightness: Brightness.dark)
                .surface,
            // appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
            textTheme: TextTheme().copyWith()),
        home:
            Boxes.UserBox.containsKey("user") ? Homescreen() : Welcomescreen());
  }
}
