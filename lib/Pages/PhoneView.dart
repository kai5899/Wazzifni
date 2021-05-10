import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:locateme/Configuration/Pallette.dart';
import 'package:locateme/Controllers/Root.dart';
import 'package:locateme/Pages/FirstTimeView.dart';
import 'package:locateme/phonePages/PhonePageOne.dart';
import 'package:locateme/phonePages/PhonePageThree.dart';
import 'package:locateme/phonePages/PhonePageTwo.dart';

class PhoneRegistration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {
  int page = 0;
  String phoneNumber = "+961";

  PageController _controller = PageController();

  // AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: WillPopScope(
          child: Container(
            width: Get.width,
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  //control header
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          color: Colors.black,
                          icon: Icon(
                            Icons.arrow_back,
                            size: 36,
                          ),
                          onPressed: () {
                            if (page != 0) {
                              setState(() {
                                page = 0;
                              });
                              _controller.animateToPage(page,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.linear);
                              return false;
                            } else {
                              Get.back();
                              return true;
                            }
                          },
                        ),
                        Row(
                          children: _buildPageIndicator(),
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  ),

                  //logo
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          child: Image.asset(
                            "assets/icons/consult.png",
                            height: 150,
                          ),
                          tag: "logo",
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20),
                  ),

                  SizedBox(
                    height: Get.height * 0.01,
                  ),

                  //pages swap

                  Container(
                    height: Get.height * 0.6,
                    child: PageView(
                      controller: _controller,
                      children: [
                        PhonePageOne(
                          onPressed: () {
                            toVerification();
                          },
                        ),
                        PhonePageTwo(
                          onPressed: () {
                            toVerified();
                          },
                        ),
                        PhonePageThree(
                          onPressed: () {
                            toHomeScreen();
                          },
                        ),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onWillPop: () async {
            if (page != 0) {
              setState(() {
                page = 0;
              });
              _controller.animateToPage(page,
                  duration: Duration(milliseconds: 400), curve: Curves.linear);
              return false;
            } else {
              Get.back();
              return true;
            }
          },
        ));
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == page ? _indicator(true, i + 1) : _indicator(false, i + 1));
    }
    return list;
  }

  Widget _indicator(bool isActive, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: isActive ? 48.0 : 24.0,
      width: isActive ? 48.0 : 24.0,
      decoration: BoxDecoration(
        color: !isActive ? sColor3 : mainColor,
        borderRadius: BorderRadius.all(Radius.circular(36)),
      ),
      child: Center(
        child: Text(
          index.toString(),
          style: mainStyle(
            fontColor: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  toVerification() {
    setState(() {
      page = 1;
    });
    _controller.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  toVerified() {
    setState(() {
      page = 2;
    });
    _controller.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.bounceIn);
  }

  toHomeScreen() {
    Get.offAll(() => Root());
  }
}
