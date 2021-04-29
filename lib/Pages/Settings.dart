import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Services/LocalizationServices.dart';
import 'package:locateme/Services/ThemServices.dart';
import 'package:locateme/Controllers/SettingsController.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsView extends StatelessWidget {
  SettingsView();

  final SettingsController settingsController = Get.put(SettingsController());
  final AuthController _authController = Get.put(AuthController());
  final AppController _appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),

            //language

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[200],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListTile(
                  title: Text(
                    "appLanguage".tr,
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    getLanguage().tr,
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  trailing: Icon(
                    Icons.language,
                    size: 36,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Alert(
                      context: context,
                      style: AlertStyle(),
                      type: AlertType.info,
                      title: "appLanguage".tr,
                      desc: "appLangDesc".tr,
                      buttons: [
                        DialogButton(
                          child: Text(
                            "cancel".tr,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          color: Colors.red,
                          radius: BorderRadius.circular(24.0),
                        ),
                        DialogButton(
                          child: Text(
                            getOppLanguage().tr,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            LocalizationService()
                                .changeLocale(getOppLanguage());
                            Get.back();
                          },
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                          radius: BorderRadius.circular(24.0),
                        ),
                      ],
                    ).show();
                  },
                ),
              ),
            ),

            SizedBox(height: Get.height * 0.02),

            //dark mode

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListTile(
                  title: Text(
                    "darkMode".tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    isDarkModeOn(),
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  trailing: DayNightSwitcher(
                    onStateChanged: (value) {
                      ThemeService().switchTheme();
                      SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.dark.copyWith(
                              statusBarColor: value
                                  ? Color(0xFF050111)
                                  : Colors.white, // Color for Android

                              statusBarBrightness: Brightness
                                  .dark // Dark == white status bar -- for IOS.
                              ));
                      // print(value);
                    },
                    isDarkModeEnabled: ThemeService().isDarkMode(),
                  ),
                  // onTap: ThemeService().switchTheme,
                ),
              ),
            ),
            _authController.localUser["type"] == "Regular User"
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 32, 32, 0),
                    child: Text(
                      "HomePageView".tr,
                      textAlign: TextAlign.start,
                      style: mainStyle(
                        fontColor: context.theme.primaryColor,
                        fontSize: 24,
                      ),
                    ),
                  )
                : Container(),
            _authController.localUser["type"] == "Regular User"
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[350],
                              ),
                              height: 40,
                              width: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedContainer(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: settingsController
                                                .optionSelected.value ==
                                            0
                                        ? context.theme.primaryColor
                                        : Colors.grey[350],
                                  ),
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                settingsController.changeOption(0);
                              },
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity:
                                    settingsController.optionSelected.value == 0
                                        ? 1
                                        : 0.2,
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: mainColor.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/mapStyles/map.png",
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.xor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "mapView".tr,
                              style: mainStyle(
                                fontColor: context.theme.primaryColor,
                                fontSize: 24,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[350],
                              ),
                              height: 40,
                              width: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedContainer(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: settingsController
                                                .optionSelected.value ==
                                            1
                                        ? context.theme.primaryColor
                                        : Colors.grey[350],
                                  ),
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                settingsController.changeOption(1);
                              },
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity:
                                    settingsController.optionSelected.value != 0
                                        ? 1
                                        : 0.2,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: ListView.builder(
                                    controller:
                                        settingsController.smallListController,
                                    itemCount: 4,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 150 / 4,
                                        width: 150 * 0.85,
                                        decoration: BoxDecoration(
                                          color: index % 2 == 0
                                              ? Colors.white
                                              : mainColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "listView".tr,
                              style: mainStyle(
                                fontColor: context.theme.primaryColor,
                                fontSize: 24,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: Get.height * 0.02),
            //drawer background Color
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[400],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListTile(
                  onTap: () {
                    // print(_appController.getDrawerColor());
                    // print(Colors.red.value);
                    // _appController.updateDrawerColor(Colors.red);
                    _appController.colorPickerDialog(context);
                  },
                  title: Text(
                    "drawerBackgroundColor".tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    "clickToChange".tr,
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: _appController.drawerColor.value,
                  ),
                  // onTap: ThemeService().switchTheme,
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            //drawer background Color reset
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[500],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListTile(
                  onTap: () {
                    // print(_appController.getDrawerColor());
                    // print(Colors.red.value);
                    // _appController.updateDrawerColor(Colors.red);
                    _appController.updateDrawerColor(mainColor);
                  },
                  title: Text(
                    "resetDrawerBackgroundColor".tr,
                    style: mainStyle(fontColor: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    "clickToChange".tr,
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: mainColor,
                  ),
                  // onTap: ThemeService().switchTheme,
                ),
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset("assets/icons/consult.png").image),
              ),
            ))
          ],
        ),
      ),
    );
  }

  String getLanguage() {
    return Get.locale.languageCode == "en" ? "English" : "Arabic";
  }

  String getOppLanguage() {
    return Get.locale.languageCode != "en" ? "English" : "Arabic";
  }

  String isDarkModeOn() {
    return ThemeService().isDarkMode() ? "On" : "Off";
  }
}
