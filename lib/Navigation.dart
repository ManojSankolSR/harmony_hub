import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/Screens/ArtistDetailsScreen.dart';
import 'package:harmony_hub/Screens/SongPlayScreen.dart';
import 'package:harmony_hub/Screens/TracksListScreen.dart';

import 'package:flutter/material.dart';

class CustomNavigation {
  static NavigateTo(
    String type,
    BuildContext context,
    String? id,
    List<dynamic>? AudioData,
    int? startIndex,
    bool fromMiniPlayer,
  ) {
    switch (type) {
      case "playlist" || "album":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Trackslistscreen(id: id!, type: type),
            ));

        break;
      case "song":
        print("starin $startIndex");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongsPlayScreen(
                AudioData: AudioData ?? [],
                startIndex: startIndex ?? 0,
                fromMiniPlayer: fromMiniPlayer,
              ),
            ));

        break;

      case "radio_station" || "artist":
        print(AudioData![0]["subtitle"]);
        print(type);
        if (AudioData![0]["subtitle"] == "Artist Radio" ||
            AudioData[0]["subtitle"] == "Artist" ||
            AudioData![0]["subtitle"] == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Artistdetailsscreen(
                  id: id!,
                ),
              ));
        } else {
          _showDevWarning(context);
          return;
        }

        break;

      default:
        _showDevWarning(context);
    }
  }
}

void _showDevWarning(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
          color: Theme.of(context).colorScheme.onPrimaryFixed,
          title: "Sorry",
          message: "These Features Are Still in Development",
          contentType: ContentType.help)));
}

class FadeInOutTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // TODO: implement buildTransitions
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}