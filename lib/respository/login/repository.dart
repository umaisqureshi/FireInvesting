import 'package:MOT/models/user/user_model.dart';
import 'package:MOT/respository/login/login_client.dart';

class LoginRepository extends LoginClient {
  
  Future<SingleUserModel> fetchLogin({String email, String password}) async {
    return await super.login(email, password);
  }

}