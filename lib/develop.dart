import 'package:flutter/material.dart';
import 'package:final_food_dicoding/config/app_config.dart';
import 'package:final_food_dicoding/main_common.dart';

void main(){

  var configuredApp = AppConfig(
    appDisplayName: "Developed Foods Catalogue",
    appInternalId: 1,
    appColor: Colors.blue[600],
    appFont: 'Alegreya',
    child: Main(),
  );

  runApp(configuredApp);
}