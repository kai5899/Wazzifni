
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/JobsController.dart';
import 'package:locateme/Widgets/CustomInputField.dart';

class AddReq extends StatelessWidget {
  AddReq();

  final JobsController jobsController = Get.put(JobsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Requirement",
              style: mainStyle(
                fontSize: 24,
                fontColor: context.theme.primaryColor,
              ),
            ),
            FieldEdited(
              maxLine: null,
              isPassword: false,
              color: mainColor,
              textColor: Colors.white,
              icon: Icons.description,
              label: "Requirement",
              controller: jobsController.reqController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    if (jobsController.reqController.text.length != 0) {
                      jobsController.jobRequirementss
                          .add(jobsController.reqController.text);
                      jobsController.reqController.clear();
                      Get.back();
                    } else {
                      print("empty text");
                    }
                  },
                  child: Icon(Icons.check, color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

