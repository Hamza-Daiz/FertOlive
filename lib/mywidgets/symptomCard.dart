import 'package:ferolive/Screens/singleMaladie.dart';
import 'package:ferolive/models/maladie_model.dart';
import 'package:flutter/material.dart';

import '../constances.dart';

Container SymptomeCard(double withscreen, Map<String, dynamic> data,
    BuildContext context, String title) {
  
  return Container(
    height: 170,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
     // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.softLight),
      image: NetworkImage(data["image"]),
      fit: BoxFit.cover,
    )),
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SingleMaladie(
              title: title,
              maladieModel: MaladieModel(
                  title: data["title"],
                  text: data["text"],
                  image: data["image"]),
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.center,
            height: 35,
            decoration: BoxDecoration(
              color: KprimaryColor,
           borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10),),
           /*gradient: LinearGradient(
              colors: [
                 Colors.black.withOpacity(0.05),
                const Color(0xFF000000),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),*/
            ),

            child: Text(
              data["title"],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontFamily: "montseratSem",
              ),
            ),
          ),

        ],
      ),
    ),
  );
}
