import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Pages/FirstTimeView.dart';
import 'package:locateme/Pages/RegUserPages/HolderView.dart';
import 'package:locateme/Pages/PhoneView.dart';
import 'package:locateme/Pages/ServiceProviderPages/%D9%8DServiceProviderHolderView.dart';
import 'AuthController.dart';

//
class Root extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final AppController _appController = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_appController.serviceEnabled.value) {
          if (_authController.user != null) {
            if (_authController.localUser.isEmpty) {
              return FirstTimeView();
            } else {
              if (_authController.localUser["type"] == "Regular User") {
                return HolderView();
              } else {
                return ServiceProviderHolderView();
              }
            }
          } else {
            return PhoneRegistration();
          }
        } else {
          return Scaffold(
            body: Container(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "The gps feature is turned off",
                      textAlign: TextAlign.center,
                      style: mainStyle(
                        fontColor: context.theme.primaryColor,
                        fontSize: Get.width * 0.1,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.gps_off,
                      color: context.theme.primaryColor,
                      size: Get.width * 0.4,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Geolocator.openLocationSettings();
                      },
                      child: Container(
                        height: 70,
                        width: Get.width * 0.7,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Center(
                          child: Text(
                            "Click to enable",
                            style: mainStyle(
                              fontSize: 35,
                              fontColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _appController.checkPermissions();
                      },
                      child: Container(
                        height: 70,
                        width: Get.width * 0.7,
                        decoration: BoxDecoration(
                          color: sColor3,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Center(
                          child: Text(
                            "Refresh",
                            style: mainStyle(
                              fontSize: 35,
                              fontColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
