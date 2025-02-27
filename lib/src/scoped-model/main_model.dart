import 'package:food_app_flutter_zone/src/scoped-model/user_scoped_model.dart';

import '../scoped-model/food_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {
  FoodModel foodModel = FoodModel();
  UserModel userModel = UserModel();

  void fetchAll() {
    foodModel.fetchFoods();
    userModel.fetchUserInfos();
  }
}
