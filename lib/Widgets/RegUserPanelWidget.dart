import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/RegularUserController.dart';
import 'package:locateme/Models/ServiceProvider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomInputField.dart';

class RegUserPanelWidget extends StatelessWidget {
  final ScrollController sc;

  RegUserPanelWidget({this.sc});

  final RegularUserController controller = Get.put(RegularUserController());

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = controller.selectedProvider.value;
    return Obx(
      () => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(48),
              topLeft: Radius.circular(48),
            ),
          ),
          child: controller.selectedProvider.value != null
              ? ListView(
                  children: [
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.phoneAlt,
                            size: 36,
                            color: sColor3,
                          ),
                          onPressed: () {
                            launch("tel://${serviceProvider.phoneNumber}");
                          },
                        ),
                        Container(
                          child: Center(
                            child: Container(
                              height: Get.height * 0.20,
                              width: Get.height * 0.20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: Colors.grey[200],
                                image: serviceProvider.photoUrl == "none"
                                    ? null
                                    : DecorationImage(
                                        image: Image.network(
                                                serviceProvider.photoUrl)
                                            .image,
                                        fit: BoxFit.cover),
                              ),
                              child: serviceProvider.photoUrl == "none"
                                  ? Center(
                                      child: Text(serviceProvider.fullName[0]
                                          .toLowerCase()),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 36,
                            color: Color(0xff075e54),
                          ),
                          onPressed: () {
                            var whatsappUrl =
                                "whatsapp://send?phone=${serviceProvider.phoneNumber}";
                            launch(whatsappUrl);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OpenContainer(
                            transitionDuration: Duration(milliseconds: 400),
                            transitionType: ContainerTransitionType.fadeThrough,
                            openBuilder:
                                (BuildContext context, VoidCallback _) {
                              return AddReview(
                                uid: serviceProvider.uid,
                              );
                            },
                            closedElevation: 0.0,
                            closedShape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(360),
                              ),
                            ),
                            closedColor: context.theme.primaryColor,
                            closedBuilder: (BuildContext context,
                                VoidCallback openContainer) {
                              return Container(
                                width: Get.width * 0.3,
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    "Add Review",
                                    style: mainStyle(
                                        fontColor: context.theme.accentColor),
                                  ),
                                ),
                              );
                            },
                          ),
                          OpenContainer(
                            transitionDuration: Duration(milliseconds: 400),
                            transitionType: ContainerTransitionType.fadeThrough,
                            openBuilder:
                                (BuildContext context, VoidCallback _) {
                              return ReadReviews(
                                uid: serviceProvider.uid,
                              );
                            },
                            closedElevation: 0.0,
                            closedShape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(360),
                              ),
                            ),
                            closedColor: Colors.red,
                            closedBuilder: (BuildContext context,
                                VoidCallback openContainer) {
                              return Container(
                                width: Get.width * 0.3,
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    "Read Reviews",
                                    style: mainStyle(
                                        fontColor: context.theme.accentColor),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Container(
                        height: Get.height * 0.13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: sColor3,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Align(
                                      child: Text(
                                        serviceProvider.profession,
                                        style: mainStyle(
                                          fontSize: 20,
                                          fontColor: Colors.blueGrey,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      serviceProvider.fullName.capitalizeFirst,
                                      style: mainStyle(fontSize: 36),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                height: Get.height * 0.1,
                                width: Get.height * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                      image: Image.asset(
                                    "assets/icons/${serviceProvider.profession.toLowerCase()}.png",
                                  ).image),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: sColor1,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Service Provider Bio",
                              style: mainStyle(
                                fontSize: 30,
                                fontColor: mainColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  serviceProvider.bio,
                                  style: montserratStyle(
                                    fontSize: 18,
                                    fontColor: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: sColor1,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Birthday",
                              style: mainStyle(
                                fontSize: 30,
                                fontColor: mainColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  serviceProvider.birthDay,
                                  style: montserratStyle(
                                    fontSize: 18,
                                    fontColor: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: sColor1,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Price Range",
                              style: mainStyle(
                                fontSize: 30,
                                fontColor: mainColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "${serviceProvider.priceRange.substring(1, serviceProvider.priceRange.length - 1)} L.L",
                                  style: montserratStyle(
                                    fontSize: 18,
                                    fontColor: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("No provider is Selected"),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class ReadReviews extends StatelessWidget {
  final String uid;

  const ReadReviews({Key key, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Reviews",
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("users").doc(uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            DocumentSnapshot doc = snapshot.data;
            List<dynamic> reviews;
            try {
              reviews = doc["reviews"];
            } catch (e) {
              reviews = [];
            }
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: mainColor,
                    child: Center(
                      child: Text("${index + 1}"),
                    ),
                  ),
                  title: Text(
                    reviews[index],
                    style: mainStyle(
                      fontColor: context.theme.primaryColor,
                      fontSize: 30,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AddReview extends StatelessWidget {
  final RegularUserController controller = Get.put(RegularUserController());

  final String uid;

  AddReview({Key key, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add a Review",
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
              ),
              child: Text("Write a Review",
                  style: mainStyle(fontSize: 24), textAlign: TextAlign.start),
            ),
            FieldEdited(
              label: "Review",
              color: mainColor,
              isPassword: false,
              maxLine: 5,
              controller: controller.reviewController,
              textColor: Colors.white,
              type: TextInputType.multiline,
              icon: Icons.text_format_outlined,
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
                    // authController.updateBio(
                    //     _profileController
                    //         .bioController.text);
                    //
                    controller.addReview(uid, controller.reviewController.text);
                    controller.reviewController.clear();
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
