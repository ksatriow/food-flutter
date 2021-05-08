import 'package:flutter/material.dart';
import 'package:final_food_dicoding/config/app_config.dart';
import 'package:final_food_dicoding/const_strings.dart';
import 'package:final_food_dicoding/database/foods_db_helper.dart';
import 'package:final_food_dicoding/model/food.dart';
import 'package:final_food_dicoding/model/food_recipe.dart';
import 'package:final_food_dicoding/network/network_data.dart';
import 'package:async_loader/async_loader.dart';
import 'package:final_food_dicoding/main_common.dart';

class DetailedPage extends StatefulWidget {

  final Meal meal;

  final MainScreen mainScreen;

  final String font;

  DetailedPage({Key key, this.meal, this.mainScreen, this.font}) : super(key: key);

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {

  MealRecipe mealRecipe;

  var mealsDatabaseHelper;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<AsyncLoaderState> asyncLoaderState = GlobalKey<AsyncLoaderState>();

  bool _isFavorite = false;

  // region initialize state and get data
  @override
  void initState() {
    super.initState();

    mealsDatabaseHelper = MealsDBHelper();

  }

  fetchMealRecipeData() async {
    NetworkData networkData = NetworkData();

    MealRecipe mealRecipe = await networkData.fetchMealRecipeData(widget.meal.mealId);

    setState(() {
      this.mealRecipe = mealRecipe;
      if(widget.mainScreen.category == "Dessert" || widget.mainScreen.category == "Favorite Dessert"){
        favoriteDessertCheck();
      } else {
        favoriteSeafoodCheck();
      }
    });
  }

  favoriteDessertCheck() async {
    var favoriteDesserts = await mealsDatabaseHelper.getFavoriteDesserts();
    setState(() {
      for (int i = 0; i < favoriteDesserts.length; i++){
        if(favoriteDesserts[i].mealId == widget.meal.mealId) {
          _isFavorite = true;
          break;
        }
      }
    });
  }

  favoriteSeafoodCheck() async {
    var favoriteSeafood = await mealsDatabaseHelper.getFavoriteSeafood();
    setState(() {
      for(int i = 0; i < favoriteSeafood.length; i++){
        if(favoriteSeafood[i].mealId == widget.meal.mealId){
          _isFavorite = true;
          break;
        }
      }
    });
  }

  setFavorite() async {

    var mealsDatabaseHelper = MealsDBHelper();

    Meal meal = Meal(
      mealId: this.mealRecipe.mealRecipeId,
      mealTitle: this.mealRecipe.mealRecipeTitle,
      mealImageUrl: this.mealRecipe.mealRecipeImageUrl,
    );

    if(widget.mainScreen.category == "Dessert" ||
        widget.mainScreen.category == "Favorite Dessert"){
      if(_isFavorite){
        await mealsDatabaseHelper.deleteDessertData(meal);
      } else {
        await mealsDatabaseHelper.saveDessertData(meal);
      }
    } else {
      if(_isFavorite){
        await mealsDatabaseHelper.deleteSeafoodData(meal);
      } else {
        await mealsDatabaseHelper.saveSeafoodData(meal);
      }
    }

    if(widget.mainScreen.category == "Favorite Dessert" ||
        widget.mainScreen.category == "Favorite Seafood"){
      widget.mainScreen.fetchFavoriteMealData();
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

  }

  Future<Null> handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  getAppBar(AppConfig appConfig) =>
      AppBar(
        title: Text(widget.meal.mealTitle),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: appConfig.appFont,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: (){
              if(mealRecipe != null){
                setFavorite();
                _displaySnackbar(context, !_isFavorite);
              } else {
                return null;
              }
            },
            tooltip: TOOLTIP_FAVORITE,
          )
        ],
      );

  String getHeroTag(Meal meal) {
    String heroTag;

    if(widget.mainScreen.currentDrawerIndex == 1) {
      heroTag = "Meal ID : ${meal.mealId}\n" + "Tab Bar Index : ${widget.mainScreen.currentTabBarIndex}" + "Category : ${widget.mainScreen.category}";
    } else {
      heroTag = "Meal ID : ${meal.mealId}\n" + "Bottom Navigation Index : ${widget.mainScreen.currentBottomNavigationIndex}" + "Category : ${widget.mainScreen.category}";
    }
    return heroTag;
  }

  getHeroView(AppConfig appConfig) {
    var asyncLoader = AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await fetchMealRecipeData(),
      renderLoad: () => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appConfig.appColor))),
      renderError: ([error]) => getNoConnectionWidget(appConfig),
      renderSuccess: ({data}) => getListView(appConfig),
    );

    return Hero(
        tag: getHeroTag(widget.meal),
        child: Scrollbar(child: RefreshIndicator(child: asyncLoader, onRefresh: handleRefresh, color: appConfig.appColor))
    );
  }

  getNoConnectionWidget(AppConfig appConfig) => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: getNoConnectionContent(appConfig),
  );

  getNoConnectionContent(AppConfig appConfig) => [
    SizedBox(
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/no-wifi.png'),
              fit: BoxFit.contain
          ),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(top: 4.0),
      child: Text("No Internet Connection"),
    ),
    Container(
      padding: EdgeInsets.only(top: 4.0),
      child: FlatButton(
          color: appConfig.appColor,
          child: Text("Restart", style: TextStyle(color: Colors.white)),
          onPressed: () => asyncLoaderState.currentState.reloadState()
      ),
    ),
  ];

  getListView(AppConfig appConfig) => ListView(
        key: Key(DETAILED_LIST_VIEW),
        padding: EdgeInsets.all(16.0),
        children: getListViewContent(appConfig),
      );

  getListViewContent(AppConfig config) {
    return [
      Align(
        alignment: Alignment.center,
        child: ClipOval(
          child: Container(
            width: 125.0,
            height: 125.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      mealRecipe.mealRecipeImageUrl
                  ),
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            mealRecipe.mealRecipeTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            'Category : ' + mealRecipe.mealRecipeCategory,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            'Ingredients : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: getIngredientsTextList(mealRecipe.mealRecipeIngredients),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            'Instructions : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: getInstructionsTextList(mealRecipe.mealRecipeInstructions),
        ),
      ),
    ];
  }


  List<Padding> getIngredientsTextList(List<String> stringList){
    List<Padding> ingredientTexts = List<Padding>();

    for(String string in stringList){
      if(string.length > 0){
        ingredientTexts.add(
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(string),
              ),
            ),
          ),
        );
      }
    }

    return ingredientTexts;
  }

  List<Padding> getInstructionsTextList(List<String> stringList){
    List<Padding> instructionTexts = List<Padding>();

    for(String string in stringList){
      if(string.length > 0){
        instructionTexts.add(
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(string),
              ),
            ),
          )
        );
      }
    }

    return instructionTexts;
  }

  _displaySnackbar(BuildContext context, bool isFavorite) {
    var appConfig = AppConfig.of(context);

    Text snackbarTextContent;

    if (isFavorite) {
      snackbarTextContent = Text(
        "Marked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: appConfig.appFont),
      );
    } else {
      snackbarTextContent = Text(
        "Unmarked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: appConfig.appFont),
      );
    }

    final snackBar = SnackBar(
      content: snackbarTextContent,
      action: SnackBarAction(
        key: Key(UNDO_SNACKBAR_ACTION),
        label: "UNDO",
        onPressed: setFavorite,
        textColor: appConfig.appColor,
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(appConfig),
      body: getHeroView(appConfig),
    );
  }
}
