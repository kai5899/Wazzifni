import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:locateme/Models/ServiceProvider.dart';
import 'package:locateme/Models/UserModel.dart';
import 'package:locateme/Services/FirestoreServices.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GetStorage storage = GetStorage();
  Rxn<User> _firebaseUser = Rxn<User>();

  FirestoreService firestoreService = FirestoreService();

  RxMap<String, dynamic> localUser = RxMap<String, dynamic>({});

  User get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    print("we are in OnInit");
    // getUserData();
    _firebaseUser.value = auth.currentUser;
    _firebaseUser.bindStream(auth.authStateChanges());
    getUserData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  saveRegUserLocally(UserModel userModel) {
    storage.write("currentUser", userModel.toJson());
  }

  updateRegUserName(String newName) {
    localUser.update("fullName", (old) => newName);

    storage.write("currentUser", localUser);
    // update();
    firestoreService.updateUser(_firebaseUser.value.uid, {"fullName": newName});
  }

  updateBio(String newBio) {
    localUser.update("bio", (old) => newBio);

    storage.write("currentUser", localUser);
    // update();
    firestoreService.updateUser(_firebaseUser.value.uid, {"bio": newBio});
  }

  updateAvailable(bool newVal) {
    localUser.update("available", (old) => newVal);

    storage.write("currentUser", localUser);
    // update();
    firestoreService.updateUser(_firebaseUser.value.uid, {"available": newVal});
  }

  updateRegUserBirthDay(String newBd) {
    localUser["birthDay"] = newBd;
    storage.write("birthDay", localUser);
    update();
    firestoreService.updateUser(_firebaseUser.value.uid, {"birthDay": newBd});
  }

  updateRegUserPhoto(String newUrl) {
    localUser["photoUrl"] = newUrl;
    storage.write("currentUser", localUser);
    update();
    firestoreService.updateUser(_firebaseUser.value.uid, {"photoUrl": newUrl});
  }

  saveProviderLocally(ServiceProvider provider) {
    print("saving locally");
    storage.write("currentUser", provider.toJson());
  }

  clearSavedUser() {
    localUser.value = {};
    storage.remove("currentUser");
  }

  Map<String, dynamic> readSavedUser() {
    print("the user is " + storage.read("currentUser").toString());
    return storage.read("currentUser");
  }

  getUserData() async {
    Map<String, dynamic> data;
    data = readSavedUser();

    if (data != null) {
      localUser.value = data;
    } else if (data == null) {
      print("first check");
      data = await firestoreService.getUserById(user.uid);
    }

    if (data == null) {
      print("second check");
      localUser.value = {};
    } else if (data != null) {
      localUser.value = data;
      storage.write("currentUser", data);
    }
    // print("the data is " + localUser.toString());
    // localUser.value = data;
  }

  //for phone authentication

  var verificationId = "".obs;
  var otp = "".obs;
  var phoneAuthStatus = "".obs;
  //phone auth functionnsss

  Future<void> verifyPhoneNumber({BuildContext context, String phone}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        phoneAuthStatus.value = "Your account is successfully verified";
        auth.signInWithCredential(authCredential);
      },
      verificationFailed: (FirebaseAuthException authException) {
        phoneAuthStatus.value =
            "Authentication failed " + authException.message;
      },
      codeSent: (String verId, [int forceCodeResent]) {
        print(verId);
        print("code sent");
        verificationId.value = verId;
        phoneAuthStatus.value = "OTP has been successfully send";

        // otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
        phoneAuthStatus.value = "TIMEOUT";
      },
    );
  }

  Future<void> signIn(String otp) async {
    print("otp :" + otp);
    print("verfivationId.value : " + verificationId.value);
    await auth
        .signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: otp,
        ))
        .then((v) => getUserData());
  }

  signOut() async {
    await auth.signOut();
    clearSavedUser();
  }
}
