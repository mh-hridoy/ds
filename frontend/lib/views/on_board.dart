import 'package:discover/utils/colors.dart';
import 'package:discover/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class OnBoardScreenView extends StatelessWidget {
  const OnBoardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    WindowSize windowSize = getWindowSize(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Stack(
        children: [
          Positioned(
            top: 120,
            child: SizedBox(
              width: windowSize.width > 1200
                  ? 1200
                  : windowSize.width,
              child: const Image(
                image: AssetImage("assets/img/boarding_draw.png"),
                filterQuality: FilterQuality.low,
                color: AppColor.baseColor200,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: (windowSize.width / 2) - (400 / 2),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Text(
                "Define yourself in your unique way.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
           const Positioned(
            bottom: 120,
            right: 0,
            height: 650,
            child: Image(
              image: AssetImage("assets/img/onboarding_person.png"),
            ),
          ),
          Positioned(
              bottom: 40,
              height: 56,
              left: (windowSize.width / 2) - (341 / 2),
              width: 341,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text(
                    "Get Started",
                  ),
                  icon: const Icon(AntDesign.arrowright),
                ),
              ))
        ],
      ),
    );
  }
}
