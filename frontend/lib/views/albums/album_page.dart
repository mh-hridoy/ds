import 'package:flutter/material.dart';
import 'package:discover/models/album.dart';
import 'package:get/get.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Album album = Get.arguments;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(album.title),
        ),
        body: Hero(
              tag: album.id.toString(),
              child: Column(
                children: [
                  Text(
                    album.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              )),
        ),
    );
  }
}
