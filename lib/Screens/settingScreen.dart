import 'package:ferolive/Screens/onBoardingHome.dart';
import 'package:ferolive/Screens/profileScreen.dart';
import 'package:ferolive/Screens/signScreen.dart';
import 'package:ferolive/models/user_model.dart';
import 'package:ferolive/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constances.dart';


class SettingScreen extends StatefulWidget {

  Usermodel usermodel ;
  SettingScreen(this.usermodel);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {


  String _name ;

  @override
  void initState() {
    // TODO: implement initState
    _name =  widget.usermodel.name;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal:15.0),
      child: Column(
        children: [
          SizedBox(height: 20,),

          //----- Hello Section : -------
          Column(
            children: [
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: KprimaryColor,
                  border: Border.all(color: KprimaryColor),

                ),
                child: Text(
                  _name.substring(0,1),
                  style: TextStyle(
                    fontSize: 55,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 5,),
              Text(
                "Bon Jour " + _name.substring(0,_name.indexOf(' ')).toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  color: KprimaryColor,
                  fontFamily: "monserat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 20,),

          //----- Hello Section : -------

          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  ProfileScreen(
                    userPhone: widget.usermodel.phone,
                    userID: widget.usermodel.id,
                    usermodel: widget.usermodel,
                  ),
                ),
              );
            },
            child: Container(
              width: withscreen*0.8,
              height: 50,
              decoration: BoxDecoration(
                color: KprimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white,size: 30,),
                title: Text(
                  "Mon Compte",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "monseratReg",
                      fontSize: 18
                  ),
                ),

              ),
            ),
          ),

          SizedBox(height: 10,),

          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OnBoardingHome()));
            },
            child: Container(
              width: withscreen*0.8,
              height: 50,
              decoration: BoxDecoration(
                color: KprimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.tab_outlined,
                  color: Colors.white,size: 30,),
                title: Text(
                  "Onboarding",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "monseratReg",
                      fontSize: 18
                  ),
                ),

              ),
            ),
          ),

          SizedBox(height: 10,),

          InkWell(
            onTap: () async {
              SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
              sharedPreferences.setString("userId", "");

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SignScreen(),
                ),
              );
            },
            child: Container(
              width: withscreen*0.8,
              height: 50,
              decoration: BoxDecoration(
                color: KprimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.logout,size: 30,color: Colors.white,),
                title: Text("Se deconnecter",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "monseratReg",
                      fontSize: 18
                  ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
