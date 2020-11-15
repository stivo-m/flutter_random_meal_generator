import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:random_meal_generator/models/meal.dart';
import 'package:random_meal_generator/respository/respository.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc() : super(MealInitial());

  @override
  Stream<MealState> mapEventToState(
    MealEvent event,
  ) async* {
    if (event is GetMeal) {
      yield MealLoading();
      Meal meal = await respository.getMeal();
      if (meal.name != '') {
        yield MealLoadedSuccess(
          meal: meal,
        );
      } else {
        yield MealLoadedError();
      }
    }
  }
}
