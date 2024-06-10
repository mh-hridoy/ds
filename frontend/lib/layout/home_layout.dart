import 'package:discover/views/home/home_page.dart';
import 'package:discover/views/home/search_page.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:discover/grpc/album.pbgrpc.dart';

class HomeLayout extends StatefulWidget {
  final String route;
  const HomeLayout({this.route = "/", super.key});

  @override
  HomeLayoutState createState() => HomeLayoutState();
}

class HomeLayoutState extends State<HomeLayout> {
  late ClientChannel connection;
  late AlbumServicesClient client;
  
  int currentIndex = 0;
  bool canPop = false;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    connection = ClientChannel("10.0.2.2", port: 50051, options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = AlbumServicesClient(connection);
 
  }
  Future<void> getAllAlbums () async {
    try {
      final response = await client.getAllAlbum(AlbumEmptyRequest());
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

Future<void> postASingleAlbum () async {
  await client.postSingleAlbum(Album(title: "calling from flutetr", artist: "Artist from flutter", price: 10.00));
}

  
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPop,
        onPopInvoked: (bool didPop) {
          if (currentIndex == 1) {
            setState(() {
              currentIndex = 0;
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              canPop = true;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Discover"),
            leading: IconButton(icon: const Icon(Icons.menu), onPressed: () async {
             await postASingleAlbum();
            },),
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (value) => {
              setState(() {
                currentIndex = value;
              })
            },
            children: const [
              HomePage(),
              SearchPage(),
            ],
          ),
          // bottom navigation
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) => {
              setState(() {
                currentIndex = value;
              }),
              pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search")
            ],
          ),
        ));
  }
}
