import 'package:discover/components/counter.dart';
import 'package:discover/layout/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SearchPage extends StatefulWidget {
  // final void Function(String) changeRoute;
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  PageLayout(
      page: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed("/test");
                // widget.changeRoute("/");
              },
              child: const Text("Test Page"),
            ),
            const Text("this is Search page"),

            const SizedBox(height: 20),
            const Counter(),
          ],
        ),
      ),
    );
  }
}
