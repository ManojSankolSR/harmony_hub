import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Functions/AppPermissions.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/ThemeProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/HomeScreen.dart';
import 'package:harmony_hub/Screens/WelcomeScreen.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'package:metadata_god/metadata_god_web.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await JustAudioBackground.init(
    androidNotificationIcon: 'drawable/ic_notification',
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
    final themeMode = ref.watch<ThemeMode>(ThemeModeProvider);
    final brightness =
        themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
    final Color seedColor = ref.watch(seedColorProvider);
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        themeMode: themeMode,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        theme: ThemeData.light(useMaterial3: true).copyWith(
          brightness: Brightness.light,

          colorScheme: ColorScheme.fromSeed(
              onPrimary: ColorScheme.fromSeed(
                      seedColor: seedColor, brightness: Brightness.light)
                  .primaryContainer,
              seedColor: seedColor,
              brightness: Brightness.light),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeInOutTransition(),
            TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          }),
          iconTheme: const IconThemeData().copyWith(color: Colors.black),
          iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(foregroundColor: Colors.black)),
          listTileTheme: const ListTileThemeData().copyWith(
              textColor: Colors.black,
              iconColor: Colors.black,
              contentPadding: const EdgeInsets.only(left: 10, right: 5),
              titleTextStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              subtitleTextStyle: const TextStyle(fontWeight: FontWeight.w300)),
          scaffoldBackgroundColor: ColorScheme.fromSeed(
                  seedColor: seedColor, brightness: Brightness.light)
              .surface,
          // appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
        ),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
                seedColor: seedColor, brightness: Brightness.dark),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: FadeInOutTransition(),
              TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
            }),
            iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: Colors.white)),
            listTileTheme: const ListTileThemeData().copyWith(
                contentPadding: const EdgeInsets.only(left: 10, right: 5),
                textColor: Colors.white,
                iconColor: Colors.white,
                titleTextStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                subtitleTextStyle:
                    const TextStyle(fontWeight: FontWeight.w300)),
            iconTheme: const IconThemeData().copyWith(color: Colors.white),
            scaffoldBackgroundColor: ColorScheme.fromSeed(
                    seedColor: seedColor, brightness: Brightness.dark)
                .surface,
            // appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
            textTheme: const TextTheme().copyWith()),
        home: Boxes.UserBox.containsKey("user")
            ? const Homescreen()
            : const Welcomescreen());
  }
}
