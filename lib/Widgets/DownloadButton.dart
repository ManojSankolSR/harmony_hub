import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harmony_hub/Functions/Storage.dart';
import 'package:harmony_hub/Hive/Boxes.dart';
import 'package:hive_flutter/adapters.dart';

class DownloadButton extends StatefulWidget {
  final Map<String, dynamic> songData;
  final double iconSize;

  DownloadButton({super.key, required this.songData, this.iconSize = 25});

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool _isDownloading = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Boxes.UserBox.listenable(),
        builder: (context, value, child) {
          bool isDownloaded =
              Downloads.getDownloadedSongIds().contains(widget.songData['id']);
          return IconButton(
              onPressed: isDownloaded
                  ? null
                  : () async {
                      setState(() {
                        _isDownloading = true;
                      });
                      try {
                        await Downloads.downloadSong(widget.songData, context);
                      } catch (e) {
                        print("error $e");
                      } finally {
                        setState(() {
                          _isDownloading = false;
                        });
                      }
                    },
              icon: _isDownloading
                  ? CircularProgressIndicator()
                  : isDownloaded
                      ? Icon(
                          Icons.download_done_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: widget.iconSize,
                        ).animate().scale(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.elasticOut)
                      : Icon(
                          Icons.file_download_outlined,
                          size: widget.iconSize,
                        ).animate().scale(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.elasticOut));
        });
  }
}
