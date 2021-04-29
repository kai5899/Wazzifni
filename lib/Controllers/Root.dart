import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Pages/FirstTimeView.dart';
import 'package:locateme/Pages/RegUserPages/HolderView.dart';
import 'package:locateme/Pages/PhoneView.dart';
import 'package:locateme/Pages/ServiceProviderPages/%D9%8DServiceProviderHolderView.dart';

import 'AuthController.dart';

//
class Root extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
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
      },
    );
  }
}
