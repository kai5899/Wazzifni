import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Widgets/CustomDrawerWidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key key}) : super(key: key);
  final AuthController authController = Get.put(AuthController());
  final AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 40.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: authController.localUser["photoUrl"] == "none" ||
                          authController.localUser["photoUrl"] == null
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: Text(
                              authController.localUser["fullName"][0],
                              style: mainStyle(
                                fontSize: 100,
                                fontColor: mainColor,
                              ),
                            ),
                          ),
                        )
                      : null,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: authController.localUser["photoUrl"] ==
                                      "none" ||
                                  authController.localUser["photoUrl"] == null
                              ? Image.asset("assets/icons/consult.png").image
                              : Image.network(
                                  authController.localUser["photoUrl"],
                                  fit: BoxFit.contain,
                                  key: ValueKey(new Random().nextInt(100)),
                                ).image,
                          fit: BoxFit.cover)),
                ),
                Center(
                  child: Text(
                    authController.localUser["fullName"]
                        .toString()
                        .capitalizeFirst,
                    style: mainStyle(fontColor: sColor3, fontSize: 36),
                  ),
                ),
                Center(
                  child: Text(
                    authController.localUser["phoneNumber"],
                    style: mainStyle(fontColor: Colors.white60, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  onTap: () {
                    appController.changePage(0);
                  },
                  leading: Icon(Icons.home),
                  title: Text(
                    'home'.tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  onTap: () {
                    appController.changePage(1);
                  },
                  leading: Icon(Icons.local_offer),
                  title: Text(
                    'job_offers'.tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  onTap: () {
                    appController.changePage(2);
                  },
                  leading: Icon(Icons.edit),
                  title: Text(
                    'edit_profile'.tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  onTap: () {
                    appController.changePage(3);
                  },
                  leading: Icon(Icons.settings),
                  title: Text(
                    'settings'.tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  onTap: () {
                    appController.changePage(4);
                  },
                  leading: Icon(Icons.info_outline),
                  title: Text(
                    'aboutApp'.tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 24),
                  ),
                ),
                Spacer(),
                ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: appController.drawerController,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 1500),
                      opacity: value.visible ? 1 : 0,
                      child: GestureDetector(
                        onTap: () {
                          appController.handleMenuButtonPressed();
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "leave".tr,
                            desc: "leave_message".tr,
                            style: AlertStyle(
                              animationType: AnimationType.grow,
                              animationDuration: Duration(
                                milliseconds: 600,
                              ),
                              titleStyle: mainStyle(
                                fontSize: 36,
                                fontColor: Colors.red,
                              ),
                              descStyle: mainStyle(
                                fontSize: 24,
                                fontColor: mainColor,
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "cancel".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                color: Color.fromRGBO(0, 179, 134, 1.0),
                              ),
                              DialogButton(
                                child: Text(
                                  "yes".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Get.back();
                                  authController.signOut();
                                },
                                gradient: LinearGradient(colors: [
                                  Colors.red,
                                  Colors.redAccent,
                                  Colors.red[300],
                                ]),
                              )
                            ],
                          ).show();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(48),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "leave_button".tr,
                              style: mainStyle(
                                fontColor: Colors.red,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('termPrivacy'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
