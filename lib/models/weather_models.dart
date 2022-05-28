

class WeatherResponse{

  final Location location;
  final WeatherInfo weatherInfo;

  WeatherResponse({this.location,this.weatherInfo});

  factory WeatherResponse.fromJsom(Map<String,dynamic> json){

    if(json!=null){

    final weatherInfoJson = json['current'];

    final weatherInfos = WeatherInfo.fromJsom(weatherInfoJson ?? {});

    final locationInfoJson = json['location'];
    final locationInfo = Location.fromJson(locationInfoJson??{});

    return WeatherResponse(location: locationInfo, weatherInfo : weatherInfos);
    }
    return WeatherResponse();

  }

}
class Location{
  String name;
  String region;
  String country;

  Location({this.name,this.region,this.country});

  factory Location.fromJson(Map<String,dynamic> json){

    final name = json['name'];
    final region = json['region'];
    final country = json['country'];

    return Location(name: name,region: region,country: country);
  }

}

class WeatherIcons{
  String url;
  String text;
  WeatherIcons({this.url,this.text});

  factory WeatherIcons.fromJson(Map<String,dynamic> json){

    final url = json['icon'];
    final text = json['text'];


    return WeatherIcons(url: url,text: text);
  }

}

class WeatherInfo{
  final double  temp ;
  final int humidity ;
  final String lastUpdate;
  final double wind_kph;
  final cloud;
  final WeatherIcons weatherIcons;

  WeatherInfo({this.temp,this.humidity,this.lastUpdate,this.wind_kph,this.weatherIcons,this.cloud});

  factory WeatherInfo.fromJsom(Map<String,dynamic> json){

    final conditionsInfoJson = json['condition'];
    final conditionsInfo = WeatherIcons.fromJson(conditionsInfoJson??{});

    final temp = json['temp_c'];
    final humidity = json['humidity'];
    final lastUpdate = json['last_updated'];
    final wind_kph = json['wind_kph'];
    final cloud = json["cloud"];

    return WeatherInfo(
      temp: temp,
      humidity: humidity,
      lastUpdate: lastUpdate,
      wind_kph: wind_kph,
      weatherIcons: conditionsInfo,
      cloud: cloud,
    );

  }

}





/*
{
    "location": {
        "name": "Agadir",
        "region": "",
        "country": "Morocco",
    },
    "current": {
        "last_updated": "2021-08-14 10:45",
        "temp_c": 30.2,
        "condition": {
            "text": "Partly cloudy",
            "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
        },
        "wind_mph": 2.7,
        "wind_kph": 4.3,
        "humidity": 44,

    }
}
 */