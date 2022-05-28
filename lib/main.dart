import 'dart:async';
import 'package:ferolive/Screens/onBoardingScreen.dart';
import 'package:ferolive/providers/loader_provider.dart';
import 'package:ferolive/providers/map_provider.dart';
import 'package:flutter/material.dart';

import 'package:ferolive/Screens/signScreen.dart';
import 'package:ferolive/constances.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/homeScreen.dart';

import 'package:firebase_core/firebase_core.dart';

String userId="";

int initState = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  userId = preferences.getString("userId");
  initState = preferences.getInt("initState") ?? 0;


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => LoaderProvider(),
          child: HomeScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => GeoMapProvider(),
        ),
      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        home:  initState == 0 ? OnBoarding() : userId !="" ? HomeScreen() : SignScreen(),
      ),
    ),
  );
}

/*
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignScreen()));
    }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -20.0,
              left: -20,
              top: -20,
              child: Image.asset(
                "assets/images/background_image_splash.png",
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset(
                "assets/images/ferolive_logo.png",
              ),
            ),
            Positioned(
              bottom: 50,
              right: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sponsorisée par:",
                    style: TextStyle(
                      color: KprimaryColor,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                      height: 30,
                      child: Image.asset("assets/images/inra_logo.png")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
