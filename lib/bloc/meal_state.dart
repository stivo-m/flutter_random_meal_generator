part of 'meal_bloc.dart';

@immutable
abstract class MealState {}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealLoadedSuccess extends MealState {
  final Meal meal;

  MealLoadedSuccess({this.meal});
}

class MealLoadedError extends MealState {
  final String error;

  MealLoadedError({this.error});
}
