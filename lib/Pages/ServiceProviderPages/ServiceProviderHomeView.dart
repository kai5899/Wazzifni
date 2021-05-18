import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:get/get.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Controllers/AuthController.dart';

class ServiceProviderHomeView extends StatelessWidget {
  ServiceProviderHomeView();
  final AppController controller = Get.put(AppController());

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "am i available ? ".tr,
              style: mainStyle(
                fontColor: context.theme.primaryColor,
                fontSize: 48,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 100,
              child: FlutterSwitch(
                value: authController.localUser["available"],
                onToggle: (val) {
                  authController.updateAvailable(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
