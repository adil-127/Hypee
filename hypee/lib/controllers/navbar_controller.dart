import 'package:get/get.dart';
import 'package:flutter/material.dart';

class navbar_controller extends GetxController {
  var tab_index=0;
  void change_tab_index(int index)
  {
    tab_index=index;
    update();
  }
  
}