import 'package:ferolive/Screens/singleMaladie.dart';
import 'package:ferolive/constances.dart';
import 'package:ferolive/models/maladie_model.dart';
import 'package:ferolive/mywidgets/symptomCard.dart';
import 'package:ferolive/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class CarenceScreen extends StatefulWidget {

  @override
  _CarenceScreenState createState() => _CarenceScreenState();
}

class _CarenceScreenState extends State<CarenceScreen> {

  final _cityTextController = TextEditingController();

  String searchString;

  bool startSearch = false;

  int tab = 1;

  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    Widget _myWidget = CarrencesWidget(heightscreen, withscreen);

    return Padding(
      padding: const EdgeInsets.only(left:10.0,right: 10,top: 10 ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    tab=1;
                    _myWidget = CarrencesWidget(heightscreen, withscreen);

                  });
                },
                child: Container(
                  height: 50,
                  width: (withscreen*0.5 )-25,
                  decoration: BoxDecoration(
                    color:tab ==1? KprimaryColor: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Image.asset(tab !=1?"assets/icons/alert_green.png":"assets/icons/alert_white.png",height: 20,),

                      SizedBox(width: 10,),


                      Text(
                        "CARRENCES",
                        style: TextStyle(
                          color: tab !=1?KprimaryColor:Colors.white,
                          fontFamily: "monseratSem",

                        ),
                      ),
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: (){
                  setState(() {
                    tab=2;

                    _myWidget = MaladiesWidget(heightscreen, withscreen);

                  });
                },
                child: Container(
                  height: 50,
                  width: (withscreen*0.5 )-25,
                  decoration: BoxDecoration(
                    color:tab ==2? KprimaryColor: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Image.asset(tab !=2?"assets/icons/maladie_active.png":"assets/icons/maladie.png",height: 20,),

                      SizedBox(width: 10,),


                      Text(
                        "MALADIES",
                        style: TextStyle(
                          color: tab !=2?KprimaryColor:Colors.white,
                          fontFamily: "monseratSem",

                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),

          SizedBox(height: 5,),

          Visibility(
            visible: tab == 1,
            child: Expanded(
              child: CarrencesWidget(heightscreen, withscreen),
            ),
          ),

          Visibility(
            visible: tab==2,
            child: Expanded(
              child: MaladiesWidget(heightscreen, withscreen),
            ),
          ),

          SizedBox(height: 5,),
        ],
      ),
    );
  }

  Container MaladiesWidget(double heightscreen, double withscreen) {
    return Container(
            height: heightscreen,
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchString== "" || searchString == null )?

              FirebaseFirestore.instance.collection('maladies').snapshots() :
              FirebaseFirestore.instance.collection('maladies').where("searchIndex", arrayContains: searchString ).snapshots(),





              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Une erreur est produite..'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
                  ),);
                }

                if(!snapshot.hasData){
                  return Center(child: Text('Aucune Resultat..'),);
                }


                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return SymptomeCard(withscreen, data, context,"Maladie & Ravageurs");
                  }).toList(),
                );
              },
            ),
        );
  }

  Container CarrencesWidget(double heightscreen, double withscreen) {
    return Container(
              height: heightscreen,
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchString== "" || searchString == null )?

                FirebaseFirestore.instance.collection('carences').snapshots() :
                FirebaseFirestore.instance.collection('carences').where("searchIndex", arrayContains: searchString ).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Une erreur est produite..'));
                  }

                  if ( snapshot.connectionState == ConnectionState.waiting ) {
                    return Center(child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
                    ));
                  }

                  if(!snapshot.hasData){
                    return Center(child: Text('Aucune Resultat..'),);
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return SymptomeCard(withscreen, data, context,"Symptômes de carrence");
                    }).toList(),
                  );
                },
              ),
            );
  }

}