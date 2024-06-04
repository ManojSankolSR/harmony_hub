import 'package:flutter/material.dart';

class Notfoundwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 100,
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RotatedBox(
              quarterTurns: -1,
              child: Text(
                "Nothing to",
                style: TextStyle(
                    height: 2,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Show Here",
                style: TextStyle(
                    height: 1.25, fontSize: 50, fontWeight: FontWeight.w600),
              ),
              Text(
                "Go and Add Something",
                style: TextStyle(
                    height: 1.25,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary),
              )
            ],
          )
        ],
      ),
    );
  }
}
