import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferolive/Screens/homeScreen.dart';
import 'package:ferolive/Screens/onBoardingHome.dart';
import 'package:ferolive/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constances.dart';
import '../firebase_service.dart';
import 'signScreen.dart';

class ProfileScreen extends StatefulWidget {

  String userPhone;
  String userID;
  Usermodel usermodel;
  ProfileScreen({this.userPhone,this.userID,this.usermodel});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final keyForm = GlobalKey<FormState>();

  TextEditingController nameControl = TextEditingController();
  TextEditingController phoneControl = TextEditingController();
  TextEditingController emailControl = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FireService _fireService ;
  Usermodel _usermodel ;
  String _pin;

  bool load = false;

  String _name;
  String _email ;
  String _phone ;
  String _password;
  String _region;
  String _ville;

  CollectionReference users = FirebaseFirestore.instance.collection('UsersProfiles');

  Future<void> updateUser() {
    return users
        .doc(widget.userID)
        .update(
      {
        'name': _name,
        'email': _email,
        'phone': _phone,
        'password': _password,
        'region': _region,
        'ville': _ville,
      },

        ).then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  
  Future<bool> logUpUser(String phone, BuildContext context) async {

    FirebaseAuth _auth = await FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();

        UserCredential result = await _auth.signInWithCredential(credential);
        User user = result.user;

        if (user != null) {
          _usermodel.phone = phone;

          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          sharedPreferences.setString("userId", user.uid);
          sharedPreferences.setInt("isSign", 1);


          await updateUser();


          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfileScreen(
            userID: user.uid,
            userPhone: phone,
            usermodel: _usermodel,
          ),),);

        }
      },
      verificationFailed: (FirebaseAuthException exeption) {
        print(exeption);
      },
      codeSent: (String vereficationID, [int forceREsendingToken]) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Entrer le numero reçus"),
                content: OTPTextField(
                  length: 6,
                  onCompleted: (pin) {
                    setState(() {
                      _pin = pin;
                    });
                  },
                ),
                actions: [
                  FlatButton(
                      onPressed: () async {


                        AuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: vereficationID, smsCode: _pin);

                        UserCredential result =
                        await _auth.signInWithCredential(credential);

                        User user = result.user;

                        if (user != null) {
                          _usermodel.phone = phone;

                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          sharedPreferences.setString("userId", user.uid);
                          sharedPreferences.setInt("isSignin", 1);

                          await updateUser();


                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfileScreen(
                            userID: user.uid,
                            userPhone: phone,
                            usermodel: _usermodel,
                          ),),);

                        } else {
                          print("error");
                        }
                      },
                      child: Text("confirmer"),
                  ),
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: null,
    );

  }

  @override
  void initState()  {
    // TODO: implement initState
    _fireService = new FireService();

    _usermodel = widget.usermodel;

    _name = _usermodel.name;
    _email = _usermodel.email;
    _phone = _usermodel.phone;
    _password= _usermodel.password;
    _region = _usermodel.region;
    _ville =_usermodel.ville;

    super.initState();
  }

  int index = 0 ;

  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,color: KprimaryColor,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body:Form(
        key: keyForm,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0),
            child: Column(
              children: [
                
                Text(
                  "infos Génerales",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                SizedBox(height: 20,),
                TextFormField(
                  initialValue: _name??"",

                  cursorColor: KnatureColor,
                  enableInteractiveSelection: true,

                  decoration: InputDecoration(
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: KnatureColor),

                    ),
                    labelText: "Nom complet",
                    border: OutlineInputBorder(),
                    focusColor: KnatureColor,
                  ),
                  onChanged: (val){
                    setState(() {
                      _name=val;
                      _usermodel.name = _name;
                    });
                  },

                ),

                SizedBox(height: 7,),

                TextFormField(

                  initialValue: _email??"",
                  cursorColor: KnatureColor,

                  decoration: InputDecoration(
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: KnatureColor),
                    ),
                    labelText: "adress e-mail",
                    border: OutlineInputBorder(),
                    focusColor: KnatureColor,
                  ),
                  onChanged: (val){
                    setState(() {
                      _email = val;
                      _usermodel.email = _email;
                    });
                  },

                ),

                SizedBox(height: 20,),

                TextFormField(

                  initialValue: _phone??"",
                  cursorColor: KnatureColor,

                  readOnly: true,

                  decoration: InputDecoration(
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: KnatureColor),
                    ),
                    labelText: "Téléphone",
                    border: OutlineInputBorder(),
                    focusColor: KnatureColor,
                  ),

                ),

                SizedBox(height: 20,),

                InkWell(
                  onTap: (){

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          final double withscreen = MediaQuery.of(context).size.width;

                          return AlertDialog(
                            title: Text("Entrer le nouveau numéro"),
                            content: Container(
                              alignment: Alignment.centerLeft,
                              padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              margin: EdgeInsets.only(top: 10),
                              width: withscreen - 40,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: Colors.white
                              ),

                              child: IntlPhoneField(
                                controller: phoneController,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return "entrer votre mot de passe..";
                                  } else {
                                    return null;
                                  }
                                },
                                showDropdownIcon: false,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintText: '6/7 ** ** ** **',
                                  hintStyle: TextStyle(
                                      color: Colors.grey
                                  ),
                                  labelStyle: TextStyle(color: KdarkColor),
                                  focusColor: KdarkColor,
                                  border: InputBorder.none,
                                ),
                                initialCountryCode: 'MA',
                                onChanged: (phone) {
                                  setState(() {
                                    _phone = phone.completeNumber;
                                  });
                                },
                              ),
                            ),
                            actions: [

                              InkWell(
                                onTap: () {

                                  setState(() {
                                    load = true;
                                  });

                                  logUpUser(_phone, context);

                                  setState(() {
                                    load=false;
                                  });

                                },
                                child: Container(
                                  width: withscreen - 40,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: KsecondaryColor,
                                  ),
                                  child: Text(
                                    "Verifier le numéro",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "poppins"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),

                              load != false ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(KnatureColor),
                                ),
                              ): Container(),

                            ],
                          );
                        });



                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: KnatureColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Changer mon numéro de téléphone",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                  child: Divider(height: 1,),
                ),

                SizedBox(height: 20,),


                TextFormField(
                  initialValue: _region??"",

                  cursorColor: KnatureColor,
                  enableInteractiveSelection: true,

                  decoration: InputDecoration(
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: KnatureColor),

                    ),
                    labelText: "Région",
                    border: OutlineInputBorder(),
                    focusColor: KnatureColor,
                  ),
                  onChanged: (val){
                    setState(() {
                      _region=val;
                      _usermodel.region = _region;
                    });
                  },

                ),
                SizedBox(height: 10,),


                TextFormField(
                  initialValue: _ville??"",

                  cursorColor: KnatureColor,
                  enableInteractiveSelection: true,

                  decoration: InputDecoration(
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: KnatureColor),

                    ),
                    labelText: "Ville",
                    border: OutlineInputBorder(),
                    focusColor: KnatureColor,
                  ),
                  onChanged: (val){
                    setState(() {
                      _ville=val;
                      _usermodel.ville = _ville;
                    });
                  },

                ),

                SizedBox(height: 30,),


                InkWell(
                  onTap: ()async{

                    setState(() {
                      load=true;
                    });

                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    await updateUser();

                    setState(() {
                      load=false;
                    });

                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: KnatureColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Enregister tout",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                ),

                SizedBox(height: 10,),

                load != false ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(KnatureColor),
                  ),
                ): Container(),
              ],
            ),
          ),
        ),
      ) ,
    )
      ;

  }

}
