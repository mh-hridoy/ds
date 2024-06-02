import 'package:discover/utils/colors.dart';
import 'package:flutter/material.dart';

TextTheme textThemeLight = const TextTheme(
  bodyLarge: TextStyle(
      fontFamily: "General",
      letterSpacing: -3,
      fontSize: 64,
      height: .9,
      decoration: TextDecoration.none,
      color: AppColor.baseColor900,
      fontWeight: FontWeight.w700),
      
  bodyMedium: TextStyle(
      height: .9,
      fontSize: 16,
      decoration: TextDecoration.none,
      fontFamily: "General",
      color: AppColor.baseColor500,
      fontWeight: FontWeight
          .w200), //body medium is the default size used in TEXT widget
  bodySmall: TextStyle(
      height: 1.4,
      fontSize: 14,
      decoration: TextDecoration.none,
      fontFamily: "General",
      color: AppColor.baseColor900),
  headlineLarge: TextStyle(
      height: .9,
      fontFamily: "General",
      fontSize: 32,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      color: AppColor.baseColor900),
  headlineMedium: TextStyle(
      height: .9,
      fontFamily: "General",
      fontSize: 20,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      color: AppColor.baseColor900),

  headlineSmall: TextStyle(
      height: .9,
      fontFamily: "General",
      fontSize: 16,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400,
      color: AppColor.baseColor700),
  titleLarge: TextStyle(
      height: .9,
      fontFamily: "General",
      fontSize: 16,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      color: AppColor.baseColor900),
  titleSmall: TextStyle(
    fontFamily: "General",
    fontSize: 12,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w200,
    color: AppColor.baseColor500,
  ),
  titleMedium: TextStyle(
      fontFamily: "General",
      fontSize: 14,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w600,
      color: AppColor.baseColor900),
).apply(bodyColor: AppColor.baseColor900, decoration: TextDecoration.none);

TextTheme texThemeDark = TextTheme(
  bodyLarge: textThemeLight.bodyLarge?.copyWith(color: AppColor.baseColor),
  bodyMedium: textThemeLight.bodyMedium?.copyWith(color: AppColor.baseColor200),
  bodySmall: textThemeLight.bodySmall?.copyWith(color: AppColor.baseColor100),
  headlineLarge:
      textThemeLight.headlineLarge?.copyWith(color: AppColor.baseColor),
  headlineMedium:
      textThemeLight.headlineMedium?.copyWith(color: AppColor.baseColor100),
  headlineSmall:
      textThemeLight.headlineSmall?.copyWith(color: AppColor.baseColor300),
  titleLarge: textThemeLight.titleLarge?.copyWith(color: AppColor.baseColor),
  titleSmall: textThemeLight.titleSmall?.copyWith(color: AppColor.baseColor200),
  titleMedium:
      textThemeLight.titleMedium?.copyWith(color: AppColor.baseColor100),
).apply(bodyColor: AppColor.baseColor, decoration: TextDecoration.none);

ButtonStyle appButtonStyle(BuildContext context) {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    textStyle: MaterialStateProperty.all<TextStyle>(
        Theme.of(context).textTheme.headlineSmall!),
    alignment: Alignment.center,
  );
}

ElevatedButtonThemeData Function(BuildContext context) elevatedButtonTheme =
    (BuildContext context) => ElevatedButtonThemeData(
            style: appButtonStyle(context).copyWith(
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.baseColor900),
              textStyle: MaterialStateProperty.all<TextStyle?>(textThemeLight.headlineSmall)
        ));

ElevatedButtonThemeData Function(BuildContext context) darkElevatedButtonTheme =
    (BuildContext context) => ElevatedButtonThemeData(
            style: appButtonStyle(context).copyWith(
          backgroundColor: MaterialStateProperty.all<Color>(AppColor.baseColor),
        ));
