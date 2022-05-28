class MaladieModel{

  String title;
  String text;
  String image;

  MaladieModel({this.title,this.text,this.image,});

  MaladieModel.fromJson(Map<String,dynamic> json){
    title = json["title"];
    text = json["text"];
    image = json["image"];

  }

}