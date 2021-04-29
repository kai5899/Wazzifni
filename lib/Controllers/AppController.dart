import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Services/ThemServices.dart';
import 'package:locateme/Widgets/CustomDrawerWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class AppController extends GetxController with SingleGetTickerProviderMixin {
  final AdvancedDrawerController drawerController = AdvancedDrawerController();
  AnimationController controller;

  GetStorage storage = GetStorage();

  Rx<Position> currentPosition = Rx<Position>(null);

  RxInt selectedPage = RxInt(0);

  RxBool expanded = RxBool(true);

  Rx<Color> drawerColor = Rx<Color>(mainColor);
  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 400),
        vsync: this);

    checkPermissions();
    getDrawerColor();
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
    drawerController.dispose();
  }

  getDrawerColor() {
    int a = storage.read("drawerColor");
    drawerColor.value = Color(a);
  }

  updateDrawerColor(Color newColor) {
    drawerColor.value = newColor;
    update();
    storage.write("drawerColor", newColor.value);
  }

  changePage(int newIndex) {
    selectedPage.value = newIndex;
    update();
    handleMenuButtonPressed();
  }

  void handleMenuButtonPressed() {
    expanded.value ? controller.forward() : controller.reverse();

    if (expanded.value) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: drawerColor.value, // Color for Android

          statusBarBrightness:
              Brightness.dark // Dark == white status bar -- for IOS.
          ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: ThemeService().isDarkMode()
              ? Color(0xFF050111)
              : Colors.white, // Color for Android

          statusBarBrightness:
              Brightness.dark // Dark == white status bar -- for IOS.
          ));
    }
    expanded.value = !expanded.value;
    drawerController.toggleDrawer();
  }

  checkPermissions() async {
    var status = await Permission.location.status;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      if (!status.isGranted) {
        print("permission not granted");
        Permission.location.request();
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      } else {
        determinePosition();
      }
    } else {
      Get.snackbar(
        "Location Services are Disabled",
        "Enable them to use location features",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        overlayColor: Colors.white.withOpacity(0.8),
        overlayBlur: 1,
        // borderRadius: 36,
        forwardAnimationCurve: Curves.easeInOutBack,
        reverseAnimationCurve: Curves.easeInCubic,
        icon: Icon(
          Icons.warning,
          color: sColor3,
        ),
        shouldIconPulse: true,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    //

    currentPosition.value = await Geolocator.getCurrentPosition();
    print(currentPosition.value);
    // setState(() {});
  }

  Future<bool> colorPickerDialog(BuildContext context) async {
    return ColorPicker(
      color: drawerColor.value,
      onColorChanged: (Color color) {
        updateDrawerColor(color);
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
      ),
      subheading: Text(
        'Select color shade',
      ),
      // recentColors: [mainColor],
      // showRecentColors: true,
      showMaterialName: false,
      showColorName: false,
      showColorCode: false,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: false,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }
}
