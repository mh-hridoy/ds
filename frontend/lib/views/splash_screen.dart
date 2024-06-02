import 'package:discover/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final svgColor = Theme.of(context).colorScheme.onPrimary;
    return Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Stack(children: [
          Positioned(
              top: 80,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                width: MediaQuery.of(context).size.width > 1000 ? 1000 :
                MediaQuery.of(context).size.width,
                child: const Image(
                  image: AssetImage(
                    "assets/img/splash_draw.png",
                  ),
                  filterQuality: FilterQuality.high,
                  color: AppColor.baseColor500,
                  fit: BoxFit.fill,
                ),
              )),
          Positioned(
              bottom: 100,
              left: (MediaQuery.of(context).size.width / 2) - 25,
              child: CircularProgressIndicator(
                color: svgColor,
                strokeWidth: 8,
              )),
          Center(
              child: SvgPicture.asset(
            "assets/img/splash_icon.svg",
            width: 150,
            height: 150,
            colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
          )),

          // Positioned( top: 80, child: Transform.scale( child:
          // const Image(image: AssetImage("assets/img/splash_draw.png", ),
          // filterQuality: FilterQuality.low, color: AppColor.baseColor700,
          // ),) )
        ]));
  }
}
