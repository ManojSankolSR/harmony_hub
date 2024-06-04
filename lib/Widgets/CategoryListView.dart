import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harmony_hub/Navigation.dart';

class CategorylistviewWidget extends StatelessWidget {
  final List<dynamic?> searchcategoryData;
  final String categoryTitle;

  const CategorylistviewWidget(
      {super.key,
      required this.searchcategoryData,
      required this.categoryTitle});
  @override
  Widget build(BuildContext context) {
    return searchcategoryData.isEmpty
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  categoryTitle,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                          searchcategoryData[index]["type"],
                          context,
                          searchcategoryData[index]["id"],
                          // searchcategoryData[index]["type"] == "song"
                          //     ? [searchcategoryData[index]]
                          //     :
                          searchcategoryData,
                          index,
                          false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.download)),
                      ],
                    )),
              )
            ],
          );
  }
}
