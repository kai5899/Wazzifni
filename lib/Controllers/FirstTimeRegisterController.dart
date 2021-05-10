import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Models/ServiceProvider.dart';
import 'package:locateme/Models/UserModel.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FirstTimeController extends GetxController {
  Rx<Position> currentPosition = Rx<Position>(null);
  Rx<DateTime> selectedDate = Rx<DateTime>(null);

  RxnString userType = RxnString();
  RxnString profession = RxnString();

  Rx<SfRangeValues> values = Rx<SfRangeValues>(SfRangeValues(40.0, 80.0));

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  RxnString photoUrl = RxnString();

  Rx<UploadTask> uploadTask = Rx<UploadTask>(null);

  PickedFile imageFile;
  final _picker = ImagePicker();
  @override
  onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
    determinePosition();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
  }

  void pickDateDialog(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        //which date will display when user open the picker
        firstDate: DateTime(1950),
        //what will be the previous supported year in picker
        lastDate:
            DateTime.now(), //what will be the up to supported date in picker
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: mainColor,
              accentColor: sColor3,
              colorScheme: ColorScheme.light(primary: mainColor),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child,
          );
        }).then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      selectedDate.value = pickedDate;
    });
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

  changeProfession(String newProf) {
    profession.value = newProf;
  }

  changeType(String newType) {
    userType.value = newType;
  }

  save(User user, AuthController _authController) {
    if (userType.value == "Regular User") {
      UserModel userz = UserModel(
          fullName: nameController.text,
          birthDay: selectedDate.value.day.toString() +
              "/" +
              selectedDate.value.month.toString() +
              "/" +
              selectedDate.value.year.toString(),
          latitude: currentPosition.value.latitude.toString(),
          longitude: currentPosition.value.longitude.toString(),
          phoneNumber: user.phoneNumber,
          uid: user.uid,
          photoUrl: photoUrl.value == null ? "none" : photoUrl.value,
          type: "Regular User");
     
      _authController.firestoreService.createRegularUser(userz);
 _authController.saveRegUserLocally(userz);
      _authController.localUser.value = userz.toJson();
    } else {
      ServiceProvider userz = ServiceProvider(
          fullName: nameController.text,
          bio: bioController.text,
          available: true,
          birthDay: selectedDate.value.day.toString() +
              "/" +
              selectedDate.value.month.toString() +
              "/" +
              selectedDate.value.year.toString(),
          latitude: currentPosition.value.latitude.toString(),
          longitude: currentPosition.value.longitude.toString(),
          phoneNumber: _authController.user.phoneNumber,
          uid: user.uid,
          photoUrl: photoUrl.value == null ? "none" : photoUrl.value,
          type: "Service Provider",
          priceRange:
              "(${(values.value.start * 1000).toStringAsFixed(0)} : ${(values.value.end * 1000).toStringAsFixed(0)})",
          profession: profession.value);

      _authController.firestoreService.createServiceProvider(userz);
      _authController.saveProviderLocally(userz);
      _authController.localUser.value = userz.toJson();
    }
  }

  Future getImage({
    String userID,
  }) async {
    imageFile = await _picker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      uploadProfileFile(userID: userID);
    }
  }

  Future uploadProfileFile({String userID}) async {
    String fileName = userID;
    Reference reference =
        FirebaseStorage.instance.ref().child("users/" + fileName);
    uploadTask.value = reference.putData(await imageFile.readAsBytes());

    uploadTask.value.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        photoUrl.value = downloadUrl;
        update();
      }, onError: (err) {
        // Fluttertoast.showToast(msg: 'This file is not an image');
      });
    });
  }

  String bytesTransferred(TaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalBytes / 1024.0) / 1000;
    return '${res.toStringAsFixed(2)}/${res2.toStringAsFixed(2)}';
  }

  void changeValues(value) {
    values.value = value;
  }
}
