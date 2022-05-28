import 'package:ferolive/Screens/singleMaladie.dart';
import 'package:ferolive/constances.dart';
import 'package:ferolive/models/maladie_model.dart';
import 'package:ferolive/mywidgets/symptomCard.dart';
import 'package:ferolive/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class MaladiesScreen extends StatefulWidget {

  @override
  _MaladiesScreenState createState() => _MaladiesScreenState();
}

class _MaladiesScreenState extends State<MaladiesScreen> {
  final _cityTextController = TextEditingController();

  String searchString;

  bool startSearch = false;

  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 5),
      child: Container(
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
                valueColor: AlwaysStoppedAnimation<Color>(KsecondaryColor),
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
      ),
    );
  }

}

