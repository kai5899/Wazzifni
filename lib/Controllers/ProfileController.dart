import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  RxnString photoUrl = RxnString();

  Rx<UploadTask> uploadTask = Rx<UploadTask>(null);
  Rx<DateTime> selectedDate = Rx<DateTime>(null);

  PickedFile imageFile;
  final _picker = ImagePicker();
  @override
  onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
  }

  Future getImage({String userID, AuthController authController}) async {
    imageFile = await _picker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      imageCache.clear();
      uploadProfileFile(userID: userID, authController: authController);
      return photoUrl.value;
    } else {
      return "error";
    }
  }

  Future uploadProfileFile(
      {String userID, AuthController authController}) async {
    String fileName = userID;
    Reference reference =
        FirebaseStorage.instance.ref().child("users/" + fileName);
    uploadTask.value = reference.putData(await imageFile.readAsBytes());

    uploadTask.value.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        photoUrl.value = downloadUrl;
        imageFile = null;
        imageCache.clear();
        imageCache.clearLiveImages();
        authController.updateRegUserPhoto(downloadUrl);
        update();
      }, onError: (err) {
        print("we have error :" + err.toString());
        // Fluttertoast.showToast(msg: 'This file is not an image');
      });
    });
  }

  String bytesTransferred(TaskSnapshot snapshot) {
    double res = (snapshot.bytesTransferred / 1024.0) / 1000;
    double res2 = (snapshot.totalBytes / 1024.0) / 1000;
    return '${res.toStringAsFixed(2)}/${res2.toStringAsFixed(2)}';
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
}
