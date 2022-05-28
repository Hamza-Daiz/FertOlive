import 'package:ferolive/constances.dart';
import 'package:flutter/material.dart';


class RapportScreen extends StatefulWidget {

  String N;
  String P;
  String K;
  RapportScreen({this.N,this.P,this.K});


  @override
  _RapportScreenState createState() => _RapportScreenState();
}

class _RapportScreenState extends State<RapportScreen> {
  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body:  Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: withscreen,
                height: heightscreen/4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: KprimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/images/olive.png",height: heightscreen/5,),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Olive",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "montseratBold"
                            ),
                          ),

                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                "Marrakech, Maroc",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "montseratReg",
                                ),
                              ),
                            ],
                          )



                        ],
                      ),
                    ),


                  ],
                ),

              ),

              SizedBox(height: 20,),

              Text(
                "Notre Recommadation",
                style: TextStyle(
                  color: KprimaryColor,
                  fontSize: 18,
                  fontFamily: "montseratSem",
                ),
              ),

              SizedBox(height: 20,),

              Row(
                children: [

                  ShapeResult(widget.N,"N"),
                  ShapeResult(widget.P,"P"),
                  ShapeResult(widget.P,"K"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container ShapeResult(String nbr,String str) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 90,
                  width: 90,
                  child: Stack(
                    children: [

                      Positioned(
                        top: 20,

                        child: Container(
                          height: 60,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: KprimaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            nbr,
                            style: TextStyle(
                              color: Colors.white,
                                fontFamily: "monseratMed",
                                fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: KlightColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              str,
                              style: TextStyle(fontFamily: "monseratSem",
                                fontSize: 18
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                );
  }
}
