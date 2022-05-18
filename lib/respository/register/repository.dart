import 'package:MOT/models/user/user_model.dart';
import 'package:MOT/respository/login/login_client.dart';
import 'package:MOT/respository/register/register_client.dart';

class RegisterRepository extends RegisterClient {
  
  Future<SingleUserModel> fetchRegister({SingleUserModel singleUserModel}) async {
    return await super.register(singleUserModel);
  }

}