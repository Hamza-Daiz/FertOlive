import 'package:ferolive/models/user_model.dart';
import 'package:ferolive/providers/loader_provider.dart';
import 'package:ferolive/widgets/progressHUD.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:ferolive/Screens/homeScreen.dart';
import 'package:ferolive/constances.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_service.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  String _userName = "";
  String _phone;
  String _pin;
  String _password;

  FireService _fireService;

  bool loading = false;

  int choice = 1;
  bool _obscure = true;

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString("userId", user.uid);
          sharedPreferences.setInt("isSign", 1);
          sharedPreferences.setString("userName", _userName);
          sharedPreferences.setString("userPhone", phone);

          await _fireService.setUserData(
              user: user, name: _userName, password: _password);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    userId: user.uid.toString(),
                userPhone: phone,
                  )));
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
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setString("userId", user.uid);
                          sharedPreferences.setInt("isSignin", 1);
                          sharedPreferences.setString("userName", _userName);
                          sharedPreferences.setString("userPhone", phone);

                          await _fireService.setUserData(
                              user: user, password: _password, name: _userName);

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    userPhone: phone,
                                    userId: user.uid.toString(),
                                      ),),);
                        } else {
                          print("error");
                        }
                      },
                      child: Text("confirmer")),
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: null,
    );

  }

  Future<bool> SignInUser(String phone, String password, BuildContext context) async {
    Usermodel _usermodel = new Usermodel();

    _usermodel = await _fireService.getUserData(phone);

    if (_fireService.isPasswordCorrect(password, _usermodel)) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("userId", _usermodel.id);
      sharedPreferences.setInt("isSignin", 1);
      sharedPreferences.setString("userPhone", phone);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                userId: _usermodel.id,
            userPhone: phone,
              )));
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Le numéro ou le mot de passe est incorrecte..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);

      setState(() {
        loading= false;
      });
      return false;
    }
  }

  @override
  void initState() {
    _fireService = new FireService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final iskeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: withscreen,
            height: heightscreen,
            child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                    height: 70,
                    margin: EdgeInsets.only(top: 100,bottom: 80),
                    child: Image.asset("assets/images/fo_icon.png"),
                ),

                // Sign IN ------
                Visibility(
                  visible: choice == 1,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                margin: EdgeInsets.only(top: 10),
                                width: withscreen - 40,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(color: KprimaryColor),
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

                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                margin: EdgeInsets.only(top: 10),
                                width: withscreen - 40,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(color: KprimaryColor),
                                ),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: passwordController,
                                    obscureText: _obscure,
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorColor: KprimaryColor,
                                    decoration: InputDecoration(
                                      hintText: 'Mot de passe',
                                      hintStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "entrer votre mot de passe..";
                                      }
                                      if (value.toString().length < 6) {
                                        return "entrer un mot de passe fort <6..";
                                      }
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscure = !_obscure;
                                      });
                                    },
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: KdarkColor,
                                    ),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: withscreen - 40,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Mot de passe oublié?",
                                    style: TextStyle(
                                      color: KprimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () async {

                                  setState(() {
                                    loading = true;
                                  });

                                  FocusScope.of(context).unfocus();

                                  await SignInUser(_phone,
                                      _password, context);

                                  setState(() {
                                    loading = false;
                                  });


                                },
                                child: Container(
                                  width: withscreen - 40,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: KprimaryColor,
                                  ),
                                  child: Text(
                                    "Se connecter",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "poppins"
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),
                              loading != false ?
                              Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
                                ),
                              ) : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sign UP ------
                Visibility(
                  visible: choice == 2,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey1,
                          child: Column(
                            children: [

                              Container(
                                alignment: Alignment.center,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                margin: EdgeInsets.only(top: 10),
                                width: withscreen - 40,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: KprimaryColor),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ListTile(
                                  title: TextFormField(
                                    keyboardType: TextInputType.name,
                                    cursorColor: KprimaryColor,
                                    decoration: InputDecoration(
                                      hintText: 'Nom Complet',
                                      hintStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _userName = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Entrez votre nom s'il vous plait ";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),

                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                margin: EdgeInsets.only(top: 10),
                                width: withscreen - 40,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: KprimaryColor),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: ListTile(
                                  title: TextFormField(
                                    obscureText: _obscure,
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorColor: KprimaryColor,
                                    decoration: InputDecoration(
                                      hintText: 'Mot de passe',
                                      hintStyle: TextStyle(
                                          color: Colors.grey
                                      ),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "entrer votre mot de passe..";
                                      }
                                      if (value.toString().length < 6) {
                                        return "entrer un mot de passe fort <6..";
                                      }
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscure = !_obscure;
                                      });
                                    },
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: KdarkColor,
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    EdgeInsets.only(top: 5,bottom: 5, left: 5,right: 5),
                                margin: EdgeInsets.only(top: 10),
                                width: withscreen - 40,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: KprimaryColor),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white),
                                child: IntlPhoneField(
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return "entrer votre mot de passe..";
                                    } else {
                                      return null;
                                    }
                                  },
                                  showDropdownIcon: true,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintTextDirection: TextDirection.ltr,
                                    hintText: "6/7 ** ** ** **",
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

                              SizedBox(height: 30,),

                              InkWell(
                                onTap: () {
                                  setState(() {
                                    loading = true;
                                  });

                                  FocusScope.of(context).unfocus();

                                  logUpUser(_phone, context);

                                  setState(() {
                                    loading = false;
                                  });

                                   },
                                child: Container(
                                  width: withscreen - 40,
                                  height: 60,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: KprimaryColor,
                                  ),
                                  child: Text(
                                    "Créer mon compte",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "poppins"
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),

                              loading != false ?
                              Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: KprimaryColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 1;
                          });
                        },
                        child: Container(
                          width: withscreen / 2 -1,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                            choice == 1 ? KprimaryColor : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Connexion",
                            style: TextStyle(
                              color: choice != 1 ? KprimaryColor : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 2;
                          });
                        },
                        child: Container(
                          width: withscreen / 2 -1,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                            choice == 2 ? KprimaryColor : Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(
                              color: choice != 2 ? KprimaryColor : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
