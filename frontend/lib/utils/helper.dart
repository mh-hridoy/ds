import "package:flutter/material.dart";


class WindowSize {
  final double width;
  final double height;

  WindowSize(this.height, this.width);
}

WindowSize getWindowSize (BuildContext context) {
  return WindowSize(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
}