import 'package:flutter/material.dart';
import 'package:final_food_dicoding/config/app_config.dart';
import 'package:final_food_dicoding/const_strings.dart';
import 'package:final_food_dicoding/main_common.dart';
import 'package:final_food_dicoding/widgets/page_view_item.dart';

class Home extends StatefulWidget {
  final MainScreen mainScreen;

  Home({Key key, this.mainScreen}) : super(key : key);

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home>{

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return PageView(
      key: Key(PAGE_VIEW),
      controller: widget.mainScreen.pageController,
      onPageChanged: widget.mainScreen.changeSelectedPageViewItem,
      children: <Widget>[
        PageViewItem(appConfig: appConfig, index: 0, mainScreen: widget.mainScreen),
        PageViewItem(appConfig: appConfig, index: 1, mainScreen: widget.mainScreen),
      ],
    );
  }

}
