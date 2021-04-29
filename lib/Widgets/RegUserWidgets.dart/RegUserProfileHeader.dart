import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';

class RegUserProfileHeader extends StatelessWidget {
  RegUserProfileHeader();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.24,
      width: Get.height * 0.24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: mainColor,
        image: authController.localUser["photoUrl"] == "none"
            ? null
            : DecorationImage(
                image:
                    Image.network(authController.localUser["photoUrl"]).image,
                fit: BoxFit.cover),
      ),
      child: authController.localUser["photoUrl"] == "none"
          ? CircleAvatar(
              backgroundColor: mainColor,
              child: Center(
                child: Text(
                  authController.localUser["fullName"][0]
                      .toString()
                      .capitalizeFirst,
                  style: mainStyle(
                    fontSize: 100,
                    fontColor: Colors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
