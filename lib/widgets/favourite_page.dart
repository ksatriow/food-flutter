import 'package:flutter/material.dart';
import 'package:final_food_dicoding/config/app_config.dart';
import 'package:final_food_dicoding/const_strings.dart';
import 'package:final_food_dicoding/data/food_data.dart';
import 'package:final_food_dicoding/key_strings.dart';
import 'package:final_food_dicoding/main_common.dart';
import 'package:final_food_dicoding/model/food.dart';
import 'package:final_food_dicoding/widgets/detailed_page.dart';

class Favorite extends StatefulWidget{
  final MainScreen mainScreen;

  Favorite({Key key, this.mainScreen}) : super(key: key);

  @override
  FavoriteScreen createState() => FavoriteScreen();
}

class FavoriteScreen extends State<Favorite>{

  @override
  void initState() {
    super.initState();
    widget.mainScreen.fetchFavoriteMealData();
  }

  String getHeroTag(Meal meal) {
    String heroTag;
    heroTag = "Meal ID : ${meal.mealId}\n" + "Tab Bar Index : ${widget.mainScreen.currentTabBarIndex}\n" + "Category : ${widget.mainScreen.category}";
    return heroTag;
  }

  getCardHeroes(BuildContext context, AppConfig appConfig, MealData mealData) =>
      mealData.meals.map((item) =>
          Hero(
            tag: getHeroTag(item),
            child: Stack(
              children: <Widget>[
                getCard(item),
                getInkwellCard(context, appConfig, item)
              ],
            ),
          )).toList();

  getCard(Meal meal) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(meal.mealImageUrl)
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  meal.mealTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getInkwellCard(BuildContext context, AppConfig appConfig, Meal meal) {
    return Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                key: Key(getStringKeyMealItem(meal.mealId)),
                onTap: () {
                  final snackBar = SnackBar(
                    content: Text(
                      "${meal.mealTitle} terpilih!",
                      style: TextStyle(fontFamily: appConfig.appFont),
                    ),
                    action: SnackBarAction(
                        key: Key(GO_TO_DETAIL_SNACKBAR_ACTION),
                        label: "Lihat Detail",
                        textColor: appConfig.appColor,
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailedPage(meal: meal, font: appConfig.appFont, mainScreen: widget.mainScreen)));
                        }),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
            ),
          ),
        )
    );
  }

  favoriteMealListWidget(AppConfig appConfig) => widget.mainScreen.mealData.meals != null && widget.mainScreen.mealData != null ?
      widget.mainScreen.mealData.meals.length > 0
          ? getGridViewBuilder(appConfig)
          : getEmptyData()
          : getEmptyData();

  getGridViewBuilder(AppConfig appConfig) {
    return Builder(builder: (context) => GridView.count(
        key: Key(GRID_VIEW),
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
            ? 2
            : 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: EdgeInsets.all(16.0),
        children: getCardHeroes(context, appConfig, widget.mainScreen.mealData)));
  }

  getEmptyData() => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: getEmptyDataContent(),
  );

  getEmptyDataContent() => [
    SizedBox(
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/empty-box.png'),
              fit: BoxFit.contain
          ),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(top: 4.0),
      child: Text('Data kosong'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return TabBarView(
      controller: widget.mainScreen.tabController,
      children: <Widget>[
        favoriteMealListWidget(appConfig),
        favoriteMealListWidget(appConfig)
      ],
    );
  }

}