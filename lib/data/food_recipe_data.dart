import 'package:final_food_dicoding/model/food_recipe.dart';

class MealRecipeData {
  List<MealRecipe> mealRecipes;

  MealRecipeData(this.mealRecipes);

  MealRecipeData.fromJson(Map<String, dynamic> json){
    if(json['meals'] != null){
      mealRecipes = List<MealRecipe>();
      json['meals'].forEach((v) {
        mealRecipes.add(MealRecipe.fromJson(v));
      });
    }
  }
}