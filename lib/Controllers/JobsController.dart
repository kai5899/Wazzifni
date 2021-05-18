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
  TextEditingController currencyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reqController = TextEditingController();

  RxnString selectedType = RxnString("Full Time");

  RxList<dynamic> jobRequirementss = RxList<dynamic>([]);

  RxList<JobOffer> offers = RxList([]);
  RxList<JobOffer> filteredList = RxList<JobOffer>([]);

  FirestoreService _service = FirestoreService();

  RxString positionString = RxString("Full Time");

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

  filter() {
    print(offers.length);
    filteredList = RxList(offers
        .where(
            (e) => e.jobType.toLowerCase() == selectedType.value.toLowerCase())
        .toList());
    update();
  }

  resetFilter() {
    selectedType.value = null;
    // markers.clear();
    filteredList = offers;
    update();
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
      salary: double.parse(salaryController.text),
      posterId: posterID,
      currency: currencyController.text,
      location: positionString.value,
    );

    offers.add(newOffer);
    // filteredList.add(newOffer);
    // offers.sort()
    print("the offer " + offers.last.requirements.toString());
    _service.postOffer(newOffer);
    time.value = DateTime.now();
    clearAddOffer();
    update();
  }

  clearAddOffer() {
    titleController.clear();
    descriptionController.clear();

    salaryController.clear();
    selectedType.value = null;
    // jobRequirementss.clear();
  }

  filterBylocation(text) {
    // markers.clear();
    filteredList = RxList(offers
        .where((e) =>
            e.location.toLowerCase().contains(text.toString().toLowerCase()) ||
            e.jobTitle.toLowerCase().contains(text.toString().toLowerCase()))
        .toList());

    update();
  }

  filterBySalary(text) {
    // markers.clear();
    filteredList = RxList(offers
        .where((e) =>
            e.salary
                .toString()
                .toLowerCase()
                .contains(text.toString().toLowerCase()) ||
            e.salary >= double.tryParse(text))
        .toList());

    update();
  }

  getOffers() async {
    offers.clear();
    time.value = DateTime.now();
    List<DocumentSnapshot> docs = await _service.getOffers();
    docs.forEach((element) {
      offers.add(JobOffer.fromMap(element.data()));
    });

    filteredList = offers;
    update();
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
