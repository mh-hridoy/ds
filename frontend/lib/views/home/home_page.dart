import 'package:flutter/material.dart';
import 'package:discover/layout/page_layout.dart';
import 'package:discover/components/counter.dart';

class HomePage extends StatefulWidget {
  // final void Function(String) changeRoute;
  const HomePage({ Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const PageLayout(
      page: SingleChildScrollView(child: Center(
          child: Column(
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     widget.changeRoute("/search");
              //   },
              //   child: Text("Go to next screen"),
              // ),
              Text(
                  "this is Home page"),
              SizedBox(height: 20),
              Counter(),
            ],
          ),
        ),),
    );
  }
}
