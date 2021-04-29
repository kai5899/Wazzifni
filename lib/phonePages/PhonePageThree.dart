import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';

class PhonePageThree extends StatelessWidget {
  final Function onPressed;

  PhonePageThree({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/verified.png",
              height: Get.height * 0.3,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Congrats!\nYour number is verified.",
              style: mainStyle(
                fontColor: mainColor,
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              child: Container(
                height: 70,
                width: Get.width * 0.5,
                child: Center(
                  child: Text(
                    "Proceed",
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 36,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(36)),
              ),
              onTap: () {
                onPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
