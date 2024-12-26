import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomListView extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget leading;
  final void Function() onPressed;

  const CustomListView(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onPressed,
      required this.leading});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(.15.dp),
      child: SizedBox(
        height: .55.dp,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(.2.dp),
            // side: BorderSide(color: Colors.grey.shade800, width: .5)
          ),
          color: Colors.transparent,
          // borderRadius: BorderRadius.circular(.2.dp),
          child: InkWell(
            borderRadius: BorderRadius.circular(.2.dp),
            onTap: () {
              onPressed();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 8.sp),
              child: Row(
                children: [
                  Container(
                    width: .53.dp,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade700)),
                    child: SizedBox.expand(child: leading),
                  ),
                  SizedBox(
                    width: .25.dp,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
