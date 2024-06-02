import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:discover/layout/page_layout.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:discover/models/album.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final http.Client client = http.Client();
  late Future<List<Album>> allAlbums;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    allAlbums = _getAllAlbums();
  }

  Future<List<Album>> _getAllAlbums() async {
    var url = Uri.parse("http://10.0.2.2:3000/albums");
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var albums =
            data.map((e) => Album.fromJson(e as Map<String, dynamic>)).toList();
        return albums;
      } else {
        throw Exception('Failed to load albums: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Failed to load albums: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageLayout(
      page: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Search"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .75,
              child: FutureBuilder<List<Album>>(
                future: allAlbums,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("There's no Album available"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final album = snapshot.data![index];
                        return SizedBox(
                          height: 70,
                          child: Hero(
                            transitionOnUserGestures: true,
                            tag: album.id.toString(),
                            child: Material(
                              child: ListTile(
                                onTap: () {
                                  Get.toNamed('/album/${album.id}',
                                      arguments: album);
                                },
                                title: Text(
                                  album.title,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(album.artist),
                              ),
                            ),
                          ),);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
