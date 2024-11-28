import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Navigation.dart';

class Customslivergrid extends ConsumerWidget {
  final List<dynamic> data;

  const Customslivergrid({super.key, required this.data});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    // TODO: implement build
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (1 / 1.2),
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        bool isArtist = data[index]["type"] == "artist";
        bool isImageList = data[index]["image"].runtimeType == List;
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            CustomNavigation.NavigateTo(
              ref: ref,
              data[index]["type"],
              context,
              data[index]["id"],
              data,
              index,
              false,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: isArtist ? null : BorderRadius.circular(10),
                      shape: isArtist ? BoxShape.circle : BoxShape.rectangle),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Image.asset(fit: BoxFit.cover, "assets/album.png"),
                      errorWidget: (context, url, error) =>
                          Image.asset(fit: BoxFit.cover, "assets/album.png"),
                      imageUrl: isImageList
                          ? data[index]["image"][2]["link"]
                          : data[index]["image"]),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  data[index]["name"],
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${data[index]["type"].toUpperCase()}  • ${data[index]["subtitle"] == null ? "" : data[index]["subtitle"].toUpperCase()}",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: isLightMode ? Colors.black87 : Colors.white70,
                      fontWeight: FontWeight.w400),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
