import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_meal_generator/bloc/meal_bloc.dart';
import 'package:random_meal_generator/models/meal.dart';
import 'package:random_meal_generator/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMealCard extends StatefulWidget {
  final Meal meal;

  const CustomMealCard({
    Key key,
    this.meal,
  }) : super(key: key);

  @override
  _CustomMealCardState createState() => _CustomMealCardState();
}

class _CustomMealCardState extends State<CustomMealCard> {
  Meal meal;
  @override
  void initState() {
    meal = widget.meal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> ingredients = meal.ingredients;
    List<String> measures = meal.measures;

    List<String> measuresAndIngredients = [];

    for (var i = 0; i < ingredients.length; i++) {
      var newList;
      newList = measures[i] + " " + ingredients[i] + ', ';

      if (i == ingredients.length - 1) {
        newList = measures[i] + " " + ingredients[i] + '.';
      }

      measuresAndIngredients.add(newList);
    }

    _onRefresh(BuildContext context) {
      BlocProvider.of<MealBloc>(context).add(GetMeal());
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber,
              Colors.amber[600],
            ],
          ),
        ),
        child: BlocProvider(
          create: (context) => MealBloc(),
          child: BlocBuilder<MealBloc, MealState>(
            builder: (context, state) {
              return buildBlocListener(
                  _onRefresh, context, measuresAndIngredients);
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        meal.name,
        style: subHeadings.copyWith(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
      leading: null,
      backgroundColor: Colors.amber,
    );
  }

  BlocListener<MealBloc, MealState> buildBlocListener(
      _onRefresh(BuildContext context),
      BuildContext context,
      List<String> measuresAndIngredients) {
    return BlocListener<MealBloc, MealState>(
      listener: (context, state) {
        if (state is MealLoadedError) {
          return Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('Meal Load Failed'),
            ),
          );
        }

        if (state is MealLoadedSuccess) {
          setState(() {
            meal = state.meal;
          });

          return Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent,
              content: Text('Meal Loading success'),
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          _onRefresh(context);
        },
        child: buildListView(context, measuresAndIngredients),
      ),
    );
  }

  ListView buildListView(
      BuildContext context, List<String> measuresAndIngredients) {
    return ListView(
      children: [
        Stack(
          children: [
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                meal.thumb ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.orangeAccent.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    meal.name ?? "",
                    style: headings.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        buildBottomSection(measuresAndIngredients)
      ],
    );
  }

  Padding buildBottomSection(List<String> measuresAndIngredients) {
    final double sizedBoxHeight = 10.0;
    _launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            INGREDIENTS + " and their " + MEAUSRES_TEXT,
            style: subHeadings.copyWith(
              color: Colors.white,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            measuresAndIngredients.join(),
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            INSTRUCTIONS_TEXT,
            style: subHeadings.copyWith(
              color: Colors.white,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            meal.instructions ?? "",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Category",
            style: subHeadings.copyWith(
              color: Colors.white,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            meal.category ?? "No Category",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Tags",
            style: subHeadings.copyWith(
              color: Colors.white,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            meal.tags ?? "No Tags",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Actions",
            textAlign: TextAlign.center,
            style: subHeadings.copyWith(
              color: Colors.white,
              fontSize: 23,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          buildFinalRow(sizedBoxHeight, _launchURL)
        ],
      ),
    );
  }

  Row buildFinalRow(
      double sizedBoxHeight, Future<dynamic> _launchURL(dynamic url)) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(
              sizedBoxHeight,
            ),
          ),
          child: RaisedButton.icon(
            icon: Icon(
              Icons.youtube_searched_for,
              color: Colors.white,
            ),
            color: Colors.red,
            elevation: 10,
            padding: EdgeInsets.symmetric(
              vertical: sizedBoxHeight * 2,
              horizontal: sizedBoxHeight * 3,
            ),
            onPressed: () => _launchURL(meal.youtube),
            label: Text(
              "Youtube",
              style: subHeadings.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(
              sizedBoxHeight,
            ),
          ),
          child: RaisedButton.icon(
            icon: Icon(
              Icons.link,
              color: Colors.white,
            ),
            color: Colors.deepPurpleAccent,
            elevation: 10,
            padding: EdgeInsets.symmetric(
              vertical: sizedBoxHeight * 2,
              horizontal: sizedBoxHeight * 3,
            ),
            onPressed: () => _launchURL(meal.source),
            label: Text(
              "Source",
              style: subHeadings.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }
}
