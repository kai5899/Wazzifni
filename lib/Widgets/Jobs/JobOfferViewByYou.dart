import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/JobsController.dart';
import 'package:locateme/Models/JobOffer.dart';
import 'package:get/get.dart';
import 'package:locateme/Widgets/CustomInputField.dart';

class JobOfferViewByYouModel extends StatefulWidget {
  final JobOffer jobOffer;
  final int index;

  JobOfferViewByYouModel({this.jobOffer, this.index});

  @override
  _JobOfferViewByYouModelState createState() => _JobOfferViewByYouModelState();
}

class _JobOfferViewByYouModelState extends State<JobOfferViewByYouModel> {
  final ScrollController sc = ScrollController();

  final JobsController jobsController = Get.put(JobsController());

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController salaryController;
  TextEditingController currencyController;
  TextEditingController reqController = TextEditingController();

  String jobType;

  List<dynamic> reqs;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.jobOffer.jobTitle);
    descriptionController =
        TextEditingController(text: widget.jobOffer.jobDescription);

    salaryController =
        TextEditingController(text: widget.jobOffer.salary.toString());
    currencyController =
        TextEditingController(text: widget.jobOffer.currency.toString());
    jobType = widget.jobOffer.jobType.toString();
    reqs = List.from(widget.jobOffer.requirements);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.jobOffer.jobTitle.capitalizeFirst,
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
                widget.jobOffer.location,
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
                          widget.jobOffer.latitude,
                          widget.jobOffer.longitude,
                        ),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.jobOffer.latitude,
                        widget.jobOffer.longitude,
                      ),
                      zoom: 13.5,
                    ),
                  ),
                ),
              ),
            ),

            FieldEdited(
              color: mainColor,
              isPassword: false,
              label: "Job Title",
              textColor: Colors.white,
              controller: titleController,
              icon: Icons.title,
            ),
            FieldEdited(
              maxLine: 5,
              isPassword: false,
              color: mainColor,
              textColor: Colors.white,
              icon: Icons.description,
              label: "Job Descritpion",
              controller: descriptionController,
            ),
            Center(
              child: Row(
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
                      value: jobType,
                      onChanged: (String value) {
                        // jobsController.changeType(value);
                        jobType = value;
                        setState(() {});
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
            ),
            FieldEdited(
              color: mainColor,
              isPassword: false,
              label: "Job salary",
              textColor: Colors.white,
              type: TextInputType.number,
              controller: salaryController,
              icon: Icons.money,
            ),
            FieldEdited(
              color: mainColor,
              isPassword: false,
              label: "Job currency",
              textColor: Colors.white,
              controller: currencyController,
              icon: Icons.money,
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
                      return AddReqEdit(
                        onPressed: () {
                          reqs.add(reqController.text);
                          setState(() {});
                        },
                        controller: reqController,
                      );
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
            // Text(jobOffer.jobRequirements.toString()),
            ListView.builder(
              controller: sc,
              shrinkWrap: true,
              itemCount: reqs.length,
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
                  reqs[index].toString().capitalizeFirst,
                  style: mainStyle(
                    fontSize: 24,
                    fontColor: context.theme.primaryColor,
                  ),
                ),
                onTap: () {
                  reqs.removeAt(index);
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
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
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              widget.jobOffer.jobTitle = titleController.text;
                              widget.jobOffer.jobDescription =
                                  descriptionController.text;
                              widget.jobOffer.jobType = jobType;
                              widget.jobOffer.currency =
                                  currencyController.text;
                              widget.jobOffer.salary =
                                  double.parse(salaryController.text);
                              widget.jobOffer.requirements = reqs;
                              FirebaseFirestore.instance
                                  .collection("offers")
                                  .doc(widget.jobOffer.id.toString())
                                  .update(widget.jobOffer.toMap())
                                  .then((value) => Get.back());
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
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
                                  .doc(widget.jobOffer.id.toString())
                                  .delete()
                                  .then((value) {
                                jobsController.offers.remove(widget.jobOffer);
                                jobsController.filteredList
                                    .remove(widget.jobOffer);
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

class AddReqEdit extends StatelessWidget {
  AddReqEdit({this.onPressed, this.controller});

  final Function onPressed;
  final TextEditingController controller;
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
              controller: controller,
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
                    if (controller.text.length != 0) {
                      onPressed();
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
