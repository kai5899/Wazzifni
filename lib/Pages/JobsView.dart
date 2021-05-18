import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/JobsController.dart';
import 'package:locateme/Widgets/Jobs/AddJobView.dart';
import 'package:locateme/Widgets/Jobs/JobOfferView.dart';
import 'package:locateme/Widgets/Jobs/JobOfferViewByYou.dart';

class JobsView extends StatelessWidget {
  JobsView();
  final AuthController _authController = Get.put(AuthController());
  // final JobsController jobsController = Get.put(JobsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: JobsController(),
      builder: (JobsController jobsController) => Container(
        child: Scaffold(
          body: Column(
            children: [
              Text(
                "last update on".tr +
                    "\n" +
                    jobsController.time.value
                        .toLocal()
                        .toString()
                        .substring(0, 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Row(
                      children: [
                        Text(
                          "Filter :".tr,
                          style: mainStyle(
                              fontSize: 24,
                              fontColor: context.theme.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Select item".tr,
                        style: mainStyle(
                            fontSize: 24,
                            fontColor: context.theme.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                      value: jobsController.selectedType.value,
                      onChanged: (String value) {
                        jobsController.changeType(value);
                        jobsController.filter();
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * 0.3,
                      child: ElevatedButton(
                          onPressed: () {
                            jobsController.resetFilter();
                          },
                          child: Center(
                            child: Text(
                              "Reset Filter".tr,
                              style: mainStyle(
                                  fontColor: context.theme.accentColor),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: mainColor,
                  ),
                  height: 65,
                  child: Padding(
                    child: TextFormField(
                      onChanged: (text) {
                        jobsController.filterBylocation(text);
                      },
                      cursorColor: Colors.white,
                      style: mainStyle(
                        fontColor: context.theme.accentColor,
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.search,
                            color: context.theme.accentColor,
                            size: 36,
                          ),
                        ),
                        labelText: "Enter a location name or title",
                        labelStyle: mainStyle(
                          fontColor: context.theme.accentColor,
                          fontSize: 20,
                        ),
                        fillColor: Colors.white,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                  ),
                ),
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
              ),
              Padding(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: mainColor,
                  ),
                  height: 65,
                  child: Padding(
                    child: TextFormField(
                      onChanged: (text) {
                        jobsController.filterBySalary(text);
                      },
                      cursorColor: Colors.white,
                      style: mainStyle(
                        fontColor: context.theme.accentColor,
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.search,
                            color: context.theme.accentColor,
                            size: 36,
                          ),
                        ),
                        labelText: "Enter minimum salary",
                        labelStyle: mainStyle(
                          fontColor: context.theme.accentColor,
                          fontSize: 20,
                        ),
                        fillColor: Colors.white,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                  ),
                ),
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
              ),
              Center(
                child: Text(
                  "Found ".tr +
                      "${jobsController.filteredList.length} " +
                      "Job offer".tr,
                  style: mainStyle(
                    fontSize: 24,
                    // fontColor: context.theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
              jobsController.filteredList.length == 0
                  ? Center(
                      child: Text(
                        "no offers".tr,
                        style: mainStyle(fontSize: 24),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: jobsController.filteredList.length,
                        itemBuilder: (context, index) => OpenContainer(
                          transitionDuration: Duration(milliseconds: 400),
                          transitionType: ContainerTransitionType.fadeThrough,
                          openBuilder: (BuildContext context, VoidCallback _) {
                            return _authController.user.uid ==
                                    jobsController.filteredList[index].posterId
                                ? JobOfferViewByYouModel(
                                    jobOffer:
                                        jobsController.filteredList[index],
                                    index: index,
                                  )
                                : JobOfferViewModel(
                                    jobOffer:
                                        jobsController.filteredList[index],
                                    index: index,
                                  );
                          },
                          closedElevation: 0,
                          closedShape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                            ),
                          ),
                          closedColor: context.theme.scaffoldBackgroundColor,
                          closedBuilder: (BuildContext context,
                              VoidCallback openContainer) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  jobsController.filteredList[index].jobTitle
                                      .capitalizeFirst,
                                  style: mainStyle(
                                    fontSize: 24,
                                    fontColor: context.theme.primaryColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "location".tr +
                                          " : " +
                                          jobsController.filteredList[index]
                                              .location.capitalizeFirst,
                                      style: mainStyle(
                                        fontSize: 16,
                                        fontColor: context.theme.primaryColor,
                                      ),
                                    ),
                                    Text(
                                      "posted on".tr +
                                          " : " +
                                          DateTime.fromMillisecondsSinceEpoch(
                                                  jobsController
                                                      .filteredList[index].id)
                                              .toLocal()
                                              .toString()
                                              .substring(0, 16),
                                      style: mainStyle(
                                        fontSize: 16,
                                        fontColor: context.theme.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                trailing: _authController.user.uid ==
                                        jobsController
                                            .filteredList[index].posterId
                                    ? Text("by you".tr)
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
            ],
          ),
          floatingActionButton: _authController.localUser["type"] ==
                  "Regular User"
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(360),
                      child: GestureDetector(
                        onTap: () {
                          jobsController.getOffers();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: sColor3,
                          child: Center(
                              child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OpenContainer(
                      transitionDuration: Duration(milliseconds: 400),
                      transitionType: ContainerTransitionType.fadeThrough,
                      openBuilder: (BuildContext context, VoidCallback _) {
                        jobsController.jobRequirementss.clear();
                        return AddJobView();
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
                          height: 75,
                          width: 75,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: context.theme.accentColor,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )
              : Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(360),
                  child: GestureDetector(
                    onTap: () {
                      jobsController.getOffers();
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: sColor3,
                      child: Center(
                          child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
