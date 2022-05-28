
import 'dart:io';

import 'package:ferolive/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constances.dart';

import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:mailer/smtp_server.dart';


import '../firebase_service.dart';

class NpkForm extends StatefulWidget {

  @override
  _NpkFormState createState() => _NpkFormState();
}

class _NpkFormState extends State<NpkForm> {

  final keyForm = GlobalKey<FormState>();

  final keyAnalyse = GlobalKey<FormState>();



  int index = 0;
  int irig = 1;
  int analyse = 1;

  String modeIrri= "gravitaire" ;
  String modeFerti= "fertigation" ;

  String matiereOrganique = "";
  String phosphore = "";
  String potassium = "";
  String cn = "";
  String caco3 = "";
  String argile = "";

  String phoneForAcoout = "";

  Usermodel _usermodel ;
  FireService fireService;


  String Ha = "";

  double rendement = 8;


  @override
  void initState() {
    // TODO: implement initState

    fireService = new FireService();
    _usermodel = new Usermodel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final double withscreen = MediaQuery.of(context).size.width;
    final double heightscreen = MediaQuery.of(context).size.height;

    sendMail()async{
      String username = 'ferolive.app@gmail.com';
      String password = 'ferolive1234';

      // ignore: deprecated_member_use
      final smtpServer = gmail(username, password);
      // Use the SmtpServer class to configure an SMTP server:
      // final smtpServer = SmtpServer('smtp.domain.com');
      // See the named arguments of SmtpServer for further configuration
      // options.

      // Create our message.
      final message = Message()
        ..from = Address(username, 'Zakaria ElMakoubi')
        ..subject = "Demande de Formule NPK :: ${DateTime.now()}"
        ..recipients.add(username)
        ..text = 'idUser : ${_usermodel.id} . name : ${_usermodel.name}\n irig : $irig\n $modeIrri.\n $modeFerti.\n matiere organique : $matiereOrganique.\n '
            'phosphore : $phosphore.\n potasium :$potassium.\n'
            'cn : $cn.\n caco3 :$caco3.\n argile :$argile.\n'
       ;

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      // DONE


      // Let's send another message using a slightly different syntax:
      //
      // Addresses without a name part can be set directly.
      // For instance `..recipients.add('destination@example.com')`
      // If you want to display a name part you have to create an
      // Address object: `new Address('destination@example.com', 'Display name part')`
      // Creating and adding an Address object without a name part
      // `new Address('destination@example.com')` is equivalent to

    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(

          onPressed: (){
            if(index==0){
              Navigator.pop(context);
            }else{
              setState(() {
                index--;
              });
            }
            },

          icon: Icon(Icons.arrow_back_ios_sharp),

          color: KprimaryColor,
        ),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: keyForm,

          child: index ==0?

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choix de Culture",
                  style: TextStyle(
                    color: KprimaryColor,
                    fontFamily: "manseratSem",
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                InkWell(
                  onTap: (){
                    setState(() {
                      index = 1;
                    });
                  },
                  child: Container(
                    height: heightscreen/4 ,
                    width: withscreen/2 -10,
                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                        color: KprimaryColor,
                        borderRadius: BorderRadius.circular(13)
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/olive.png",
                          height: heightscreen/5,
                        ),
                        Text(
                          "OLIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "monseratMed",
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )

          : index ==1?

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Régime hydrique",
                  style: TextStyle(
                    color: KprimaryColor,
                    fontFamily: "manseratSem",
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      InkWell(
                        onTap: (){
                          setState(() {
                            irig=0;
                          });
                        },
                        child: Container(
                          width: withscreen/2-20,
                          height: 60,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: irig==0? KprimaryColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: KprimaryColor),

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bour",
                                style: TextStyle(
                                  color:irig==0?Colors.white:KprimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),

                      InkWell(
                        onTap: (){
                          setState(() {
                            irig=1;
                          });
                        },
                        child: Container(
                          width: withscreen/2-20,
                          height: 60,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: irig==1? KprimaryColor:Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: KprimaryColor),

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Irrigué",
                                style: TextStyle(
                                  color:irig==1? Colors.white:KprimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Visibility(
                  visible: irig==1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Mode d'irrigation",
                      style: TextStyle(
                        color: KprimaryColor,
                        fontFamily: "manseratSem",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),


                Visibility(
                  visible: irig==1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      InkWell(
                        onTap:(){
                          setState(() {
                            modeIrri="gravitaire";
                          });
                        },
                        child: Container(
                          width: withscreen/2-20,
                          height: 60,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: modeIrri=="gravitaire"? KprimaryColor :Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: KprimaryColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Gravitaire",
                                style: TextStyle(
                                  color: modeIrri=="gravitaire"? Colors.white:KprimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),

                      InkWell(
                        onTap:(){
                          setState(() {
                            modeIrri="goutte à goutte";
                          });
                        },
                        child: Container(
                          width: withscreen/2-20,
                          height: 60,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color:  modeIrri=="goutte à goutte"? KprimaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: KprimaryColor),

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Goutte à goutte",
                                style: TextStyle(
                                  color: modeIrri=="goutte à goutte"? Colors.white : KprimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Visibility(
                  visible: modeIrri=="goutte à goutte"&& irig==1,
                  child: Padding(
                    padding: const EdgeInsets.only(top:10,bottom: 10),
                    child: Text(
                      "Mode de fertilisation",
                      style: TextStyle(
                        color: KprimaryColor,
                        fontFamily: "manseratSem",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: modeIrri=="goutte à goutte"&& irig==1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      InkWell(
                        onTap:(){
                          setState(() {
                            modeFerti="fertigation";
                          });
                        },
                        child: Container(
                          width: withscreen/2-20,
                          height: 60,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: modeFerti == "fertigation"? KprimaryColor :Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: KprimaryColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Par fertigation",
                                style: TextStyle(
                                  color: modeFerti=="fertigation"? Colors.white:KprimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),

                      InkWell(
                        onTap:(){
                          setState(() {
                            modeFerti="epandage";
                          });
                        },
                        child: Container(
                          width: withscreen/2-20,
                          height: 60,
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color:  modeFerti=="epandage"? KprimaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: KprimaryColor),

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Par épandage",
                                style: TextStyle(
                                  color: modeFerti=="epandage"? Colors.white : KprimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(height: 2,),
                ),


                Padding(
                  padding: const EdgeInsets.only(top:10,bottom: 10),
                  child: Text(
                    "Surface",
                    style: TextStyle(
                      color: KprimaryColor,
                      fontFamily: "manseratSem",
                      fontSize: 20,
                    ),
                  ),
                ),

                Text(
                  "Saisez la superficie de votre parcelle (Ha)",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 10,),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),

                  decoration: BoxDecoration(
                    border: Border.all(color: KprimaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: Ha,
                          onChanged: (val){
                            setState(() {
                              Ha = val;
                            });
                          },
                          validator: (val){
                            if(val.isEmpty){
                              return "Entrez la superficie de la parcelle..";
                            }
                            else return null;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Superficie de la parcelle",
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                            ),
                          ),

                        ),
                      ),

                      Text(
                        "Ha",
                        style: TextStyle(
                          color: KprimaryColor,
                          fontSize: 19,
                        ),
                      )
                    ],
                  ),
                ),


                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(height: 2,),
                ),

                SizedBox(height: 20,),

                Text(
                  "Rendement souhaité",
                  style: TextStyle(
                    color: KprimaryColor,
                    fontFamily: "manseratSem",
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 10,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            rendement.toString()+"T/Ha",
                          style: TextStyle(
                            color: 11.5 < rendement ? Colors.green :
                            9.5 < rendement && rendement < 12 ? Colors.lightGreen :
                            7.5 < rendement && rendement < 10 ? Colors.orange :
                            3.5 < rendement && rendement < 8 ? Colors.redAccent :
                            Colors.red,
                          ),
                        ),

                        Text(
                          "16T/Ha",
                          style: TextStyle(
                            color: Colors.green ,
                          ),
                        ),
                      ],
                    ),

                    SfSlider(
                      min: 2,
                      max: 16,
                      stepSize: 0.5,
                      value: rendement,
                      interval: 2,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      activeColor: KprimaryColor,
                      onChanged: (dynamic value){
                        setState(() {
                          rendement = value;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20,),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(height: 1,),
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        if(keyForm.currentState.validate()){
                          setState(() {
                            index++;
                          });
                        }


                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: KprimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Saisir résultats d'analyse du sol",
                          style: TextStyle(
                            color: KprimaryColor,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ) :

          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            child: Form(
              key: keyAnalyse,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Veuillez saisir les résultats de votre analyse",

                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                    decoration: BoxDecoration(
                      border: Border.all(color: KprimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: matiereOrganique,
                      onChanged: (val){
                        setState(() {
                          matiereOrganique = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Champ obligatoir..";
                        }
                        else return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Matrière organique (%)*",
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                    decoration: BoxDecoration(
                      border: Border.all(color: KprimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: phosphore,
                      onChanged: (val){
                        setState(() {
                          phosphore = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Champ obligatoir..";
                        }
                        else return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phosphore disponible mg/kg*",
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                    decoration: BoxDecoration(
                      border: Border.all(color: KprimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: potassium,
                      onChanged: (val){
                        setState(() {
                          potassium = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Champ obligatoir..";
                        }
                        else return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Potassium Assibilable (mg/kg)*",
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                    decoration: BoxDecoration(
                      border: Border.all(color: KprimaryColor),

                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: cn,
                      onChanged: (val){
                        setState(() {
                          cn = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Champ obligatoir..";
                        }
                        else return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "C/N",
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                    decoration: BoxDecoration(
                      border: Border.all(color: KprimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: caco3,
                      onChanged: (val){
                        setState(() {
                          caco3 = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Champ obligatoir..";
                        }
                        else return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "CaCO3 actif (%)",
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),

                    decoration: BoxDecoration(
                      border: Border.all(color: KprimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: argile,

                      onChanged: (val){
                        setState(() {
                          argile = val;
                        });
                      },
                      validator: (val){
                        if(val.isEmpty){
                          return "Champ obligatoir..";
                        }
                        else return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Argile (%)",
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),

                    ),
                  ),

                  SizedBox(height: 20,),

                  TextButton(
                    onPressed: () async {

                      if(keyAnalyse.currentState.validate()){


                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                          phoneForAcoout = sharedPreferences.getString("userPhone");

                          _usermodel = await fireService.getUserData(phoneForAcoout);

                          if(/*_usermodel.email != "" && _usermodel.email != null*/ true ){

                            print(_usermodel.email);

                            sendMail();


                            Fluttertoast.showToast(msg: "Votre Formule NPK sera bientôt prête",textColor: Colors.white,backgroundColor: KprimaryColor);

                            Navigator.of(context).pop();

                          }else{



                          }




                      }

                      },
                    child: Text("Valider et demander ma formule NPK"),
                  ),

                ],
              ),
            ),

          ),



        ),
      ),
    );
  }
}

