import 'package:flutter/material.dart';
import 'package:food_app_flutter_zone/src/admin/pages/add_food_item.dart';
import 'package:food_app_flutter_zone/src/models/food_model.dart';
import 'package:food_app_flutter_zone/src/scoped-model/main_model.dart';
import 'package:food_app_flutter_zone/src/widgets/food_item_card.dart';
import 'package:food_app_flutter_zone/src/widgets/show_dailog.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoritePage extends StatefulWidget {
  final MainModel model;

  FavoritePage({required this.model});
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  // the scaffold global key
  GlobalKey<ScaffoldState> _explorePageScaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.foodModel.fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _explorePageScaffoldKey,
      backgroundColor: Colors.white,
      body: ScopedModelDescendant<MainModel>(
        builder: (sctx, child, MainModel model) {
          //model.fetchFoods(); // this will fetch and notifylisteners()
          // List<Food> foods = model.foods;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: RefreshIndicator(
              onRefresh: model.foodModel.fetchFoods,
              child: ListView.builder(
                itemCount: model.foodModel.foodLength,
                itemBuilder: (BuildContext lctx, int index) {
                  return GestureDetector(
                    onTap: () async {
                      final bool response =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => AddFoodItem(
                                    food: model.foodModel.foods[index],
                                  )));

                      if (response) {
                        SnackBar snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Text(
                            "Food item successfully updated.",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        );
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    onDoubleTap: (){
                      // delete food item
                      showLoadingIndicator(context, "Deleting food item...");
                      model.foodModel.deleteFood(model.foodModel.foods[index].id).then((bool response){
                        Navigator.of(context).pop();
                      });
                    },
                    child: FoodItemCard(
                      model.foodModel.foods[index].name,
                      model.foodModel.foods[index].description,
                      model.foodModel.foods[index].price.toString(),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Container(
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 16.0),
//         child: ScopedModelDescendant<MainModel>(
//           builder: (BuildContext context, Widget child, MainModel model) {
//             model.fetchFoods();
//             List<Food> foods = model.foods;
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: foods.map((Food food){
//                 return FoodItemCard(
//                   food.name,
//                   food.description,
//                   food.price.toString(),
//                 );
//               }).toList(),
//             );
//           },
//         ),
//       )
