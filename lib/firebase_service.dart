import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:ferolive/models/user_model.dart';

class FireService {
  FirebaseFirestore fire = FirebaseFirestore.instance;

  Future setUserData({User user, String name, String password,String email,String region,String ville}) async {

    await fire.collection("UsersProfiles").doc(user.uid).set({
      "name": name??"",
      "phone": user.phoneNumber,
      "password": password,
      "id": user.uid,
      "email": email??"",
      "adress": region??"",
      'ville': ville??"",
    });

  }

  Future<Usermodel> getUserData(String phone) async {

    Usermodel usermodel = new Usermodel();
    try {
      var user = await fire
          .collection("UsersProfiles")
          .where(
            "phone",
            isEqualTo: phone,
          )
          .get();

      user.docs.forEach((element) {
        usermodel = Usermodel.fromJson(element.data());
      });
    } catch (e) {
      print(e);
    }
    return usermodel;
  }

  bool isPasswordCorrect(String password,Usermodel user){
    if(password == user.password) return true;
    return false;
  }

  Future SignOut()async{

    try{

    return await FirebaseAuth.instance.signOut();
    }
    catch(e){
      print(e.toString());

    }
  }

  Future removeUser({String id})async{
   try {
     fire.collection("UsersProfiles").doc(id).delete();
     return true;
   }catch(e){
     return false;
   }
  }

}
