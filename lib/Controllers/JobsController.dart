import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:locateme/Models/JobOffer.dart';
import 'package:locateme/Services/FirestoreServices.dart';

class JobsController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reqController = TextEditingController();

  RxnString selectedType = RxnString();

  RxList<dynamic> jobRequirementss = RxList<dynamic>([]);

  RxList<JobOffer> offers = RxList([]);

  FirestoreService _service = FirestoreService();

  RxString positionString = RxString("");

  List<String> jobTypes = [
    "Full Time",
    "Part Time",
    "Intern",
    "Freelace",
    "others",
  ];

  Rxn<DateTime> time = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    getOffers();
  }

  @override
  void onClose() {
    super.onClose();
    titleController.dispose();
    salaryController.dispose();
    descriptionController.dispose();
  }

  void changeType(String value) {
    selectedType.value = value;
  }

  void addOffer(String posterID, Position position) {
    JobOffer newOffer = JobOffer(
      id: DateTime.now().millisecondsSinceEpoch,
      jobDescription: descriptionController.text,
      requirements: jobRequirementss,
      jobTitle: titleController.text,
      jobType: selectedType.value,
      latitude: position.latitude,
      longitude: position.longitude,
      salary: salaryController.text,
      posterId: posterID,
      location: positionString.value,
    );

    offers.add(newOffer);
    print("the offer " + offers.last.requirements.toString());
    _service.postOffer(newOffer);
    time.value = DateTime.now();
    clearAddOffer();
  }

  clearAddOffer() {
    titleController.clear();
    descriptionController.clear();

    salaryController.clear();
    selectedType.value = null;
    // jobRequirementss.clear();
  }

  getOffers() async {
    offers.clear();
    time.value = DateTime.now();
    List<DocumentSnapshot> docs = await _service.getOffers();
    docs.forEach((element) {
      offers.add(JobOffer.fromMap(element.data()));
    });
  }

  Future<String> printLocationName(Position position) async {
    if (position != null) {
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      List<Address> addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = addresses[1];
      // print(addresses.toString());
      print("${first.locality}  , ${first.adminArea}");
      positionString.value = "${first.locality}  , ${first.adminArea}";
      return "${first.locality}  , ${first.adminArea}";
    } else {
      return "Unable to determin";
    }
  }
}
