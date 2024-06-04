import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class Customsnackbar {
  final String title;
  final String subTitle;
  final BuildContext context;
  final ContentType type;

  Customsnackbar(
      {required this.title,
      required this.subTitle,
      required this.context,
      required this.type}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
            title: title,
            message: subTitle,
            contentType: type)));
  }
}
