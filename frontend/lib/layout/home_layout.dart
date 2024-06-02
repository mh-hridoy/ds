import 'package:discover/views/home/home_page.dart';
import 'package:discover/views/home/search_page.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  final String route;
  const HomeLayout({this.route = "/", super.key});

  @override
  HomeLayoutState createState() => HomeLayoutState();
}

class HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  bool canPop = false;
  final PageController pageController = PageController();
  
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
            leading: const SizedBox(),
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
