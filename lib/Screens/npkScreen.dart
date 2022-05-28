import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferolive/Screens/RapportScreen.dart';
import 'package:ferolive/Screens/nkpFormScreen.dart';
import 'package:flutter/material.dart';
import 'package:ferolive/constances.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NpkScreen extends StatefulWidget {
  
  String userId;
  NpkScreen({this.userId});

  @override
  _NpkScreenState createState() => _NpkScreenState();
}

class _NpkScreenState extends State<NpkScreen> {



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    print(widget.userId);


    return Container(
      margin: const EdgeInsets.all(10.0),
      width: withscreen ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 5),
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('UsersProfiles').doc(widget.userId).collection("npk").snapshots(),

                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Une erreur est produite..'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(KsecondaryColor),
                      ),);
                    }

                    if(!snapshot.hasData){
                      return Center(child: Text('Aucune Resultat..'),);
                    }


                    return ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>RapportScreen(
                                  N:data["n"],
                                  P:data["p"],
                                  K:data["k"],
                                ),
                            ),);
                          },
                          child: Container(
                            width: withscreen,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Stack(
                              children: [
                                Padding(

                                  padding: EdgeInsets.only(top:heightscreen/9 -heightscreen/21,),
                                  child: Container(
                                    height: heightscreen/8,
                                    width: withscreen,
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: KprimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text("N: ",style: TextStyle(color: Colors.white),),
                                            Text(data["n"],style: TextStyle(color: Colors.white),),

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("P: ",style: TextStyle(color: Colors.white),),
                                            Text(data["p"],style: TextStyle(color: Colors.white),),

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("K: ",style: TextStyle(color: Colors.white),),
                                            Text(data["k"],style: TextStyle(color: Colors.white),),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    width: withscreen/4,
                                    height: heightscreen/9,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: KlightColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/olive_bl.png",
                                          height: heightscreen/15,
                                        ),
                                        Text(
                                          "OLIVE",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "montseratSem",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            ),
          ),

        ],
      ),
    );
  }
}
