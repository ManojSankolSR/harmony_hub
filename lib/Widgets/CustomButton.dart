import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final void Function() ontap;
  final String lable;
  final Icon icon;
  final Color backgroundcolor;

  const Custombutton(
      {super.key,
      required this.ontap,
      required this.lable,
      required this.icon,
      required this.backgroundcolor});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton.icon(
      onPressed: ontap,
      icon: icon,
      label: Text(lable),
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: backgroundcolor),
    );
  }
}
