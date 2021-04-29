import 'package:flutter/material.dart';
import 'package:locateme/Configuration/FontStyles.dart';
import 'package:get/get.dart';

class ServiceProviderHomeView extends StatelessWidget {
  const ServiceProviderHomeView();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Click on",
              style: mainStyle(
                fontSize: 48,
                fontColor: context.theme.primaryColor,
              ),
            ),
            Icon(
              Icons.menu,
              size: 150,
              color: context.theme.primaryColor,
            ),
            Text(
              "to navigate !",
              style: mainStyle(
                fontSize: 48,
                fontColor: context.theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
