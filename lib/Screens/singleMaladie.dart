import 'package:ferolive/constances.dart';
import 'package:ferolive/providers/map_provider.dart';
import 'package:flutter/material.dart';

import 'package:ferolive/models/maladie_model.dart';
import 'package:provider/provider.dart';

class SingleMaladie extends StatefulWidget {

  MaladieModel maladieModel;
  String owner;
  String title;
  SingleMaladie({this.maladieModel,this.owner,this.title});

  @override
  _SingleMaladieState createState() => _SingleMaladieState();
}

class _SingleMaladieState extends State<SingleMaladie> {

  @override
  Widget build(BuildContext context) {
    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;
    return Scaffold(

        appBar:AppBar(
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,), onPressed: (){Navigator.of(context).pop();}),
          backgroundColor: KprimaryColor,
          title: Text(
            widget.maladieModel.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
              fontFamily: "poppins",
            ),
          ),
        ),

      body: ListView(
        children: [

           widget.maladieModel.image != null ?
            Container(
              width: withscreen -20,
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal:10.0,vertical: 5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage( widget.maladieModel.image,),
                    fit: BoxFit.cover,
                  ),

                  border: Border.all(color: KprimaryColor,width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),

            ) : Container(),

          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            child: Text(
              widget.maladieModel.text,
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),

          SizedBox(height: 10,),

         widget.owner != null ?
           Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                 widget.owner,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ) : Container(),

        ],
      ),
    );
  }
}
