import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhonePageTwo extends StatelessWidget {
  final Function onPressed;

  // final AuthController authController = Get.put(AuthController());
  final TextEditingController textEditingController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  // ignore: close_sinks
  final StreamController<ErrorAnimationType> errorController =
      StreamController();
  PhonePageTwo({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasError = false;
    String currentText = "";
    return Form(
      child: Column(
        children: [
          SizedBox(height: Get.height * 0.05),
          Padding(
            child: Row(
              children: [
                Text(
                  'Enter the code you recieved : ',
                  style: mainStyle(fontSize: 24),
                )
              ],
            ),
            padding: EdgeInsets.all(20),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: false,
                obscuringCharacter: '*',
                animationType: AnimationType.scale,
                validator: (v) {
                  if (v.length < 6) {
                    return "your code should have 6 digits";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  // shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(25),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  disabledColor: sColor3,
                  activeFillColor: hasError ? mainColor : sColor3,
                  selectedColor: sColor1,
                  selectedFillColor: Colors.white,
                  inactiveFillColor: mainColor,
                  inactiveColor: sColor3,
                  activeColor: mainColor,
                ),
                cursorColor: Colors.red,
                animationDuration: Duration(milliseconds: 300),
                textStyle: mainStyle(
                  fontColor: mainColor,
                  fontSize: 24,
                ),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onChanged: (value) {
                  print(value);
                  // setState(() {
                  currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              )),
          SizedBox(height: Get.height * 0.05),
          GetBuilder(
            init: AuthController(),
            builder: (controller) => Center(
              child: Text(controller.phoneAuthStatus.value),
            ),
          ),
          Center(
            child: InkWell(
              child: Container(
                height: 70,
                width: Get.width * 0.5,
                child: Center(
                  child: Text(
                    "Verify",
                    style: mainStyle(
                      fontColor: Colors.white,
                      fontSize: 36,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(36)),
              ),
              onTap: () {
                // authController.signIn(currentText).then((value) {
                if (authController.phoneAuthStatus.value ==
                    "Your account is successfully verified") {
                  onPressed();
                } else {
                  authController.signIn(currentText).then((value) {
                    onPressed();
                  });
                }

                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}
