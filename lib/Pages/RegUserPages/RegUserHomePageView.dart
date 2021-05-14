import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locateme/Configuration/Constants.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/RegularUserController.dart';
import 'package:locateme/Controllers/SettingsController.dart';
import 'package:locateme/Models/ServiceProvider.dart';
import 'package:locateme/Widgets/RegUserPanelWidget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RegularUserHomeView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final RegularUserController userController = Get.put(RegularUserController());
  final SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SlidingUpPanel(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: Row(
                          children: [
                            Text(
                              "Filter :".tr,
                              style: mainStyle(
                                  fontSize: 24,
                                  fontColor: context.theme.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: DropdownButton<String>(
                          hint: Text(
                            "Select item".tr,
                            style: mainStyle(
                                fontSize: 24,
                                fontColor: context.theme.primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          value: userController.userType.value,
                          onChanged: (String value) {
                            userController.changeType(value);
                            userController.filter();
                          },
                          items: profesions.map((String user) {
                            return DropdownMenuItem<String>(
                              value: user,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: Image.asset(
                                                "assets/icons/${user.toLowerCase()}.png")
                                            .image,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    user,
                                    style: mainStyle(
                                        fontSize: 24,
                                        fontColor: context.theme.primaryColor,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.3,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () {
                              userController.getServices();
                            },
                            child: Center(
                              child: Text(
                                "Refresh".tr,
                                style: mainStyle(
                                    fontColor: context.theme.accentColor),
                              ),
                            )),
                      ),
                      Container(
                        width: Get.width * 0.3,
                        child: ElevatedButton(
                            onPressed: () {
                              userController.resetFilter();
                            },
                            child: Center(
                              child: Text(
                                "Reset Filter".tr,
                                style: mainStyle(
                                    fontColor: context.theme.accentColor),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Found ".tr +
                        "${userController.markers.length} " +
                        "Service Provider".tr,
                    style: mainStyle(
                      fontSize: 24,
                      fontColor: context.theme.primaryColor,
                    ),
                  ),
                ),
                settingsController.optionSelected.value == 1
                    ? Padding(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: mainColor,
                          ),
                          height: 65,
                          child: Padding(
                            child: TextFormField(
                              onChanged: (text) {
                                userController.filterBylocation(text);
                              },
                              cursorColor: Colors.white,
                              style: mainStyle(
                                fontColor: context.theme.accentColor,
                                fontSize: 24,
                              ),
                              decoration: InputDecoration(
                                icon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.search,
                                    color: context.theme.accentColor,
                                    size: 36,
                                  ),
                                ),
                                labelText: "Enter a location",
                                labelStyle: mainStyle(
                                  fontColor: context.theme.accentColor,
                                  fontSize: 20,
                                ),
                                fillColor: Colors.white,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 15, bottom: 15),
                      )
                    : Container(
                        height: 10,
                      ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      ),
                    ),
                    child: settingsController.optionSelected.value == 0
                        ? GoogleMap(
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            markers: userController.markers,
                            onMapCreated: (controller) {
                              userController.mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                double.parse(
                                    authController.localUser["latitude"]),
                                double.parse(
                                    authController.localUser["longitude"]),
                              ),
                              zoom: 11.5,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: userController.filteredList.length,
                              itemBuilder: (context, index) {
                                ServiceProvider serviceProvider =
                                    userController.filteredList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      userController.selectedProvider.value =
                                          serviceProvider;
                                      // update();
                                      userController.panelController.open();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.grey[400]
                                            : mainColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(8),
                                                height: Get.height * 0.10,
                                                width: Get.height * 0.10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.grey[200],
                                                  image: serviceProvider
                                                              .photoUrl ==
                                                          "none"
                                                      ? null
                                                      : DecorationImage(
                                                          image: Image.network(
                                                                  serviceProvider
                                                                      .photoUrl)
                                                              .image,
                                                          fit: BoxFit.cover),
                                                ),
                                                child:
                                                    serviceProvider.photoUrl ==
                                                            "none"
                                                        ? Center(
                                                            child: Text(
                                                                serviceProvider
                                                                    .fullName[0]
                                                                    .toLowerCase()),
                                                          )
                                                        : null,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "fullName".tr +
                                                        " : " +
                                                        "${serviceProvider.fullName.capitalizeFirst}",
                                                    style: mainStyle(
                                                      fontColor: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "profession".tr +
                                                        " : " +
                                                        "${serviceProvider.profession.capitalizeFirst}",
                                                    style: mainStyle(
                                                      fontColor: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        "${serviceProvider.position}",
                                                        style: mainStyle(
                                                          fontColor:
                                                              Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  FutureBuilder(
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(serviceProvider
                                                              .uid)
                                                          .collection("stars")
                                                          .get(),
                                                      builder:
                                                          (context, snapshot) {
                                                        double stars = 0;
                                                        List<dynamic> starSet;
                                                        if (!snapshot.hasData) {
                                                          stars = 0;
                                                        } else {
                                                          QuerySnapshot docs =
                                                              snapshot.data;
                                                          starSet = docs.docs;
                                                          starSet.forEach(
                                                              (element) {
                                                            stars += element[
                                                                "stars"];
                                                          });

                                                          if (starSet.length ==
                                                              0) {
                                                            stars = 0;
                                                          } else {
                                                            stars = stars /
                                                                starSet.length;
                                                          }
                                                        }
                                                        return Center(
                                                          child:
                                                              RatingBar.builder(
                                                            initialRating:
                                                                stars,
                                                            minRating: 0,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            glow: true,
                                                            ignoreGestures:
                                                                true,
                                                            onRatingUpdate:
                                                                (rating) {
                                                              //
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
        color: Colors.transparent,
        onPanelSlide: (double pos) {
          userController.changeFabHeight(pos);
        },
        minHeight: 0,
        maxHeight: userController.panelHeightOpen,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(48),
          topLeft: Radius.circular(48),
        ),
        controller: userController.panelController,
        panelBuilder: (ScrollController sc) => RegUserPanelWidget(sc: sc),
      ),
      // ),
    );
  }

  Future<String> printLocationName(Position position) async {
    if (position != null) {
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      List<Address> addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = addresses[1];
      // print(addresses.toString());
      print("${first.locality}  , ${first.adminArea}");
      // positionString.value = "${first.locality}  , ${first.adminArea}";
      return "${first.locality}  , ${first.adminArea}";
    } else {
      return "Unable to determin";
    }
  }
}
