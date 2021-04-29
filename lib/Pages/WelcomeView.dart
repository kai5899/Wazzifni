import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Pages/PhoneView.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome",
              style: mainStyle(
                fontSize: Get.width * 0.25,
                fontColor: mainColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: Get.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/icons/location.png"),
                  Image.asset("assets/icons/24hours.png"),
                ],
              ),
            ),
            Container(
              height: Get.height * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/icons/consult.png"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "By proceeding you agree to the term and condition of the app.",
                style: mainStyle(
                  fontColor: Colors.grey[600],
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween(begin: -60.0, end: Get.height * 0.1*0.2),
              duration: Duration(milliseconds: 500),
              builder: (context, value, child) => GestureDetector(
                child: Container(
                  height: Get.height * 0.1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        bottom: value,
                        child: Container(
                          height: 60,
                          width: Get.width * 0.6,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Proceed",
                              style: mainStyle(
                                fontColor: Colors.white,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print("proceed was clicked");
                  Get.to(
                    () => PhoneRegistration(),
                    transition: Transition.leftToRightWithFade,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
