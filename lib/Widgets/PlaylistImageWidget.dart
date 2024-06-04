import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Playlistimagewidget extends StatelessWidget {
  final int length;
  final List<String> images;

  const Playlistimagewidget(
      {super.key, required this.length, required this.images});

  Widget forZero() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(child: Image.asset(fit: BoxFit.cover, "assets/album.png")),
        ],
      ),
    );
  }

  Widget forOne() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
              child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  fit: BoxFit.cover,
                  imageUrl: images[0])),
        ],
      ),
    );
  }

  Widget forTwo() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  fit: BoxFit.cover,
                  imageUrl: images[0])),
          Expanded(
              child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  fit: BoxFit.cover,
                  imageUrl: images[1])),
        ],
      ),
    );
  }

  Widget forThree() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        fit: BoxFit.cover,
                        imageUrl: images[0])),
                Expanded(
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        fit: BoxFit.cover,
                        imageUrl: images[1])),
              ],
            ),
          ),
          Expanded(
              child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset(fit: BoxFit.cover, "assets/album.png"),
                  fit: BoxFit.cover,
                  imageUrl: images[2])),
        ],
      ),
    );
  }

  Widget forMoreThanFour() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        fit: BoxFit.cover,
                        imageUrl: images[0])),
                Expanded(
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        fit: BoxFit.cover,
                        imageUrl: images[1])),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        fit: BoxFit.cover,
                        imageUrl: images[2])),
                Expanded(
                    child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        errorWidget: (context, url, error) =>
                            Image.asset(fit: BoxFit.cover, "assets/album.png"),
                        fit: BoxFit.cover,
                        imageUrl: images[3])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (length) {
      case 0:
        return forZero();
      case 1:
        return forOne();

      case 2:
        return forTwo();

      case 3:
        return forThree();
      default:
        return forMoreThanFour();
    }
  }
}
