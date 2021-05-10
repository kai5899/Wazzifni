import 'package:flutter/material.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:get/get.dart';

class AboutTheAppView extends StatelessWidget {
  const AboutTheAppView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: Get.height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/icons/location.png"),
                    Image.asset("assets/icons/24hours.png"),
                  ],
                ),
              ),
              Container(
                height: Get.height * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/icons/consult.png"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "App Version",
                  style: mainStyle(
                    fontColor: context.theme.primaryColor,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "1.0.0",
                  style: mainStyle(
                    fontSize: 18,
                    fontColor: context.theme.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Our project idea is a mobile application that will support people who have vocational skills like electric, painter, or carpenter and connect them with those who are in need for such services. Our application will also allow people to post job vacancies so that users can make use of our app to find jobs in certain places online.",
                  style: mainStyle(
                      fontSize: 24, fontColor: context.theme.primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Wazefini Team © 2021 ",
                  style: montserratStyle(
                      fontSize: 24, fontColor: Colors.grey[500]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
