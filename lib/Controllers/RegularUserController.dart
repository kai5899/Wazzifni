import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locateme/Models/ServiceProvider.dart';
import 'package:locateme/Services/FirestoreServices.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RegularUserController extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  RxSet<Marker> markers = RxSet<Marker>();
  RxList<ServiceProvider> serviceProviders = RxList<ServiceProvider>();

  RxList<ServiceProvider> filteredList = RxList<ServiceProvider>();

  PanelController panelController = PanelController();
  Rx<ServiceProvider> selectedProvider = Rx<ServiceProvider>(null);
  GoogleMapController mapController;

  RxnString userType = RxnString();

  TextEditingController reviewController = TextEditingController();

  // RxnString lightStyle = RxnString();
  // RxnString darkStyle = RxnString();
  // RxnString selectedMapStyle = RxnString();

  //fab data
  final double _initFabHeight = 120; // Get.height * 0.15;
  final double panelHeightOpen = Get.height * 0.75;
  RxDouble fabHeight = RxDouble(0);
  @override
  void onInit() {
    super.onInit();
    getServices();
    fabHeight.value = _initFabHeight;
  }

  changeType(String newType) {
    userType.value = newType;
  }

  addReview(String uid, String review, String posterId) {
    // FirebaseFirestore.instance.collection('users').doc(uid).update({
    //   'reviews': FieldValue.arrayUnion([review])
    // });
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reviews")
        .doc(id)
        .set({"review": review, "id": id, "posterId": posterId});
  }

  getServices() async {
    markers.clear();
    userType.value = null;
    filteredList.clear();
    serviceProviders.clear();
    List<DocumentSnapshot> docs =
        await _firestoreService.getServicesProviders();
    for (int i = 0; i < docs.length; i++) {
      ServiceProvider serviceProvider =
          ServiceProvider.fromJson(docs[i].data());
      serviceProvider.position = await printLocationName(LatLng(
          double.parse(serviceProvider.latitude),
          double.parse(serviceProvider.longitude)));
      serviceProviders.add(serviceProvider);
      _addMarker(serviceProvider);
    }
    filteredList = serviceProviders;
  }

  filter() {
    markers.clear();
    filteredList = RxList(
        serviceProviders.where((e) => e.profession == userType.value).toList());
    for (int i = 0; i < filteredList.length; i++) {
      ServiceProvider serviceProvider = filteredList[i];
      _addMarker(serviceProvider);
    }
  }

  filterBylocation(text) {
    markers.clear();
    filteredList = RxList(serviceProviders
        .where((e) => e.position.toLowerCase().contains(text))
        .toList());
    for (int i = 0; i < filteredList.length; i++) {
      ServiceProvider serviceProvider = filteredList[i];
      _addMarker(serviceProvider);
    }
  }

  resetFilter() {
    userType.value = null;
    markers.clear();
    filteredList = serviceProviders;
    for (int i = 0; i < filteredList.length; i++) {
      ServiceProvider serviceProvider = filteredList[i];
      _addMarker(serviceProvider);
    }
  }

  // to create  a specifc format to show markers on map
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  _addMarker(ServiceProvider serviceProvider) async {
    double lat = double.parse(serviceProvider.latitude);
    double long = double.parse(serviceProvider.longitude);

    final MarkerId markerId = MarkerId(serviceProvider.fullName);
    final Uint8List markerIcon = await _getBytesFromAsset(
        'assets/icons/${serviceProvider.profession.toLowerCase()}.png', 100);

    // creating a new MARKER
    final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: markerId,
        position: LatLng(lat, long),
        onTap: () {
          selectedProvider.value = serviceProvider;
          update();
          panelController.open();
        });
    markers.add(marker);
  }

  changeFabHeight(double pos) {
    if (panelController.isPanelClosed) {
      fabHeight.value = _initFabHeight;
    } else {
      fabHeight.value = pos * (panelHeightOpen - 10) + _initFabHeight;
    }
  }

  Future<String> printLocationName(LatLng position) async {
    if (position != null) {
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      List<Address> addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = addresses[1];
      // print(addresses.toString());
      print("${first.locality}  , ${first.adminArea}");
      return "${first.locality}  , ${first.adminArea}";
    } else {
      return "Unable to determin";
    }
  }
}
