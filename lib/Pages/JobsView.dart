import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
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
                    "no offers",
                    style: mainStyle(fontSize: 24),
                  ),
                )
              : Column(
                  children: [
                    Text(
                      "Last update on\n" +
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
                                    ? Text("by you")
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
          floatingActionButton:
              _authController.localUser["type"] == "Regular User"
                  ? OpenContainer(
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
                  : null,
        ),
      ),
    );
  }
}
