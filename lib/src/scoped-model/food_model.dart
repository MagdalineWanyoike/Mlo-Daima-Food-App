import 'dart:convert';

import 'package:food_app_flutter_zone/src/models/food_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class FoodModel extends Model {
  List<Food> _foods = [];
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<Food> get foods {
    return List.from(_foods);
  }

  int get foodLength {
    return _foods.length;
  }

  Future<bool> addFood(Food food) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> foodData = {
        "title": food.name,
        "description": food.description,
        "category": food.category,
        "price": food.price,
        "discount": food.discount,
      };
      final http.Response response = await http.post(
          Uri.https("https://flutter-food-a2151.firebaseio.com/foods.json"),
          body: json.encode(foodData));

      final Map<String, dynamic> responeData = json.decode(response.body);

      Food foodWithID = Food(
        id: responeData["name"],
        name: food.name,
        description: food.description,
        category: food.category,
        discount: food.discount,
        price: food.price,
        imagePath: '',
        ratings: 5,
      );

      _foods.add(foodWithID);
      _isLoading = false;
      notifyListeners();
      // fetchFoods();
      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
      // print("Connection error: $e");
    }
  }

  Future<bool> fetchFoods() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          Uri.https("https://flutter-food-a2151.firebaseio.com/foods.json"));

      // print("Fecthing data: ${response.body}");
      final Map<String, dynamic> fetchedData = json.decode(response.body);
      print(fetchedData);

      final List<Food> foodItems = [];

      fetchedData.forEach((String id, dynamic foodData) {
        Food foodItem = Food(
          id: id,
          name: foodData["title"],
          description: foodData["description"],
          category: foodData["category"],
          price: double.parse(foodData["price"].toString()),
          discount: double.parse(foodData["discount"].toString()),
          imagePath: '',
          ratings: 8,
        );

        foodItems.add(foodItem);
      });

      _foods = foodItems;
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The errror: $error");
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> updateFood(Map<String, dynamic> foodData, String foodId) async {
    _isLoading = true;
    notifyListeners();

    // get the food by id
    Food theFood = getFoodItemById(foodId);

    // get the index of the food
    int foodIndex = _foods.indexOf(theFood);
    try {
      await http.put(
          Uri.https(
              "https://flutter-food-a2151.firebaseio.com/foods/${foodId}.json"),
          body: json.encode(foodData));

      Food updateFoodItem = Food(
        id: foodId,
        name: foodData["title"],
        category: foodData["category"],
        discount: foodData['discount'],
        price: foodData['price'],
        description: foodData['description'],
        imagePath: '',
        ratings: 8,
      );

      _foods[foodIndex] = updateFoodItem;

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> deleteFood(String foodId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.delete(Uri.https(
          "https://flutter-food-a2151.firebaseio.com/foods/${foodId}.json"));

      // delete item from the list of food items
      _foods.removeWhere((Food food) => food.id == foodId);

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Food getFoodItemById(String foodId) {
    late Food food;
    for (int i = 0; i < _foods.length; i++) {
      if (_foods[i].id == foodId) {
        food = _foods[i];
        break;
      }
    }
    return food;
  }
}
