import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/Constants.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/FirstTimeRegisterController.dart';
import 'package:locateme/Widgets/CustomInputField.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FirstTimeView extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final FirstTimeController _kTimeController = Get.put(FirstTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "User Profile",
          style: mainStyle(
            fontSize: 36,
            fontColor: mainColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _kTimeController.getImage(
                      userID: _authController.user.uid,
                    );
                    // authController: _authController);
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
                          _kTimeController.uploadTask.value == null
                              ? Container()
                              : StreamBuilder(
                                  stream: _kTimeController
                                      .uploadTask.value.snapshotEvents,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    Widget indicator;
                                    if (snapshot.hasData) {
                                      final TaskSnapshot snap = snapshot.data;
                                      indicator = CircularProgressIndicator(
                                        strokeWidth: 7,
                                        value: snap.bytesTransferred /
                                            snap.totalBytes,
                                        backgroundColor: mainColor,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                sColor1),
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
                          _kTimeController.photoUrl.value == "none" ||
                                  _kTimeController.photoUrl.value == null
                              ? Container()
                              : Center(
                                  child: Container(
                                    height: Get.height * 0.24,
                                    width: Get.height * 0.24,
                                    decoration: BoxDecoration(
                                        // color: sColor3,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: Image.network(
                                            _kTimeController.photoUrl.value,
                                            key: ValueKey(
                                                new Random().nextInt(100)),
                                          ).image,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                FieldEdited(
                  label: "Full Name",
                  color: mainColor,
                  isPassword: false,
                  controller: _kTimeController.nameController,
                  textColor: Colors.white,
                  icon: Icons.text_format_outlined,
                  type: TextInputType.name,
                  maxLine: null,
                ),
                FieldEdited(
                  label: "Bio",
                  color: mainColor,
                  isPassword: false,
                  maxLine: 5,
                  controller: _kTimeController.bioController,
                  textColor: Colors.white,
                  type: TextInputType.multiline,
                  icon: Icons.text_format_outlined,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Row(
                    children: [
                      Text(
                        "Birthday :",
                        style: mainStyle(
                          fontSize: 24,
                          fontColor: mainColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 32, top: 0, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Get.width * 0.65,
                          child: Row(
                            children: [
                              Text(
                                _kTimeController.selectedDate.value.day
                                        .toString() +
                                    "  ",
                                style: mainStyle(
                                    fontSize: 36, fontColor: mainColor),
                              ),
                              Text(
                                "/" + "  ",
                                style: mainStyle(
                                    fontSize: 36, fontColor: mainColor),
                              ),
                              Text(
                                _kTimeController.selectedDate.value.month
                                        .toString() +
                                    "  ",
                                style: mainStyle(
                                    fontSize: 36, fontColor: mainColor),
                              ),
                              Text(
                                "/" + "  ",
                                style: mainStyle(
                                    fontSize: 36, fontColor: mainColor),
                              ),
                              Text(
                                _kTimeController.selectedDate.value.year
                                        .toString() +
                                    "  ",
                                style: mainStyle(
                                    fontSize: 36, fontColor: mainColor),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.15,
                          child: Center(
                            child: FloatingActionButton(
                              backgroundColor: sColor3,
                              child: FaIcon(FontAwesomeIcons.calendarAlt),
                              onPressed: () {
                                _kTimeController.pickDateDialog(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Row(
                        children: [
                          Text(
                            "You are :",
                            style: mainStyle(
                                fontSize: 24,
                                fontColor: mainColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: DropdownButton<String>(
                        hint: Text(
                          "Select item",
                        ),
                        value: _kTimeController.userType.value,
                        onChanged: (String value) {
                          _kTimeController.changeType(value);
                        },
                        items: userTypes.map((String user) {
                          return DropdownMenuItem<String>(
                            value: user,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  user,
                                  style: mainStyle(
                                      fontSize: 24,
                                      fontColor: mainColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedOpacity(
                  opacity: _kTimeController.userType.value != "Service Provider"
                      ? 0
                      : 1,
                  duration: Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Price : ${(_kTimeController.values.value.start * 1000).toStringAsFixed(0)} : ${(_kTimeController.values.value.end * 1000).toStringAsFixed(0)}",
                          style: mainStyle(
                              fontSize: 24,
                              fontColor: mainColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _kTimeController.userType.value != "Service Provider"
                      ? 0
                      : 1,
                  duration: Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfRangeSlider(
                      activeColor: sColor3,
                      inactiveColor: mainColor,
                      min: 20.0,
                      max: 10000.0,
                      values: _kTimeController.values.value,
                      interval: 1000,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (SfRangeValues values) {
                        _kTimeController.changeValues(values);
                      },
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _kTimeController.userType.value != "Service Provider"
                      ? 0
                      : 1,
                  duration: Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Row(
                          children: [
                            Text(
                              "Your Profession is :",
                              style: mainStyle(
                                  fontSize: 24,
                                  fontColor: mainColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: DropdownButton<String>(
                          hint: Text("Select Profession"),
                          value: _kTimeController.profession.value,
                          onChanged: (String value) {
                            _kTimeController.changeProfession(value);
                          },
                          items: profesions.map((String user) {
                            return DropdownMenuItem<String>(
                              value: user,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    user,
                                    style: mainStyle(
                                        fontSize: 24,
                                        fontColor: mainColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween(begin: -60.0, end: Get.height * 0.1 * 0.2),
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
                                  "Save and Proceed",
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
                      _kTimeController.save(
                          _authController.user, _authController);
                      _kTimeController.dispose();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print(_authController.localUser);
      //   },
      // ),
    );
  }
}
