import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';

class PhonePageOne extends StatelessWidget {
  final Function onPressed;
  final AuthController authController = Get.put(AuthController());

  final _phoneController = TextEditingController();
  PhonePageOne({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      // color: Colors.blueGrey.withOpacity(0.2),
      child: Column(
        children: [
          SizedBox(
            height: Get.height * 0.03,
          ),

          //phone title
          Padding(
            child: Row(
              children: [
                Text(
                  'Regestering...',
                  style: mainStyle(fontSize: 24),
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 20, right: 20),
          ),

          //phone subtitle
          Padding(
            child: Row(
              children: [
                Text(
                  'Enter your phone number.',
                  style: mainStyle(fontSize: 36),
                )
              ],
            ),
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          ),
          SizedBox(
            height: Get.height * 0.1,
          ),

          //phone field
          Padding(
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Enter mobile number",
                  labelStyle: mainStyle(),
                  fillColor: Colors.white,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text("+961-")),
              style: mainStyle(
                fontSize: 36,
              ),
              keyboardType: TextInputType.number,
              controller: _phoneController,
            ),
            padding: EdgeInsets.only(left: 20, right: Get.width * 0.4),
          ),

          //divider
          Padding(
            child: Divider(
              thickness: 2,
              color: mainColor,
            ),
            padding: EdgeInsets.only(left: 20, right: Get.width * 0.4),
          ),
          SizedBox(
            height: Get.height * 0.1,
          ),

          //button
          Padding(
            child: InkWell(
              child: Container(
                height: 70,
                child: Center(
                  child: Text(
                    "Get OTP",
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
                print(_phoneController.text);
                authController.verifyPhoneNumber(
                    context: context, phone: "+961" + _phoneController.text).then((value) {
                  onPressed();
                });
                print(authController.phoneAuthStatus);

              },
            ),
            padding: EdgeInsets.only(left: 20, right: Get.width * 0.4),
          ),
        ],
      ),
    );
  }
}
