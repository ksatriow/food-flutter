class Meal {

  int id;

  String mealId;
  String mealTitle;
  String mealImageUrl;

  Meal({
    this.mealId,
    this.mealTitle,
    this.mealImageUrl,
  });


  Meal.fromJson(Map<String, dynamic> json){
    mealId = json['idMeal'];
    mealTitle = json['strMeal'];
    mealImageUrl = json['strMealThumb'];
  }

  Map<String, dynamic> toJson(){
    var mealMap = Map<String, dynamic>();

    mealMap['mealId'] = mealId;
    mealMap['mealTitle'] = mealTitle;
    mealMap['mealImageUrl'] = mealImageUrl;

    return mealMap;
  }

  void setFavoriteRecipeId(int id){
    this.id = id;
  }



}
