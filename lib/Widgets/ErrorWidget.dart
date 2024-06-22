import 'package:flutter/material.dart';

class Errorwidget extends StatelessWidget {
  final void Function() ontap;

  const Errorwidget({super.key, required this.ontap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Text("Sorry Some Error Occured"),
          TextButton(onPressed: ontap, child: Text("Refresh"))
        ],
      ),
    );
  }
}
