import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:MOT/models/user/user_model.dart';

class RegisterClient {


  Future<SingleUserModel> register(SingleUserModel  singleUserModel) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: singleUserModel.email, password: singleUserModel.password)
        .then((value) async {
          await _addImageToFirebase(singleUserModel.imageFile).then((image) async {
            var map = {
              "id": value.user.uid,
              "name": singleUserModel.name,
              "email": value.user.email,
              "type":singleUserModel.getType,
              "guruStatus":singleUserModel.isGuru()?"pending":"n/a",
              "image": image
            };
            await FirebaseFirestore.instance.collection('User').doc(value.user.uid).set(map, SetOptions(merge: true)).then((value) {
              singleUserModel = SingleUserModel.fromJson(map);
            });
      });
    });
    return singleUserModel;
  }

  Future<dynamic> _addImageToFirebase(File file) async {
    StorageReference ref = FirebaseStorage.instance.ref()
        .child("profile/${DateTime.now().millisecondsSinceEpoch}.jpg");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

}