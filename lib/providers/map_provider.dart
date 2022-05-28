import 'package:flutter/cupertino.dart';

class GeoMapProvider with ChangeNotifier{

  String currentLocalisation;

  setData({String currentLocation,}){
    currentLocalisation = currentLocation;
    notifyListeners();
  }

}