import 'package:flutter/material.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:get/get.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Widgets/CustomDrawerWidget.dart';

class ServiceProviderHomeView extends StatelessWidget {
  ServiceProviderHomeView();
  final AppController controller = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Click on",
              style: mainStyle(
                fontSize: 48,
                fontColor: context.theme.primaryColor,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     controller.handleMenuButtonPressed();
            //   },
            //   icon: ,
            // ),
            GestureDetector(
              child: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: controller.drawerController,
                builder: (context, value, child) {
                  return AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: controller.controller,
                      semanticLabel: 'Show menu',
                      color: context.theme.primaryColor,
                      size: Get.height * 0.3);
                  // Icon(
                  //   value.visible ? Icons.clear : Icons.menu,
                  //   color: mainColor,
                  //   size: 36,
                  // );
                },
              ),
              onTap: () {
                controller.handleMenuButtonPressed();
              },
            ),
            Text(
              "to navigate !",
              style: mainStyle(
                fontSize: 48,
                fontColor: context.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
