import 'package:flutter_driver/flutter_driver.dart';
import 'package:final_food_dicoding/const_strings.dart';
import 'package:final_food_dicoding/key_strings.dart';

SerializableFinder appBarTitle = find.byValueKey(APP_BAR_TITLE);

SerializableFinder gridView = find.byValueKey(GRID_VIEW);
SerializableFinder detailedListView = find.byValueKey(DETAILED_LIST_VIEW);

SerializableFinder bottomNavigationBar = find.byValueKey(BOTTOM_NAVIGATION_BAR);
SerializableFinder pageView = find.byValueKey(PAGE_VIEW);
SerializableFinder drawer = find.byValueKey(DRAWER);

SerializableFinder dessert = find.byValueKey(DESSERT_ICON);
SerializableFinder seafood = find.byValueKey(SEAFOOD_ICON);
SerializableFinder favoriteDessert = find.byValueKey(FAVORITE_DESSERT_ICON);
SerializableFinder favoriteSeafood = find.byValueKey(FAVORITE_SEAFOOD_ICON);

SerializableFinder textField = find.byValueKey(TEXT_FIELD);

SerializableFinder tooltipSearch = find.byTooltip(TOOLTIP_SEARCH);
SerializableFinder tooltipClearSearch = find.byTooltip(TOOLTIP_CLEAR_SEARCH);

SerializableFinder tooltipFavorite = find.byTooltip(TOOLTIP_FAVORITE);

SerializableFinder firstDessertMeal = find.byValueKey(getStringKeyMealItem("52893"));
SerializableFinder firstDessertSearchMeal = find.byValueKey(getStringKeyMealItem("52889"));

SerializableFinder snackBarDetail = find.byValueKey(GO_TO_DETAIL_SNACKBAR_ACTION);
SerializableFinder snackBarUndo = find.byValueKey(UNDO_SNACKBAR_ACTION);