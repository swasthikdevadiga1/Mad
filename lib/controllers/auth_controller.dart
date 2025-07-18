import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  var user = Rxn<UserModel>();

  void login(UserModel userModel) {
    user.value = userModel;
print('User logged in: ${userModel.id}');
  }

  void logout() {
    user.value = null;
  }
}