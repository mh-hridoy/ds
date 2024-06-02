import 'package:discover/layout/home_layout.dart';
import 'package:discover/models/album.dart';
import 'package:discover/utils/colors.dart';
import 'package:discover/utils/theme.dart';
import 'package:discover/views/albums/album_page.dart';
import 'package:discover/views/auth/register_user.dart';
import 'package:discover/views/home/home_page.dart';
import 'package:discover/views/home/search_page.dart';
import 'package:discover/views/on_board.dart';
import 'package:discover/views/splash_screen.dart';
import 'package:discover/views/test_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discover',
      theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
              selectionColor: AppColor.baseColor400),
          elevatedButtonTheme: elevatedButtonTheme(context),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.baseColor)
              .copyWith(
                  primary: AppColor.baseColor,
                  onPrimary: AppColor.baseColor900,
                  inversePrimary: AppColor.baseColor900),
          useMaterial3: true,
          textTheme: textThemeLight),
      darkTheme: ThemeData(
        textSelectionTheme:
            const TextSelectionThemeData(selectionColor: AppColor.baseColor400),
        elevatedButtonTheme: darkElevatedButtonTheme(context),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.baseColor900)
            .copyWith(
                primary: AppColor.baseColor900,
                onPrimary: AppColor.baseColor,
                inversePrimary: AppColor.baseColor),
        useMaterial3: true,
        textTheme: texThemeDark,
      ),
      themeMode: ThemeMode.light,
      initialRoute: "/",
      getPages: [
        GetPage(
            name: "/",
            page: () => const HomeLayout(
                  route: "/",
                )),
        GetPage(
            name: "/search",
            page: () => const HomeLayout(
                  route: "/search",
                )),
        GetPage(name: "/test", page: () => const TestPage()),
        GetPage(name: "/album/:id", page: () => const AlbumPage())
      ],
    );
  }
}
