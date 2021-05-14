import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/AuthController.dart';
import 'package:locateme/Controllers/RegularUserController.dart';
import 'package:locateme/Models/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomInputField.dart';

class RegUserPanelWidget extends StatelessWidget {
  final ScrollController sc;

  RegUserPanelWidget({this.sc});

  final RegularUserController controller = Get.put(RegularUserController());

  @override
  Widget build(BuildContext context) {
    // ServiceProvider serviceProvider = controller.selectedProvider.value;
    return Obx(
      () => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.backgroundColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(48),
              topLeft: Radius.circular(48),
            ),
          ),
          child: controller.selectedProvider.value != null
              ? ListView(
                  physics: BouncingScrollPhysics(),
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
                            launch(
                                "tel://${controller.selectedProvider.value.phoneNumber}");
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
                                image: controller
                                            .selectedProvider.value.photoUrl ==
                                        "none"
                                    ? null
                                    : DecorationImage(
                                        image: Image.network(controller
                                                .selectedProvider
                                                .value
                                                .photoUrl)
                                            .image,
                                        fit: BoxFit.cover),
                              ),
                              child:
                                  controller.selectedProvider.value.photoUrl ==
                                          "none"
                                      ? Center(
                                          child: Text(
                                            controller.selectedProvider.value
                                                .fullName[0]
                                                .toLowerCase(),
                                            style: mainStyle(
                                                fontColor: mainColor,
                                                fontSize: Get.height * 0.20),
                                          ),
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
                                "whatsapp://send?phone=${controller.selectedProvider.value.phoneNumber}";
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
                                uid: controller.selectedProvider.value.uid,
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
                                    "Add Review".tr,
                                    style: mainStyle(
                                        fontColor:
                                            context.theme.backgroundColor),
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
                                uid: controller.selectedProvider.value.uid,
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
                                    "Read Reviews".tr,
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
                                        controller
                                            .selectedProvider.value.profession,
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
                                      controller.selectedProvider.value.fullName
                                          .capitalizeFirst,
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
                                    "assets/icons/${controller.selectedProvider.value.profession.toLowerCase()}.png",
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
                              "Service Provider Bio".tr,
                              style: mainStyle(
                                fontSize: 30,
                                fontColor: mainColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  controller.selectedProvider.value.bio,
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
                              "birthDay".tr,
                              style: mainStyle(
                                fontSize: 30,
                                fontColor: mainColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  controller.selectedProvider.value.birthDay,
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
                              "Price Range".tr,
                              style: mainStyle(
                                fontSize: 30,
                                fontColor: mainColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "${controller.selectedProvider.value.priceRange.substring(1, controller.selectedProvider.value.priceRange.length - 1)} L.L",
                                  style: montserratStyle(
                                    fontSize: 18,
                                    fontColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
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
                                "Star Rate".tr,
                                style: mainStyle(
                                  fontSize: 30,
                                  fontColor: mainColor,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(
                                          controller.selectedProvider.value.uid)
                                      .collection("stars")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    double stars = 0;
                                    List<dynamic> starSet;
                                    if (!snapshot.hasData) {
                                      stars = 0;
                                    } else {
                                      QuerySnapshot docs = snapshot.data;
                                      starSet = docs.docs;
                                      starSet.forEach((element) {
                                        stars += element["stars"];
                                      });

                                      if (starSet.length == 0) {
                                        stars = 0;
                                      } else {
                                        stars = stars / starSet.length;
                                      }
                                    }
                                    return Center(
                                      child: RatingBar.builder(
                                        initialRating: stars,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        glow: true,
                                        ignoreGestures: true,
                                        onRatingUpdate: (rating) {
                                          //
                                        },
                                      ),
                                    );
                                  }),
                            ],
                          )),
                    )
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
          "Reviews".tr,
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("reviews")
            .orderBy("id", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            QuerySnapshot docs = snapshot.data;
            List<dynamic> reviews;
            try {
              reviews = docs.docs;
            } catch (e) {
              reviews = [];
            }

            if (reviews.length == 0) {
              return Center(
                child: Text(
                  "No reviews Yet",
                  style: mainStyle(
                    fontColor: context.theme.primaryColor,
                    fontSize: 36,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: mainColor,
                    thickness: 2,
                    indent: 50,
                    endIndent: 50,
                  );
                },
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(reviews[index]["id"]));

                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(reviews[index]["posterId"])
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        DocumentSnapshot doc = snapshot.data;
                        UserModel model = UserModel.fromJson(doc.data());
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${index + 1}. By " + model.fullName,
                                      style: mainStyle(
                                        fontSize: 36,
                                        fontColor: sColor1,
                                      ),
                                    ),
                                    Text(date
                                        .toLocal()
                                        .toString()
                                        .substring(0, 16)),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  reviews[index]["review"],
                                  style: mainStyle(
                                    fontColor: mainColor,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: Duration(milliseconds: 400),
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return AddReview(
            uid: uid,
          );
        },
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(360),
          ),
        ),
        closedColor: context.theme.primaryColor,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Container(
            width: Get.width * 0.3,
            height: 70,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Add Review".tr,
                style: mainStyle(fontColor: context.theme.backgroundColor),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddReview extends StatelessWidget {
  final RegularUserController controller = Get.put(RegularUserController());
  final AuthController authController = Get.put(AuthController());

  final String uid;

  AddReview({Key key, this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add a Review".tr,
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
              child: Text("Write a Review".tr,
                  style: mainStyle(
                    fontSize: 24,
                    fontColor: context.theme.primaryColor,
                  ),
                  textAlign: TextAlign.start),
            ),
            FieldEdited(
              label: "Review".tr,
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
                    controller.addReview(uid, controller.reviewController.text,
                        authController.user.uid);
                    controller.reviewController.clear();
                    Get.back();
                  },
                  child: Icon(Icons.check, color: Colors.white),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                  child: Text(
                "Start Review",
                style: mainStyle(
                  fontSize: 24,
                  fontColor: context.theme.primaryColor,
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  glow: true,
                  onRatingUpdate: (rating) {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("stars")
                        .doc(authController.user.uid)
                        .set({
                      "stars": rating,
                      "id": authController.user.uid
                    }).then((value) => Get.back());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
