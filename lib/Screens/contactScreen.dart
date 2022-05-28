import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferolive/constances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormUI extends StatefulWidget {
  String UserEmail;
  FormUI({this.UserEmail});
  @override
  _FormUIState createState() => _FormUIState();
}

String messageSend ;

class _FormUIState extends State<FormUI> {

  FirebaseFirestore fire = FirebaseFirestore.instance;


  Future SendMessageToFireStore(String message,String email)async{
    try {
      await fire.collection("Contact").doc().set(
          {
            "email":email,
            "message":message,

          }
      );

    } on Exception catch (e) {
      print(e.toString());
    }
  }



  TextEditingController _messageController = new TextEditingController();


  String _email ;

  @override
  void initState() {
    // TODO: implement initState
    _email = widget.UserEmail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: KnatureColor,
        centerTitle: true,
        title: Text(
          "Contactez nous",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(right: 10, left: 10, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),

              TextFormField(

                initialValue: widget.UserEmail??"",
                cursorColor: KnatureColor,

                decoration: InputDecoration(
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: KnatureColor),
                  ),
                  labelText: "Votre adress e-mail",
                  border: OutlineInputBorder(),
                  focusColor: KnatureColor,
                ),
                onChanged: (val){
                  setState(() {
                    _email = val;
                  });
                },

              ),

              SizedBox(
                height: 20,
              ),
              TextField(
                cursorHeight: 20,
                controller: _messageController,
                maxLines: 4,
                maxLength: 300,
                scrollController: ScrollController(),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:KnatureColor ),
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter votre message..',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: RaisedButton(
                      color: KnatureColor,
                      child: Text("Send",style: TextStyle(color: Colors.white),),
                      onPressed: () async{


                        setState(() {
                          messageSend = _messageController.text.toString();
                        });

                        Email email = Email(
                          body: messageSend,
                          subject: 'Contactez FertOlive',
                          recipients: ['ferolive.app@gmail.com'],
                        );
                        SendMessageToFireStore(_messageController.text.toString(),_email);


                        await FlutterEmailSender.send(email);

                        _messageController.clear();
                        //call method flutter upload
                      })),
            ],
          ),
        ),
      ),
    );
  }
}