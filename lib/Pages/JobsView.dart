import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/JobsController.dart';
import 'package:locateme/Widgets/Jobs/AddJobView.dart';
import 'package:locateme/Widgets/Jobs/JobOfferView.dart';

class JobsView extends StatelessWidget {
  JobsView();
  final JobsController jobsController = Get.put(JobsController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: Scaffold(
          body: jobsController.offers.length == 0
              ? Center(
                  child: Text(
                    "no offers".tr,
                    style: mainStyle(fontSize: 24),
                  ),
                )
              : Column(
                  children: [
                    Text(
                      "last update on".tr +"\n"+
                          jobsController.time.value
                              .toLocal()
                              .toString()
                              .substring(0, 16),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: jobsController.offers.length,
                        itemBuilder: (context, index) => OpenContainer(
                          transitionDuration: Duration(milliseconds: 400),
                          transitionType: ContainerTransitionType.fadeThrough,
                          openBuilder: (BuildContext context, VoidCallback _) {
                            return JobOfferViewModel(
                              jobOffer: jobsController.offers[index],
                              byYou: _authController.user.uid ==
                                  jobsController.offers[index].posterId,
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
                              child: Slidable(
                                actionPane: SlidableStrechActionPane(),
                                secondaryActions: _authController.user.uid ==
                                        jobsController.offers[index].posterId
                                    ? [
                                        IconSlideAction(
                                          caption: 'delete'.tr,
                                          color: Colors.red,
                                          icon: Icons.delete,
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("offers")
                                                .doc(jobsController
                                                    .offers[index].id
                                                    .toString())
                                                .delete()
                                                .then((value) {
                                              jobsController.offers
                                                  .removeAt(index);
                                            });
                                          },
                                        ),
                                      ]
                                    : null,
                                child: ListTile(
                                  title: Text(
                                    jobsController
                                        .offers[index].jobTitle.capitalizeFirst,
                                    style: mainStyle(
                                      fontSize: 24,
                                      fontColor: context.theme.primaryColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    jobsController
                                        .offers[index].location.capitalizeFirst,
                                    style: mainStyle(
                                      fontSize: 16,
                                      fontColor: context.theme.primaryColor,
                                    ),
                                  ),
                                  trailing: _authController.user.uid ==
                                          jobsController.offers[index].posterId
                                      ? Text("by you".tr)
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        ),
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
