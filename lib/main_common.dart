import 'dart:async';

import 'package:flutter/material.dart';
import 'package:final_food_dicoding/config/app_config.dart';
import 'package:final_food_dicoding/const_strings.dart';
import 'package:final_food_dicoding/data/food_data.dart';
import 'package:final_food_dicoding/network/network_data.dart';
import 'package:final_food_dicoding/widgets/favourite_page.dart';
import 'package:final_food_dicoding/widgets/home_page.dart';

class Main extends StatefulWidget {
  @override
  MainScreen createState() => MainScreen();
}

class MainScreen extends State<Main> with TickerProviderStateMixin<Main> {

  String category = "Dessert";

  MealData mealData;

  bool isCurrentPageBottomNavigation = true;
  bool isCurrentPageTabBar = false;

  int currentBottomNavigationIndex = 0;
  int currentTabBarIndex = 0;
  int currentDrawerIndex = 0;

  PageController pageController;
  TabController tabController;

  final mainNavigatorKey = GlobalKey<NavigatorState>();

  String keyword = "";
  TextEditingController textEditingController;
  bool isSearchingMeals = false;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0, keepPage: true);

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(changeSelectedTabBarItem);

    textEditingController = TextEditingController();

    textEditingController.addListener(() {
      if(textEditingController.text.isNotEmpty){
        setState(() {
          keyword = textEditingController.text;
          updateKeyword(keyword);
        });
      } else {
        setState(() {
          keyword = "";
          updateKeyword(keyword);
        });
      }
    });

  }

  void enableSearch(){
    setState(() {
      isSearchingMeals = true;
    });
  }

  void updateKeyword(String keyword){
    setState(() {
      this.keyword = keyword;
    });
    if(isCurrentPageBottomNavigation) {
      fetchMealData();
    } else if(isCurrentPageTabBar) {
      fetchFavoriteMealData();
    }
  }

  void disableSearch(){
    setState(() {
      textEditingController.clear();
      updateKeyword("");
      isSearchingMeals = false;
    });

    if(isCurrentPageBottomNavigation) {
      fetchMealData();
    } else if(isCurrentPageTabBar) {
      fetchFavoriteMealData();
    }
  }

  Widget buildTextField() {
    return TextField(
      key: Key(TEXT_FIELD),
      controller: textEditingController,
      style: TextStyle(
        color: Colors.white,
      ),
      autofocus: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: "Cari makanan",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.white30,
          )
      ),
    );
  }

  List<Widget> getMenuIcon() {
    List<Widget> menuIcons;
    if(isSearchingMeals) {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: disableSearch,
          tooltip: TOOLTIP_CLEAR_SEARCH,
        ),
      );
    } else {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: enableSearch,
          tooltip: TOOLTIP_SEARCH,
        ),
      );
    }

    return menuIcons;
  }

  changeSelectedBottomNavigationBarItem(int index) {
    setState(() {
      currentBottomNavigationIndex = index;
      changeMealCategory(index);
      fetchMealData();
      disableSearch();
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  changeSelectedPageViewItem(int index){
    setState(() {
      currentBottomNavigationIndex = index;
      changeMealCategory(index);
      fetchMealData();
      disableSearch();
    });
  }

  changeSelectedTabBarItem() {
    setState(() {
      currentTabBarIndex = tabController.index;
      changeFavoriteMealCategory(currentTabBarIndex);
      fetchFavoriteMealData();
      disableSearch();
    });
  }

  changeMealCategory(int index) {
    setState(() {
      switch(index){
        case 1:
          category = "Seafood";
          break;
        default:
          category = "Dessert";
          break;
      }
    });
  }

  changeFavoriteMealCategory(int index){
    setState(() {
      switch(index){
        case 1:
          category = "Favorite Seafood";
          break;
        default:
          category = "Favorite Dessert";
          break;
      }
    });
  }

  createBottomNavigationBar(AppConfig appConfig) {
    return BottomNavigationBar(
      key: Key(BOTTOM_NAVIGATION_BAR),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.fastfood, key: Key(DESSERT_ICON)), title: Text("Dessert")),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu, key: Key(SEAFOOD_ICON)), title: Text("Seafood")),
      ],
      currentIndex: currentBottomNavigationIndex,
      onTap: changeSelectedBottomNavigationBarItem,
      selectedItemColor: appConfig.appColor,
      unselectedItemColor: Colors.grey,
    );
  }

  createTabBar(){
    return TabBar(
      controller: tabController,
      tabs: <Widget>[
        Tab(icon: Icon(Icons.fastfood, key: Key(FAVORITE_DESSERT_ICON)), text: "Favorite Dessert"),
        Tab(icon: Icon(Icons.restaurant_menu, key: Key(FAVORITE_SEAFOOD_ICON)), text: "Favorite Food"),
      ],
    );
  }

  createDrawer(BuildContext context, AppConfig appConfig){
    return Drawer(
      key: Key(DRAWER),
      child: createDrawerContent(context, appConfig),
    );
  }

  createDrawerContent(BuildContext context, AppConfig appConfig) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(accountName: Text(appConfig.appDisplayName), accountEmail: null),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          selected: setSelectedDrawerItem(0),
          onTap: () => changePage(context, 0),
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          // todo: key
          title: Text('Favorite'),
          selected: setSelectedDrawerItem(1),
          onTap: () => changePage(context, 1),
        ),
      ],
    );
  }

  changeSelectedMode(int index) {
    setState(() {
      switch (index) {
        case 1:
          isCurrentPageTabBar = true;
          isCurrentPageBottomNavigation = false;
          break;
        default:
          isCurrentPageTabBar = false;
          isCurrentPageBottomNavigation = true;
          break;
      }
    });
  }

  changeSelectedIndex(int index) {
    setState(() {
      currentDrawerIndex = index;
    });
  }

  changePage(BuildContext context, int index){
    disableSearch();
    changeSelectedIndex(index);
    changeSelectedMode(index);
    if(index == 1){
      changeFavoriteMealCategory(currentTabBarIndex);
    } else {
      changeMealCategory(currentBottomNavigationIndex);
    }
    Navigator.of(context).pop();
  }

  bool setSelectedDrawerItem(int index) => index == currentDrawerIndex ? true : false;

  getDrawerItemWidget(int index) {
    switch(index){
      case 1:
        return Favorite(mainScreen: this);
      default:
        return Home(mainScreen: this);
    }
  }

  fetchMealData() async {
    NetworkData networkData = NetworkData();

    MealData mealData = await networkData.fetchMealData(
        isSearchingMeals: isSearchingMeals,
        keyword: keyword,
        category: category
    );

    if(currentDrawerIndex == 0){
      setState(() {
        this.mealData = mealData;
      });
    }

  }

  fetchFavoriteMealData() async {
    NetworkData networkData = NetworkData();

    MealData mealData = await networkData.fetchFavoriteMealData(
        isSearchingMeals: isSearchingMeals,
        keyword: keyword,
        category: category
    );

    setState(() {
      this.mealData = mealData;
    });
  }

  Future<bool> onBackPressed(AppConfig appConfig){
    if(isSearchingMeals){
      disableSearch();
      return Future.value(false);
    } else {
      final rootContext = mainNavigatorKey.currentState.overlay.context;
      return showDialog(
        context: rootContext,
        builder: (context) => AlertDialog(
          title: Text('Keluar dari katalog makanan Apps', style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text('Anda yakin akan keluar dari Apps?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false), // return Future.value(false);
              child: Text('Kembali ke Apps', style: TextStyle(color: appConfig.appColor),),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Keluar', style: TextStyle(color: appConfig.appColor),),
            ),
          ],
        ),
      ) ?? false;
    }
  }

  mainContent(AppConfig appConfig, BuildContext context){
    return WillPopScope(
      onWillPop: () => onBackPressed(appConfig),
      child: Scaffold(
        appBar: AppBar(
          title: isSearchingMeals ? buildTextField() : Text(category),
          actions: getMenuIcon(),
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: appConfig.appFont,
            ),
          ),
          bottom: isCurrentPageTabBar ? createTabBar() : null,
        ),
        drawer: createDrawer(context, appConfig),
        body: getDrawerItemWidget(currentDrawerIndex),
        bottomNavigationBar: isCurrentPageBottomNavigation ? createBottomNavigationBar(appConfig) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MaterialApp(
        navigatorKey: mainNavigatorKey,
        title: appConfig.appDisplayName,
        theme: ThemeData(
          primaryColor: appConfig.appColor,
          accentColor: Colors.white,
          fontFamily: appConfig.appFont,
        ),
        home: Builder(builder: (context) => mainContent(appConfig, context))
    );
  }

}