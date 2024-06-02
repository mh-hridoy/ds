import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Back page")),
    );
  }
}
