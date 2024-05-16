import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';

import '../constants/app_paddings.dart';
import 'app_text.dart';


class AppInputField extends StatelessWidget {
  String? title, hintText;
  TextEditingController? controller;
  Widget? suffixIcon;
  bool? enabled;
  VoidCallback? onTap;
  var validator;
  var onSaved;
  bool obsecuretext;
  AppInputField({
    Key? key,
    this.title,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.enabled,
    this.onTap,
    this.validator,
    this.onSaved,
    this.obsecuretext = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title ?? '',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        AppPaddings.heightSpace10,
        TextFormField(
          enabled: enabled,
          onTap: onTap,
          controller: controller,
          validator: validator,
          onSaved: onSaved,
          obscureText: obsecuretext,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.inter(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

class AppDropdownField extends StatelessWidget {
  String? title, hintText;
  List<String> selectedValue;
  List<String> items;
  Widget? suffixIcon;
  late dynamic Function(List<String>) onChanged;
  AppDropdownField({
    Key? key,
    this.title,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.suffixIcon,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title ?? '',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        AppPaddings.heightSpace10,
        // DropdownButtonFormField(
        //   icon: Padding(
        //     padding: const EdgeInsets.only(top: 8.0),
        //     child: SvgPicture.asset(
        //       "assets/icons/arrow_down.svg",
        //       color: Colors.black87,
        //     ),
        //   ),
        //   value: selectedValue,
        //   items: items
        //       .map(
        //         (e) => DropdownMenuItem(
        //           value: e,
        //           child: AppText(
        //             text: e,
        //           ),
        //         ),
        //       )
        //       .toList(),
        //   onChanged: onChanged,
        //   decoration: InputDecoration(
        //     hintText: hintText,
        //     suffixIcon: suffixIcon,
        //     hintStyle: GoogleFonts.inter(),
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(30),
        //       borderSide: const BorderSide(color: Colors.grey),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(30),
        //       borderSide: const BorderSide(color: Colors.grey),
        //     ),
        //     errorBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(30),
        //       borderSide: const BorderSide(color: Colors.grey),
        //     ),
        //   ),
        // ),
        DropDownMultiSelect(
          options: items, 
          selectedValues: selectedValue, 
          onChanged: onChanged,
            decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.inter(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          )
      ],
    );
  }
}
