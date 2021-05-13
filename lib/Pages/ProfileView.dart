import 'dart:math';

import 'package:animations/animations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:locateme/Configuration/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/ProfileController.dart';
import 'package:locateme/Widgets/CustomInputField.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileView extends StatelessWidget {
  ProfileView();
  final AuthController authController = Get.put(AuthController());
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _profileController.getImage(
                      userID: authController.localUser["uid"],
                      authController: authController);
                },
                child: Container(
                  height: Get.height * 0.25,
                  width: Get.height * 0.25,
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      _profileController.uploadTask.value == null
                          ? Container()
                          : StreamBuilder(
                              stream: _profileController
                                  .uploadTask.value.snapshotEvents,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                Widget indicator;
                                if (snapshot.hasData) {
                                  final TaskSnapshot snap = snapshot.data;
                                  indicator = CircularProgressIndicator(
                                    strokeWidth: 7,
                                    value:
                                        snap.bytesTransferred / snap.totalBytes,
                                    backgroundColor: mainColor,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(sColor1),
                                  );
                                  return Container(
                                    height: Get.height * 0.25,
                                    width: Get.height * 0.25,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: indicator,
                                  );
                                } else {
                                  indicator = const Text('Starting...');
                                  return ListTile(
                                    title: indicator,
                                  );
                                }
                              },
                            ),
                      authController.localUser["photoUrl"] == "none" ||
                              authController.localUser["photoUrl"] == null
                          ? Center(
                              child: Text(
                                authController.localUser["fullName"][0],
                                style: mainStyle(
                                  fontColor: Colors.white,
                                  fontSize: Get.height * 0.2,
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                height: Get.height * 0.24,
                                width: Get.height * 0.24,
                                decoration: BoxDecoration(
                                    // color: sColor3,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: Image.network(
                                        authController.localUser["photoUrl"],
                                        key:
                                            ValueKey(new Random().nextInt(100)),
                                      ).image,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
                child: Center(
                  child: Text(
                    authController.localUser["type"].toString().tr,
                    style: mainStyle(
                      fontColor: sColor3,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: ListTile(
                  title: Text(
                    "fullName".tr,
                    style: mainStyle(fontColor: context.theme.primaryColor),
                  ),
                  subtitle: Text(
                    authController.localUser["fullName"].toString(),
                    style: mainStyle(
                      fontSize: 36,
                      fontColor: mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: mainColor,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  onTap: () {
                    Alert(
                        context: context,
                        closeFunction: () {
                          Get.back();
                        },
                        title: "Edit Name".tr,
                        style: AlertStyle(
                          animationType: AnimationType.grow,
                          animationDuration: Duration(milliseconds: 500),
                          titleStyle: mainStyle(fontColor: Colors.red),
                        ),
                        content: Column(
                          children: <Widget>[
                            FieldEdited(
                              isPassword: false,
                              label: "fullName".tr,
                              type: TextInputType.name,
                              textColor: mainColor,
                              controller: _profileController.nameController,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            color: Colors.white,
                            onPressed: () => Get.back(),
                            child: Text(
                              "cancel".tr,
                              style: mainStyle(fontSize: 24),
                            ),
                          ),
                          DialogButton(
                            color: sColor3,
                            onPressed: () {
                              authController.updateRegUserName(
                                  _profileController.nameController.text);
                              Get.back();
                            },
                            child: Text(
                              "save".tr,
                              style: mainStyle(
                                  fontSize: 24, fontColor: Colors.white),
                            ),
                          )
                        ]).show();
                    // authController.updateRegUserName("wawa");
                  },
                ),
              ),
              authController.localUser["type"] == "Service Provider"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          "profession".tr,
                          style:
                              mainStyle(fontColor: context.theme.primaryColor),
                        ),
                        subtitle: Text(
                          authController.localUser["profession"].toString(),
                          style: mainStyle(
                            fontSize: 36,
                            fontColor: mainColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: Image.asset(
                                      "assets/icons/${authController.localUser["profession"].toString().toLowerCase()}.png")
                                  .image,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  onTap: () {
                    Alert(
                        context: context,
                        closeFunction: () {
                          Get.back();
                        },
                        title: "Edit BirthDay".tr,
                        style: AlertStyle(
                          animationType: AnimationType.grow,
                          animationDuration: Duration(milliseconds: 500),
                          titleStyle: mainStyle(fontColor: Colors.red),
                        ),
                        content: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                              ),
                              onPressed: () {
                                _profileController.pickDateDialog(context);
                              },
                            )
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            color: Colors.white,
                            onPressed: () => Get.back(),
                            child: Text(
                              "cancel".tr,
                              style: mainStyle(fontSize: 24),
                            ),
                          ),
                          DialogButton(
                            color: sColor3,
                            onPressed: () {
                              authController.updateRegUserBirthDay(
                                  _profileController.selectedDate.value.day
                                          .toString() +
                                      "/" +
                                      _profileController
                                          .selectedDate.value.month
                                          .toString() +
                                      "/" +
                                      _profileController.selectedDate.value.year
                                          .toString());
                              Get.back();
                            },
                            child: Text(
                              "save".tr,
                              style: mainStyle(
                                  fontSize: 24, fontColor: Colors.white),
                            ),
                          )
                        ]).show();
                  },
                  title: Text(
                    "birthDay".tr,
                    style: mainStyle(fontColor: context.theme.primaryColor),
                  ),
                  subtitle: Text(
                    authController.localUser["birthDay"]
                        .toString()
                        .capitalizeFirst,
                    style: mainStyle(
                      fontSize: 24,
                      fontColor: mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: mainColor,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(
                    "zodiac".tr,
                    style: mainStyle(fontColor: context.theme.primaryColor),
                  ),
                  subtitle: Text(
                    getZodicaSign(
                      days: int.parse(authController.localUser["birthDay"]
                          .toString()
                          .split("/")[0]),
                      months: int.parse(authController.localUser["birthDay"]
                          .toString()
                          .split("/")[1]),
                    ),
                    style: mainStyle(fontColor: mainColor, fontSize: 36),
                  ),
                  trailing: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: Image.asset("assets/zodiac/${getZodicaSign(
                          days: int.parse(authController.localUser["birthDay"]
                              .toString()
                              .split("/")[0]),
                          months: int.parse(authController.localUser["birthDay"]
                              .toString()
                              .split("/")[1]),
                        ).toString().toLowerCase()}.png")
                                .image)),
                  ),
                  onTap: () {},
                ),
              ),
              authController.localUser["type"] == "Service Provider"
                  ? OpenContainer(
                      transitionDuration: Duration(milliseconds: 400),
                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (BuildContext context, VoidCallback _) {
                        // jobsController.jobRequirementss.clear();
                        return Scaffold(
                          body: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 32,
                                    right: 32,
                                  ),
                                  child: Text("Old Bio".tr,
                                      style: mainStyle(fontSize: 24),
                                      textAlign: TextAlign.start),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 32,
                                    right: 32,
                                  ),
                                  child: Text(
                                    authController.localUser["bio"],
                                    style: mainStyle(fontSize: 36),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 32,
                                    right: 32,
                                  ),
                                  child: Text("New Bio".tr,
                                      style: mainStyle(fontSize: 24),
                                      textAlign: TextAlign.start),
                                ),
                                FieldEdited(
                                  label: "bio".tr,
                                  color: mainColor,
                                  isPassword: false,
                                  maxLine: 5,
                                  controller: _profileController.bioController,
                                  textColor: Colors.white,
                                  type: TextInputType.multiline,
                                  icon: Icons.text_format_outlined,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton(
                                      backgroundColor: Colors.red,
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    FloatingActionButton(
                                      backgroundColor: Colors.green,
                                      onPressed: () {
                                        authController.updateBio(
                                            _profileController
                                                .bioController.text);
                                        Get.back();
                                      },
                                      child: Icon(Icons.check,
                                          color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      closedElevation: 0.0,
                      closedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(360),
                        ),
                      ),
                      closedColor: Colors.white,
                      closedBuilder:
                          (BuildContext context, VoidCallback openContainer) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: ListTile(
                            title: Text(
                              "bio".tr,
                              style: mainStyle(
                                  fontColor: context.theme.primaryColor),
                            ),
                            subtitle: Text(
                              authController.localUser["bio"].toString(),
                              style: mainStyle(
                                fontSize: 24,
                                fontColor: mainColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: mainColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
              authController.localUser["type"] == "Service Provider"
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16.0),
                      child: ListTile(
                        title: Text(
                          "am i available ? ".tr,
                          style: mainStyle(
                            fontColor: context.theme.primaryColor,
                            fontSize: 24,
                          ),
                        ),
                        trailing: Container(
                          width: 100,
                          child: FlutterSwitch(
                            value: authController.localUser["available"],
                            onToggle: (val) {
                              authController.updateAvailable(val);
                            },
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  bool isRunningState(TaskSnapshot snap) {
    return snap.state.toString() == "TaskState.running";
  }
}
