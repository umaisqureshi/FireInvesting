import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MOT/models/user/user_model.dart';

class LoginClient {


  Future<SingleUserModel> login(email, password) async {
    SingleUserModel loginDataModel = SingleUserModel();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await FirebaseFirestore.instance.collection('User').doc(value.user.uid).get().then((user) {
          var map = {
            "id": value.user.uid,
            "name": user.data()['name'],
            "email": value.user.email,
            "image": value.user.photoURL??'default',
            "type":user.data()['type'],
            "guruStatus":user.data()['guruStatus']
          };
          loginDataModel = SingleUserModel.fromJson(map);
        });
      });
    return loginDataModel;
  }
}