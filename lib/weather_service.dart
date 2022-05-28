import 'dart:convert';

import 'package:ferolive/models/weather_models.dart';
import 'package:http/http.dart' as http;
import 'package:ferolive/Screens/homeScreen.dart';

class WeatherService {

  Future<WeatherResponse> getWeather({String city}) async {

    final queryParameters = {
      'q': city,
      'key': '7e017b1a4916493db8f94225211408',
      'aqi':'no',
      'lang':'fr',
    };

    final url = Uri.https(
        "api.weatherapi.com", "/v1/current.json", queryParameters);

    final response = await http.get(url);

    final json = jsonDecode(response.body);

    if(json==null){
      cityShown = "Marrakech";
      final response = await http.get(Uri.https(
        "api.weatherapi.com", "/v1/current.json",  {
        'q': "Marrakech",
        'key': '7e017b1a4916493db8f94225211408',
        'aqi':'no',
      },),);
      final _json = jsonDecode(response.body);
      return WeatherResponse.fromJsom(_json);
    }else{
      return WeatherResponse.fromJsom(json);

    }
  }
}
