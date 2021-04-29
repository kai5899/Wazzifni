import 'package:flutter/material.dart';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Row(
                        children: [
                          Text(
                            "Filter :",
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
                                "Refresh",
                                style: mainStyle(
                                    fontColor: context.theme.accentColor),
                              ),
                            )),
                      ),
                      Container(
                        width: Get.width * 0.3,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  context.theme.primaryColor),
                            ),
                            onPressed: () {
                              userController.resetFilter();
                            },
                            child: Center(
                              child: Text(
                                "Reset Filter",
                                style: mainStyle(
                                    fontColor: context.theme.accentColor),
                              ),
                            )),
                      ),
                    ],
                  ),
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
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: userController.filteredList.length,
                              itemBuilder: (context, index) {
                                ServiceProvider serviceProvider =
                                    userController.filteredList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
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
                                                  Text(
                                                    "Name : ${serviceProvider.fullName.capitalizeFirst}",
                                                    style: mainStyle(
                                                      fontColor: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Profession : ${serviceProvider.profession.capitalizeFirst}",
                                                    style: mainStyle(
                                                      fontColor: Colors.white,
                                                      fontSize: 24,
                                                    ),
                                                  )
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
            AnimatedPositioned(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: mainColor,
                child: Center(
                  child: Text(
                    "${userController.markers.length}",
                    style: mainStyle(
                      fontColor: sColor3,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              duration: Duration(milliseconds: 10),
              bottom: userController.fabHeight.value,
              right: 10,
            )
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
}
