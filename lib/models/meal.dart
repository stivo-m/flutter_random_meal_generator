class Meal {
  final String name, category, area, instructions, youtube, source, thumb, tags;

  final List<String> measures, ingredients;

  Meal({
    this.name,
    this.tags,
    this.category,
    this.area,
    this.instructions,
    this.youtube,
    this.measures,
    this.ingredients,
    this.source,
    this.thumb,
  });

  Meal.fromJsonMap(Map<String, dynamic> map)
      : name = map['strMeal'],
        tags = map['strTags'],
        category = map['strCategory'],
        area = map['strArea'],
        instructions = map['strInstructions'],
        youtube = map['strYoutube'],
        source = map['strSource'],
        ingredients = getIngredients(map),
        thumb = map["strMealThumb"],
        measures = getMeasures(map);
}

getIngredients(Map map) {
  List<String> ingredients = [];
  for (var i = 1; i <= 20; i++) {
    ingredients.add(map['strIngredient$i']);
  }

  ingredients.removeWhere((element) => element.trim() == '');

  return ingredients;
}

getMeasures(Map map) {
  List<String> measures = [];
  for (var i = 1; i <= 20; i++) {
    measures.add(map['strMeasure$i'].toString());
  }
  // measures.removeWhere((element) => element.trim() == '');

  return measures;
}
