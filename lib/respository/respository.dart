import 'package:dio/dio.dart';
import 'package:random_meal_generator/models/meal.dart';

class Respository {
  final String api = 'https://www.themealdb.com/api/json/v1/1/random.php';
  final Dio dio = Dio();

  Future<Meal> getMeal() async {
    Meal meal;
    var meals = await dio.get(api);
    meal = Meal.fromJsonMap(meals.data["meals"][0]);
    return meal;
  }
}

Respository respository = Respository();
