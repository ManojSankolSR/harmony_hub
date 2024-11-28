import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Navigation.dart';
import 'package:harmony_hub/Widgets/AddToPlaylistButton.dart';
import 'package:harmony_hub/Widgets/DownloadButton.dart';
import 'package:harmony_hub/Widgets/LikeButton.dart';

class CategorylistviewWidget extends ConsumerWidget {
  final List<dynamic> searchcategoryData;
  final String categoryTitle;

  const CategorylistviewWidget(
      {super.key,
      required this.searchcategoryData,
      required this.categoryTitle});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return searchcategoryData.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  categoryTitle,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchcategoryData.length,
                itemBuilder: (context, index) => ListTile(
                    leading: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                          placeholder: (context, url) => Image.asset(
                              fit: BoxFit.cover, "assets/album.png"),
                          errorWidget: (context, url, error) => Image.asset(
                              fit: BoxFit.cover, "assets/album.png"),
                          imageUrl: searchcategoryData[index]["image"]
                                      .runtimeType ==
                                  List
                              ? searchcategoryData[index]["image"][2]["link"]
                              : searchcategoryData[index]["image"]),
                    ),
                    title: Text(
                      searchcategoryData[index]["name"],
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      searchcategoryData[index]["subtitle"],
                      maxLines: 1,
                    ),
                    onTap: () {
                      CustomNavigation.NavigateTo(
                          ref: ref,
                          searchcategoryData[index]["type"],
                          context,
                          searchcategoryData[index]["id"],
                          searchcategoryData[index]["type"] == "song"
                              ? searchcategoryData
                              : searchcategoryData,
                          searchcategoryData[index]["type"] == "song"
                              ? index
                              : 0,
                          false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    trailing: searchcategoryData[index]["type"] == "song"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Likebutton(songData: searchcategoryData[index]),
                              AddToPlayListButton(
                                  songdata: searchcategoryData[index]),
                              DownloadButton(
                                  songData: searchcategoryData[index]),
                            ],
                          )
                        : null),
              )
            ],
          );
  }
}
