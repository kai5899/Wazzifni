import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:locateme/Configuration/FontStyles.dart';

class FieldEdited extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final FocusNode focusNode;
  final TextInputType type;
  final Color color;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final int maxLine;

  const FieldEdited(
      {Key key,
      this.label,
      this.controller,
      this.icon,
      this.type,
      this.isPassword,
      this.focusNode,
      this.color,
      this.textColor,
      this.padding,
      this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color == null ? Colors.white : color,
        ),
        height: maxLine == null ? 65 : 40.0 * maxLine,
        child: Padding(
          child: TextFormField(
            maxLines: maxLine == null ? 1 : maxLine,
            focusNode: focusNode,
            obscureText: isPassword,
            cursorColor: Colors.white,
            keyboardType: type,
            style: mainStyle(
              fontColor: textColor,
              fontSize: 24,
            ),
            decoration: InputDecoration(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FaIcon(
                  icon == null ? FontAwesomeIcons.userAlt : icon,
                  color: textColor,
                  size: 36,
                ),
              ),
              labelText: label,
              labelStyle: mainStyle(
                fontColor: textColor,
                fontSize: 20,
              ),
              fillColor: Colors.white,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            controller: controller,
          ),
          padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
        ),
      ),
      padding: padding == null
          ? EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15)
          : padding,
    );
  }
}
