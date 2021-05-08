// Main function for released
import 'package:flutter/material.dart';
import 'package:final_food_dicoding/config/app_config.dart';
import 'package:final_food_dicoding/main_common.dart';

void main() {

  var configuredApp = AppConfig(
    appDisplayName: "Food Apps",
    appInternalId: 1,
    appColor: Colors.orange[800],
    appFont: 'Amiri',
    child: Main(),
  );

  runApp(configuredApp);
}