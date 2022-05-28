import 'package:ferolive/Screens/singleMaladie.dart';
import 'package:ferolive/constances.dart';
import 'package:ferolive/models/maladie_model.dart';
import 'package:ferolive/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ConseilScreen extends StatefulWidget {

  @override
  _ConseilScreenState createState() => _ConseilScreenState();
}

class _ConseilScreenState extends State<ConseilScreen> {

  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,), onPressed: (){Navigator.of(context).pop();}),
          backgroundColor: KprimaryColor,
          title: Text(
            "Recommandations & Conseils",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
              fontFamily: "poppins",
            ),
          ),

        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),

              Container(
                height: heightscreen ,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('conseils').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Une erreur est produite..'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(KsecondaryColor),
                      ));
                    }

                    if(!snapshot.hasData){
                      return Center(child: Text('Aucune Resultat..'),);
                    }


                    return ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SingleMaladie(
                                  title: "Recommandations & Conseils",
                                  maladieModel: MaladieModel(
                                    text: data["text"],
                                    title: data["title"],

                                  ),
                                  owner:data["owner"] ,
                                )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top:10),
                                width: withscreen -40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["title"],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "caliburn"
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      data["text"],
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(

                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          data["owner"],
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Divider(height: 1,),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}