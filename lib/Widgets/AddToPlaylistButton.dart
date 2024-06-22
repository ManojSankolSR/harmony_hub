import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/Functions/Playlist.dart';

class AddToPlayListButton extends StatefulWidget {
  final Map<String, dynamic> songdata;

  const AddToPlayListButton({super.key, required this.songdata});

  @override
  State<AddToPlayListButton> createState() => _AddToPlayListButtonState();
}

class _AddToPlayListButtonState extends State<AddToPlayListButton> {
  late TextEditingController _textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        onPressed: () {
          Playlists.showPlayListDialog(
              songdata: widget.songdata,
              textEditingController: _textEditingController,
              context: context);
        },
        icon: Icon(Icons.playlist_add));
  }
}
