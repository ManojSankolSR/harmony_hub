import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:harmony_hub/DataModels/UserModel.dart';
import 'package:harmony_hub/Functions/MusicPlayer.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Providers/SavanApiProvider.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:harmony_hub/Screens/HomeScreen.dart';
import 'package:harmony_hub/Screens/WelcomeScreen.dart';
import 'package:harmony_hub/Widgets/SongBottomBarWidget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Boxes.InitilizeBoxes();
  // await Boxes.UserBox.delete('user');

  await Permission.storage.request();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color _seedColor = ref.watch(seedColorProvider);
    return MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          physics: BouncingScrollPhysics(),
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
