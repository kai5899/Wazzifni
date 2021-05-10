import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Widgets/CustomDrawerWidget.dart';
import 'package:locateme/Widgets/DrawerWidget.dart';

import '../AboutTheAppView.dart';
import '../Settings.dart';
import 'RegUserHomePageView.dart';
import '../ProfileView.dart';
import '../JobsView.dart';

class HolderView extends StatelessWidget {
  // final RegUserAppController appController = Get.put(RegUserAppController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AppController(),
      builder: (AppController controller) => AdvancedDrawer(
        backdropColor: controller.drawerColor.value,
        controller: controller.drawerController,
        child: WillPopScope(
          onWillPop: () {
            if (!controller.expanded.value) {
              controller.handleMenuButtonPressed();
              return Future.value(false);
            } else if (controller.expanded.value) {
              if (controller.selectedPage.value != 0) {
                controller.handleMenuButtonPressed();

                Future.delayed(const Duration(seconds: 1, milliseconds: 500),
                    () {
                  controller.selectedPage.value = 0;
                  controller.update();
                  controller.handleMenuButtonPressed();
                });
                return Future.value(false);
              }
            }
            return Future.value(true);
          },
          child: Scaffold(
            // backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              title: Text(
                getTitle(controller.selectedPage.value),
                style: mainStyle(
                    fontColor: context.theme.primaryColor, fontSize: 36),
              ),
              leading: IconButton(
                onPressed: () {
                  controller.handleMenuButtonPressed();
                },
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: controller.drawerController,
                  builder: (context, value, child) {
                    return AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: controller.controller,
                      semanticLabel: 'Show menu',
                      color: context.theme.primaryColor,
                      size: 36,
                    );
                    // Icon(
                    //   value.visible ? Icons.clear : Icons.menu,
                    //   color: mainColor,
                    //   size: 36,
                    // );
                  },
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: context.theme.primaryColor,
                    size: 36,
                  ),
                  onPressed: () {
                    if (controller.expanded.value) {
                      if (controller.selectedPage.value != 3) {
                        controller.handleMenuButtonPressed();

                        Future.delayed(
                            const Duration(seconds: 1, milliseconds: 500), () {
                          controller.selectedPage.value = 3;
                          controller.update();
                          controller.handleMenuButtonPressed();
                        });
                      }
                    }
                  },
                )
              ],
              centerTitle: true,
            ),
            body: getPage(controller.selectedPage.value),
          ),
        ),
        openRatio: 0.6,
        animationDuration: Duration(seconds: 1, milliseconds: 500),
        animationCurve: Curves.easeInOutBack,
        drawer: DrawerWidget(),
      ),
    );
    // );
  }

  String getTitle(int value) {
    if (value == 0) {
      return "title".tr;
    } else if (value == 1) {
      return "job_offers".tr;
    } else if (value == 2) {
      return "edit_profile".tr;
    } else if (value == 3) {
      return "settings".tr;
    } else {
      return "aboutApp".tr;
    }
  }

  Widget getPage(int value) {
    if (value == 0) {
      return RegularUserHomeView();
    } else if (value == 1) {
      return JobsView();
    } else if (value == 2) {
      return ProfileView();
    } else if (value == 3) {
      return SettingsView();
    } else {
      return AboutTheAppView();
    }
  }
}
