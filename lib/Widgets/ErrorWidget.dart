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
          const Icon(
            Icons.error,
            size: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Sorry Some Error Occured"),
          TextButton(onPressed: ontap, child: const Text("Refresh"))
        ],
      ),
    );
  }
}
