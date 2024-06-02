import 'package:discover/utils/colors.dart';
import 'package:discover/utils/helper.dart';
import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  final Widget page;
  final bool isCenter;
  const PageLayout({required this.page, this.isCenter = false, super.key});

  @override
  Widget build(BuildContext context) {
    WindowSize windowSize = getWindowSize(context);
    return Container(
      width: windowSize.width,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Stack(
        // crossAxisAlignment:
        //     isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,

        children: [
          Align(
            alignment: isCenter ? Alignment.center : Alignment.topLeft ,
            child: Container(
              // padding: const EdgeInsets.all(15),
              // decoration: BoxDecoration(color: Colors.red),
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: SafeArea(child: page),
            ),
          )
        ],
      ),
    );
  }
}
