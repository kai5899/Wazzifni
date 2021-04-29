import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxInt optionSelected = RxInt(0);

  ScrollController smallListController = ScrollController();

  changeOption(int newOption) {
    optionSelected.value = newOption;
    if (newOption == 1) {
      smallListController.animateTo(
        smallListController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
      Timer(
          Duration(seconds: 1),
          () => smallListController.animateTo(
                smallListController.position.minScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
              ));
    }
  }
}
