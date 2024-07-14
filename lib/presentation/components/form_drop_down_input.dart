import 'package:flutter/material.dart';

import 'package:currency_converter/utils/responsive/screen_sizes.dart';
import 'package:flutter/services.dart';

class FormDropDownInput extends StatelessWidget {
  final Color cardColor;
  final TextEditingController? controller;
  final Color? textFormFieldColor;
  final Color? hintColor;
  final bool? readOnly;
  final String hintText;
  final Widget? dropdownWidget;

  const FormDropDownInput(
      {super.key,
      required this.cardColor,
      this.controller,
      this.textFormFieldColor,
      this.hintColor,
      this.readOnly = false,
      required this.hintText,
      this.dropdownWidget});

  @override
  Widget build(BuildContext context) {
    double screenHeight = displayHeight(context);
    double screenWidth = displayWidth(context);

    return Expanded(
      child: SizedBox(
        height: screenHeight * 0.08,
        child: Card(
          color: cardColor,
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.035, vertical: screenHeight * 0.0015),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.015),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextFormField(
                      controller: controller,
                      autofocus: false,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*')),
                      ],
                      readOnly: readOnly!,
                      style: TextStyle(color: textFormFieldColor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hintText,
                          hintStyle: TextStyle(color: hintColor)),
                    ),
                  ),
                  // DropDown
                  dropdownWidget!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
