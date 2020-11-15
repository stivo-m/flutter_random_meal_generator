import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_meal_generator/bloc/meal_bloc.dart';
import 'package:random_meal_generator/widgets/widgets.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  // temporary vars
  String title = "RacPii";
  final double sizedBoxHeight = 10.0;
  bool isMealLoading = false;
  bool isSuccess = false;

  @override
  Widget build(BuildContext context) {
    _getMeal(BuildContext context) {
      setState(() {
        isMealLoading = true;
      });
      BlocProvider.of<MealBloc>(context).add(GetMeal());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: subHeadings.copyWith(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        leading: null,
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                return buildBlocListener(_getMeal, context);
              },
            ),
          ),
        ),
      ),
    );
  }

  BlocListener<MealBloc, MealState> buildBlocListener(
      _getMeal(BuildContext context), BuildContext context) {
    return BlocListener<MealBloc, MealState>(
      listener: (context, state) {
        if (state is MealLoading) {
          isMealLoading = true;
        }

        if (state is MealLoadedError) {
          isMealLoading = false;
          return Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('Meal Load Failed'),
            ),
          );
        }

        if (state is MealLoadedSuccess) {
          isMealLoading = false;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => CustomMealCard(
                meal: state.meal,
              ),
            ),
          );
          return Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.greenAccent,
              content: Text('Meal Loading success'),
            ),
          );
        }
      },
      child: !isMealLoading
          ? buildCenterTile(_getMeal, context)
          : buildCircularLoader(),
    );
  }

  Center buildCircularLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Center buildCenterTile(_getMeal(BuildContext context), BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ARE_YOU_HUNGRY,
            textAlign: TextAlign.center,
            style: headings.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: sizedBoxHeight * 2,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                sizedBoxHeight,
              ),
            ),
            child: RaisedButton(
              color: Colors.white,
              elevation: 10,
              padding: EdgeInsets.symmetric(
                vertical: sizedBoxHeight * 2,
                horizontal: sizedBoxHeight * 3,
              ),
              onPressed: () => _getMeal(context),
              child: Text(
                GET_MEAL_TEXT,
                style: subHeadings.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
