import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/JobsController.dart';
import 'package:locateme/Controllers/AppController.dart';
import 'package:locateme/Widgets/CustomInputField.dart';

import 'AddRequirementView.dart';

class AddJobView extends StatelessWidget {
  AddJobView();
  final JobsController jobsController = Get.put(JobsController());
  final AuthController _authController = Get.put(AuthController());
  final AppController regUserAppController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Post A New Job Offer",
            style: mainStyle(
              fontColor: context.theme.primaryColor,
              fontSize: 30,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: context.theme.primaryColor,
              size: 36,
            ),
          ),
        ),
        body: ListView(
          children: [
            FieldEdited(
              maxLine: null,
              isPassword: false,
              color: mainColor,
              textColor: Colors.white,
              icon: Icons.title,
              label: "Job Title",
              controller: jobsController.titleController,
            ),
            FutureBuilder(
              future: jobsController.printLocationName(
                  regUserAppController.currentPosition.value),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: context.theme.primaryColor,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          snapshot.data,
                          style: mainStyle(
                            fontColor: context.theme.primaryColor,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.25,
                right: Get.width * 0.25,
                top: 10,
                bottom: 10,
              ),
              child: DropdownButton<String>(
                hint: Text(
                  "Select item",
                  style: mainStyle(
                      fontSize: 24,
                      fontColor: context.theme.primaryColor,
                      fontWeight: FontWeight.w500),
                ),
                value: jobsController.selectedType.value,
                onChanged: (String value) {
                  jobsController.changeType(value);
                },
                items: jobsController.jobTypes.map((String user) {
                  return DropdownMenuItem<String>(
                    value: user,
                    child: Row(
                      children: <Widget>[
                        Text(
                          user,
                          style: mainStyle(
                              fontSize: 24,
                              fontColor: context.theme.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            FieldEdited(
              maxLine: 5,
              isPassword: false,
              color: mainColor,
              textColor: Colors.white,
              icon: Icons.description,
              label: "Job Descritpion",
              controller: jobsController.descriptionController,
            ),
            FieldEdited(
              isPassword: false,
              color: mainColor,
              textColor: Colors.white,
              icon: Icons.monetization_on,
              type: TextInputType.number,
              label: "Job Salary",
              controller: jobsController.salaryController,
            ),
            FieldEdited(
              isPassword: false,
              color: mainColor,
              textColor: Colors.white,
              icon: Icons.monetization_on,
              type: TextInputType.text,
              label: "Salary currency",
              controller: jobsController.currencyController,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Job Requirements",
                    style: mainStyle(
                      fontSize: 24,
                      fontColor: context.theme.primaryColor,
                    ),
                  ),
                  OpenContainer(
                    transitionDuration: Duration(milliseconds: 400),
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return AddReq();
                    },
                    closedElevation: 6.0,
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(360),
                      ),
                    ),
                    closedColor: mainColor,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: context.theme.accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: jobsController.jobRequirementss.length == 0
                  ? Center(
                      child: Text(
                        "no requirements yet . Add some!",
                        style: mainStyle(
                          fontSize: 24,
                          fontColor: context.theme.primaryColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: jobsController.jobRequirementss.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: mainColor,
                          ),
                          height: 20,
                          width: 20,
                        ),
                        title: Text(
                          jobsController.jobRequirementss[index]
                              .toString()
                              .capitalizeFirst,
                          style: mainStyle(
                            fontSize: 24,
                            fontColor: context.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    jobsController.clearAddOffer();
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
                    jobsController.addOffer(_authController.user.uid,
                        regUserAppController.currentPosition.value);
                    Get.back();
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
