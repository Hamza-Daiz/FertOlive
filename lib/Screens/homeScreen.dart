import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ferolive/Screens/carenceScreen.dart';
import 'package:ferolive/Screens/conseilScreen.dart';
import 'package:ferolive/Screens/contactScreen.dart';
import 'package:ferolive/Screens/maladieScreen.dart';
import 'package:ferolive/Screens/onBoardingScreen.dart';
import 'package:ferolive/Screens/profileScreen.dart';
import 'package:ferolive/Screens/settingScreen.dart';
import 'package:ferolive/Screens/signScreen.dart';
import 'package:ferolive/pdf/PDFApi.dart';
import 'package:ferolive/pdf/pfd_viewer.dart';
import 'package:flutter/gestures.dart';
import 'nkpFormScreen.dart';
import 'npkScreen.dart';

import 'package:ferolive/firebase_service.dart';
import 'package:ferolive/models/user_model.dart';
import 'package:ferolive/models/weather_models.dart';
import 'package:ferolive/providers/loader_provider.dart';
import 'package:ferolive/providers/map_provider.dart';
import 'package:ferolive/weather_service.dart';
import 'package:ferolive/widgets/progressHUD.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../constances.dart';
import 'onBoardingHome.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  String userId;
  String userPhone;
  HomeScreen({this.userId, this.userPhone});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String cityShown = "";

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  bool loadingPdf = false;
  int indexHome = 0;

  final _cityTextController = TextEditingController();

  final _weatherService = new WeatherService();
  WeatherResponse _response;

  Animation<double> animation;
  Animation<double> animationEnd;

  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 85.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    fireService = new FireService();

    testGeo();

    getUserInfo();

    getTheCurrentLocation();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Usermodel _usermodel;
  FireService fireService;

  String phoneForAcoout;
  String _userId;
  String _userName;
  String _adress;

  CollectionReference users =
      FirebaseFirestore.instance.collection('UsersProfiles');

  Future<void> updateUser(String adress, String city) {
    users.doc(_userId).get().then((document) {
      _adress = document["region"];
    });

    return _adress == null || _adress == ""
        ? users
            .doc(_userId)
            .update(
              {
                'region': adress,
                'ville': city,
              },
            )
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"))
        : null;
  }

  Future<void> getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    phoneForAcoout = sharedPreferences.getString("userPhone");

    _userId = sharedPreferences.getString("userId");

    _usermodel = await fireService.getUserData(phoneForAcoout);
    _userName = _usermodel.name;
  }

  String currentRegion = "";
  String currentCity = "";

  String lastUpdate = "";
  String longitude;
  String latitude;

  bool isLoad = false;

  void getTheCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var lati = position.latitude;
    var long = position.longitude;

    longitude = "$long";
    latitude = "$lati";

    final cordinates = await placemarkFromCoordinates(lati, long);
    var adresses = await cordinates.first;

    setState(() {
      currentCity = adresses.locality;
      cityShown = adresses.locality;
      currentRegion = adresses.administrativeArea;
    });

    await updateUser(currentRegion, currentCity);

    final response = await _weatherService.getWeather(city: currentCity);

    setState(() {
      _response = response;
      lastUpdate = _response.weatherInfo.lastUpdate;
    });
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (_response.weatherInfo.lastUpdate == null) {
      final response = await _weatherService.getWeather(city: "Marrakech");
      setState(() {
        _response = response;
        cityShown = "Marrakech";
        lastUpdate = _response.weatherInfo.lastUpdate;
      });
      Fluttertoast.showToast(
          msg: "Aucune information trouver pour votre position..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }

  Future<void> testGeo() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      final response = await _weatherService.getWeather(city: "Marrakech");
      setState(() {
        _response = response;
        cityShown = "Marrakech";
        lastUpdate = _response.weatherInfo.lastUpdate;
      });
    }
  }

  Future<void> _search() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    setState(() {
      isLoad = true;
    });

    try {
      final response = await _weatherService.getWeather(
          city: _cityTextController.text != null
              ? _cityTextController.text
              : currentCity);

      setState(() {
        _response = response;
      });

      cityShown = _cityTextController.text;
      _cityTextController.clear();
    } catch (e) {
      print(e);
      setState(() {
        isLoad = false;
      });
      Fluttertoast.showToast(
          msg: "Nous n'avons pas pu trouver de la ville ciblée",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
    setState(() {
      isLoad = false;
    });
  }

  DateTime timeBackPress = DateTime.now();

  Future<void> loading() async {
    await Future.delayed(Duration(milliseconds: 400));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  bool showChange = false;

  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    List<Widget> Widgets = [

      Home(withscreen),

      CarenceScreen(),

      NpkScreen(
        userId: _userId,
      ),

      SettingScreen(_usermodel),

    ];

    List<String> titles = [
      "FertOLive",
      "Carences",
      "Maladies",
      "Mon Compte",
    ];

    return WillPopScope(
      onWillPop: indexHome == 0
          ? () async {
              final different = DateTime.now().difference(timeBackPress);

              final isExitWarning = different >= Duration(seconds: 2);

              timeBackPress = DateTime.now();

              if (isExitWarning) {
                final message = "Press again to exit";
                Fluttertoast.showToast(msg: message, fontSize: 16);

                return false;
              } else {
                Fluttertoast.cancel();
                return true;
              }
            }
          : () {
              setState(() {
                // ignore: missing_return
                indexHome = 0;
              });
            },
      child: RefreshIndicator(
        color: KprimaryColor,
        onRefresh: loading,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              floatingActionButton: indexHome == 2
                  ? Padding(
                    padding: const EdgeInsets.only(bottom: 110),
                    child: FloatingActionButton(
                        backgroundColor: KprimaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NpkForm(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                  )
                  : null,
              backgroundColor: Colors.white,

              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Visibility(
                          visible: indexHome != 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: KprimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  indexHome = 0;
                                });
                              }),
                        ),
                        Visibility(
                          visible: indexHome == 0,
                          child: IconButton(
                              splashColor: Colors.white,
                              icon: Icon(
                                Icons.update,
                                color: Colors.white,
                              ),
                              onPressed: () {}),
                        ),
                        Expanded(
                          child: Image.asset(
                            "assets/images/fo_icon.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Visibility(
                          visible: indexHome != 0,
                          child: IconButton(
                              splashColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                loading();
                                testGeo();
                              }),
                        ),
                        Visibility(
                          visible: indexHome == 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.update,
                                color: KprimaryColor,
                              ),
                              onPressed: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                loading();
                                testGeo();
                              }),
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: Widgets[indexHome]),

                  //------------- Bottom BAr -------------

                  Container(
                    width: withscreen * 0.95,
                    margin: EdgeInsets.only(bottom: withscreen * 0.05),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: KprimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BottomIcon("assets/icons/home_active.png",
                            "assets/icons/home.png", 0, "ACCUEIL", withscreen),
                        BottomIcon(
                            "assets/icons/carrences_active.png",
                            "assets/icons/carences.png",
                            1,
                            "SYMPTOME",
                            withscreen),

                        SpeedDial(
                          child: Image.asset("assets/icons/scan.png"),
                          elevation: 0,

                          children: [
                            SpeedDialChild(
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: KprimaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  height: 60,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: KprimaryColor),

                            SpeedDialChild(
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: KprimaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  height: 60,
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: KprimaryColor),
                          ],
                        ),
                        BottomIcon("assets/icons/npk_active.png",
                            "assets/icons/npk.png", 2, "NKP", withscreen),
                        BottomIcon("assets/icons/setting_active.png",
                            "assets/icons/setting.png", 3, "PARAM", withscreen),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InkWell BottomIcon(String ictiveIcon, String icon, int indx, String title,
      double widthScreen) {
    return InkWell(
      onTap: () {
        setState(() {
          indexHome = indx;
        });
      },
      child: indexHome == indx
          ? Container(
              width: widthScreen * 0.17,
              height: 80,
              decoration: BoxDecoration(
                color: indexHome == indx ? Colors.white : KprimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ictiveIcon,
                    height: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: indexHome != indx ? Colors.white : KprimaryColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      fontFamily: "montseratMed",
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          : Container(
              width: widthScreen * 0.17,
              height: 80,
              decoration: BoxDecoration(
                color: indexHome == indx ? Colors.white : KprimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    height: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: indexHome != indx ? Colors.white : KprimaryColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }

  Widget Home(double withscreen) {

    void openPDF(BuildContext context, File file) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
    );

    return SingleChildScrollView(
      child: Column(
        children: [

          Container(
            color: Colors.white,
            height: 50,
            width: withscreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/location.png",
                  width: 30,
                  height: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                isLoad == false
                    ? Text(
                        (_response != null ? cityShown : currentCity) +
                            ", à " +
                            (_response != null &&
                                    _response.weatherInfo.lastUpdate != null
                                ? _response.weatherInfo.lastUpdate.substring(
                                    _response.weatherInfo.lastUpdate.length - 5)
                                : ""),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "montseratSem",
                        ),
                      )
                    : Container(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(KprimaryColor),
                        ),
                      ),
                Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: KprimaryColor,
                    ),
                    onPressed: () {

                      showGeneralDialog(
                        barrierLabel: "Barrier",
                        barrierDismissible: true,
                        barrierColor: KprimaryColor,
                        transitionDuration: Duration(milliseconds: 700),
                        context: context,
                        pageBuilder: (_, __, ___) {
                          return Align(
                            child: Container(
                              height: 230,
                              child: SizedBox.expand(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Image.asset("assets/images/fo_white.png",height: 40,),

                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Material(
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      _cityTextController,
                                                  onChanged: (val) {},
                                                  decoration: InputDecoration(
                                                    hintText: "La ville..",
                                                    hintStyle: TextStyle(
                                                      color: KprimaryColor.withOpacity(0.7),
                                                      fontFamily: "montseratReg",
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(

                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          _search();

                                          Navigator.pop(context);

                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Text(
                                          "SOUMETTRE",
                                          style: TextStyle(
                                            color: KprimaryColor,
                                            fontSize: 14,
                                            fontFamily: "monseratMed",
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              margin: EdgeInsets.only(
                                  bottom: 50, left: 12, right: 12),
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          );
                        },
                        transitionBuilder: (_, anim, __, child) {
                          return SlideTransition(
                            position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                            child: child,
                          );
                        },
                      );

                      showChange = !showChange;
                      if (showChange) {
                        controller.forward();
                      } else {
                        controller.reset();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: KnatureColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 90,
                width: (withscreen - 20) / 2 - 5,
                padding: EdgeInsets.symmetric(horizontal: withscreen / 35),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _response != null &&
                                      _response.weatherInfo.temp.toString() !=
                                          "null"
                                  ? Text(
                                      _response.weatherInfo.temp
                                              .toString()
                                              .substring(
                                                  0,
                                                  _response.weatherInfo.temp
                                                      .toString()
                                                      .indexOf('.')) +
                                          "°",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "montseratSem",
                                      ),
                                    )
                                  : Container(
                                      height: 30,
                                      width: 30,
                                      padding: EdgeInsets.all(3),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                              Text(
                                "c",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          _response != null &&
                                  _response.weatherInfo.weatherIcons.text
                                          .toString() !=
                                      "null"
                              ? Container(
                                  width: 70,
                                  child: Text(
                                    _response.weatherInfo.weatherIcons.text
                                        .toString()
                                        .replaceAll("Ã", "é")
                                        .replaceAll("©", "e"),
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontFamily: "montserat",
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  width: 30,
                                  padding: EdgeInsets.all(3),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        KprimaryColor),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/images/temperature.png",
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: KnatureColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 90,
                width: (withscreen - 20) / 2 - 5,
                padding: EdgeInsets.symmetric(horizontal: withscreen / 35),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _response != null &&
                                      _response.weatherInfo.wind_kph
                                              .toString() !=
                                          "null"
                                  ? Text(
                                      _response.weatherInfo.wind_kph
                                          .toString()
                                          .substring(
                                              0,
                                              _response.weatherInfo.wind_kph
                                                  .toString()
                                                  .indexOf('.')),
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "montseratSem",
                                      ),
                                    )
                                  : Container(
                                      height: 30,
                                      width: 30,
                                      padding: EdgeInsets.all(3),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                              Text(
                                " km/h",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: "montserat",
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 70,
                            child: Text(
                              "Vitesse du vent ",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "montserat",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/images/wind.png",
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: KnatureColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 90,
                width: (withscreen - 20) / 2 - 5,
                padding: EdgeInsets.symmetric(horizontal: withscreen / 35),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _response != null &&
                                      _response.weatherInfo.cloud.toString() !=
                                          "null"
                                  ? Text(
                                      _response.weatherInfo.cloud.toString() +
                                          " %",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "montseratSem",
                                      ),
                                    )
                                  : Container(
                                      height: 30,
                                      width: 30,
                                      padding: EdgeInsets.all(3),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                            ],
                          ),
                          Text(
                            "Précipitation",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontFamily: "montserat",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/images/cloud.png",
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: KnatureColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 90,
                width: (withscreen - 20) / 2 - 5,
                padding: EdgeInsets.symmetric(horizontal: withscreen / 35),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _response != null &&
                                      _response.weatherInfo.humidity
                                              .toString() !=
                                          "null"
                                  ? Text(
                                      _response.weatherInfo.humidity
                                              .toString() +
                                          " %",
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "montseratSem",
                                      ),
                                    )
                                  : Container(
                                      height: 30,
                                      width: 30,
                                      padding: EdgeInsets.all(3),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                            ],
                          ),
                          Text(
                            "Humidité",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "montserat",
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/images/humidity.png",
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 5,
          ),



          SizedBox(
            height: 5,
          ),

          Container(
            height: 280,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('trending').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasError) {
                  return Center(child: Text('Une erreur est produite..'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(loadingPdf == false ? KsecondaryColor :Colors.white),
                  ));
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Aucune Resultat..'),
                  );
                }

                return CarouselSlider(
                  options: CarouselOptions(
                    height: 280,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.7,
                    initialPage: 1,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () async{

                        setState(() {
                          loadingPdf = true;
                        });

                        final url = data["file"];
                        final file = await PDFApi.loadFirebase(url);

                        if(file== null) return ;
                        openPDF(context,file);

                        setState(() {
                          loadingPdf = false;
                        });
                        
                      },
                      child: Container(
                        height: 260,
                        width: withscreen - 60,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  KnatureColor.withOpacity(0.5),
                                  BlendMode.srcOver),
                              image: NetworkImage(data["img"]),
                              fit: BoxFit.cover,
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["title"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "montseratBold",
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loadingPdf!= false ?
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ) : Container(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  color: Colors.white,
                                  height: 2,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  data["owner"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "montseratReg",
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
