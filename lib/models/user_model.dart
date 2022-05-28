
class Usermodel{

  String name;
  String phone;
  String email;
  String id;
  String password;
  String region;
  String ville;

  Usermodel({this.name,this.phone,this.email,this.id,this.password,this.region});

  Usermodel.fromJson(Map<String,dynamic> json){
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    region = json["region"];
    ville =json["ville"];
    id = json["id"];
    password = json["password"];

  }

}