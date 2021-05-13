import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/JobsController.dart';
import 'package:locateme/Models/JobOffer.dart';
import 'package:get/get.dart';
import 'package:locateme/Services/FirestoreServices.dart';
import 'package:url_launcher/url_launcher.dart';

class JobOfferViewModel extends StatelessWidget {
  final JobOffer jobOffer;
  final bool byYou;
  final int index;

  final ScrollController sc = ScrollController();
  final JobsController jobsController = Get.put(JobsController());

  JobOfferViewModel({this.jobOffer, this.byYou, this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          jobOffer.jobTitle.capitalizeFirst,
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
      body: SingleChildScrollView(
        controller: sc,
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                jobOffer.location,
                style: mainStyle(
                  fontColor: context.theme.primaryColor,
                  fontSize: 24,
                ),
              ),
            ),
            AbsorbPointer(
              child: Center(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: Get.width * 0.8,
                  height: Get.height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: mainColor,
                  ),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId("job position"),
                        position: LatLng(
                          jobOffer.latitude,
                          jobOffer.longitude,
                        ),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        jobOffer.latitude,
                        jobOffer.longitude,
                      ),
                      zoom: 13.5,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Job Description",
                style: mainStyle(
                  fontColor: context.theme.primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              child: Text(
                jobOffer.jobDescription,
                style: mainStyle(
                  fontColor: context.theme.primaryColor,
                  fontSize: 24,
                ),
              ),
            ),

            //j  o  b type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Job Type",
                    style: mainStyle(
                      fontColor: context.theme.primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                  child: Text(
                    jobOffer.jobType,
                    style: mainStyle(
                      fontColor: context.theme.primaryColor,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Salary",
                style: mainStyle(
                  fontColor: context.theme.primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              child: Text(
                jobOffer.salary.toString() + " " + jobOffer.currency,
                style: mainStyle(
                  fontColor: context.theme.primaryColor,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "List of Requriments",
                style: mainStyle(
                  fontColor: context.theme.primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
            // Text(jobOffer.jobRequirements.toString()),
            ListView.builder(
              controller: sc,
              shrinkWrap: true,
              itemCount: jobOffer.requirements.length,
              itemBuilder: (context, index) => ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.theme.primaryColor,
                  ),
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: context.theme.accentColor,
                    ),
                  ),
                ),
                title: Text(
                  jobOffer.requirements[index].toString().capitalizeFirst,
                  style: mainStyle(
                    fontSize: 24,
                    fontColor: context.theme.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            byYou
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "this offer was poster by you",
                          style: mainStyle(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("offers")
                                        .doc(jobOffer.id.toString())
                                        .delete()
                                        .then((value) {
                                      jobsController.offers.remove(jobOffer);
                                      jobsController.filteredList
                                          .remove(jobOffer);
                                      Get.back();
                                      jobsController.update();
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                  )
                : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "contaict via Whatsapp",
                          style: mainStyle(),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.whatsapp,
                              size: 36,
                              color: Color(0xff075e54),
                            ),
                            onPressed: () async {
                              // String posterNumber  =
                              Map<String, dynamic> user =
                                  await FirestoreService()
                                      .getUserById(jobOffer.posterId);
                              var whatsappUrl =
                                  "whatsapp://send?phone=${user["phoneNumber"]}";
                              try {
                                launch(whatsappUrl);
                                // throw ("error");
                              } catch (error) {
                                Get.snackbar(
                                  "Error Occured",
                                  error.toString(),
                                  snackPosition: SnackPosition.TOP,
                                  duration: Duration(seconds: 3),
                                  overlayColor: Colors.white.withOpacity(0.8),
                                  overlayBlur: 1,
                                  // borderRadius: 36,
                                  forwardAnimationCurve: Curves.easeInOutBack,
                                  reverseAnimationCurve: Curves.easeInCubic,
                                  icon: Icon(
                                    Icons.warning,
                                    color: sColor3,
                                  ),
                                  shouldIconPulse: true,
                                  snackStyle: SnackStyle.FLOATING,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
