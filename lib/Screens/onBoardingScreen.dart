import 'package:ferolive/Screens/homeScreen.dart';
import 'package:ferolive/Screens/signScreen.dart';
import 'package:ferolive/constances.dart';
import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  List<PageViewModel> getPages = [
    PageViewModel(
      footer: Text(
              "@Hitec.appDev",
               style: TextStyle(

                 ),
           ),
      image: Image.asset(
        "assets/images/on_1.png",
        height: 220,
      ),
      titleWidget: Text(
        "Bienvenue chez FERTOLIVE",
        style: TextStyle(
          color: KnatureColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body:
          "Nous sommes un groupement de specialistes qui ont pour but aider les l'agriculteurs ameliorer leurs rendements et mieux comprendre le sol. ",
    ),

    PageViewModel(
      footer: Text(
        "@Hitec.appDev",
        style: TextStyle(

        ),
      ),
      image: Image.asset(
        "assets/images/on_2.png",
        height: 220,
      ),
      titleWidget: Text(
        "Bienvenue chez FERTOLIVE",
        style: TextStyle(
          color: KnatureColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body:
      "Nous sommes un groupement de specialistes qui ont pour but aider les l'agriculteurs ameliorer leurs rendements et mieux comprendre le sol. ",
    ),

    PageViewModel(
      footer: Text(
        "@Hitec.appDev",
        style: TextStyle(

        ),
      ),
      image: Image.asset(
        "assets/images/on_3.png",
        height: 220,
      ),
      titleWidget: Text(
        "Bienvenue chez FERTOLIVE",
        style: TextStyle(
          color: KnatureColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body:
      "Nous sommes un groupement de specialistes qui ont pour but aider les l'agriculteurs ameliorer leurs rendements et mieux comprendre le sol. ",
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState

    setInit();

    super.initState();
  }

  Future<void> setInit()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("initState", 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(

        dotsDecorator: DotsDecorator(
          activeColor: KnatureColor,
          activeSize: Size(22, 10.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        ),

        pages: getPages,

        done: Container(
          height: 43,
          width: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: KnatureColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "Fin",
            style: TextStyle(color: Colors.white),
          ),
        ),

        onDone: () =>

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignScreen(),),),

        skip: Container(
          height: 43,
          width: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: KnatureColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "Sauter",
            style: TextStyle(color: Colors.white),
          ),
        ),
        showSkipButton: false,

        onSkip: () => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignScreen(),),),

        next: Container(
          height: 43,
          width: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: KnatureColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "Suivant",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
