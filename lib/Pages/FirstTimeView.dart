import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locateme/Configuration/Constants.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/FirstTimeRegisterController.dart';
import 'package:locateme/Widgets/CustomInputField.dart';
import 'package:map_pin_picker/map_pin_picker.dart';
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
                Text(
                  "Select location",
                  textAlign: TextAlign.center,
                  style: mainStyle(
                    fontSize: 24,
                    fontColor: mainColor,
                  ),
                ),
                Text(
                  "By default your current location will be selected",
                  textAlign: TextAlign.center,
                  style: mainStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
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
                        "Pick Location",
                        style: mainStyle(
                          fontColor: Colors.white,
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(LocationPickPage());
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _kTimeController.userType.value != "Service Provider"
                    ? Container(
                        height: 0,
                      )
                    : FieldEdited(
                        label: "Bio",
                        color: mainColor,
                        isPassword: false,
                        maxLine: 5,
                        controller: _kTimeController.bioController,
                        textColor: Colors.white,
                        type: TextInputType.multiline,
                        icon: Icons.text_format_outlined,
                      ),
                _kTimeController.userType.value != "Service Provider"
                    ? Container(
                        height: 0,
                      )
                    : Padding(
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
                _kTimeController.userType.value != "Service Provider"
                    ? Container(
                        height: 0,
                      )
                    : Padding(
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
                _kTimeController.userType.value != "Service Provider"
                    ? Container(
                        height: 0,
                      )
                    : Row(
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

class LocationPickPage extends StatefulWidget {
  @override
  _LocationPickPageeState createState() => _LocationPickPageeState();
}

class _LocationPickPageeState extends State<LocationPickPage> {
  Completer<GoogleMapController> _controller = Completer();
  final FirstTimeController firstTimeController =
      Get.put(FirstTimeController());
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(31.2060916, 29.9187),
    zoom: 14.4746,
  );

  Address address;

  var textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    cameraPosition = CameraPosition(
      target: LatLng(firstTimeController.currentPosition.value.latitude,
          firstTimeController.currentPosition.value.longitude),
      zoom: 14.4746,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapPicker(
              // pass icon widget
              iconWidget: Icon(
                Icons.location_pin,
                size: 50,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                zoomControlsEnabled: false,
                // hide location button
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                //  camera position
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  mapPickerController.mapMoving();
                },
                onCameraMove: (cameraPosition) {
                  this.cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving();
                  //get address name from camera position
                  List<Address> addresses = await Geocoder.local
                      .findAddressesFromCoordinates(Coordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude));
                  // update the ui with the address
                  textController.text = '${addresses.first?.addressLine ?? ''}';
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("hhello");
          firstTimeController.currentPosition.value = cameraPosition.target;
          firstTimeController.update();
          Get.back();
        },
        child: Icon(Icons.location_city),
      ),
      bottomNavigationBar: GestureDetector(
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              color: Colors.blue,
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero, border: InputBorder.none),
                controller: textController,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              // icon: Icon(Icons.directions_boat),
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
