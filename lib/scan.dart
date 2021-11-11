// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flag/flag.dart';

class scan extends StatefulWidget {
  var url = "http://10.0.2.2:6969";
  @override
  _scanState createState() => _scanState();
}

class _scanState extends State<scan> {
 String textUpload = "Please Upload your Certificate";
 String nom ="";
 String vacc ="";
 String cin="";
 String imagePath1 = "Assets/default.jpg";
 double size = 1;
bool valide = false;

  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('fileImage', filename));
    var res = await request.send();
    var response = res.stream.bytesToString();
    

  // print("Test"+await response);
    return response;
  }
  @override
  Widget build(BuildContext context) {
   
    
     
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFF393E46),
        titleTextStyle: const TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: true,
        title: Text("Vaccin"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
           // decoration: BoxDecoration(color: Color(0xFF3D0000)),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                
                Flag(
                        'TN',
                          height: 70,
                          width: 100,
                          fit: BoxFit.fill,
                      ),
                     
                Center(
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                      ),
                       Text(
                        textUpload ,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10,),
                       Text(nom , style: TextStyle(fontSize: 18),),
                       SizedBox(height: 10,),
                      Text(vacc, style: TextStyle(fontSize: 18),),
                      SizedBox(height: 10,),
                      Text(cin, style: TextStyle(fontSize: 18),),
                      SizedBox(height: 10,),
                      Container(
            height: size,
            width: size,
            child: Image.asset(
              imagePath1,
            ),
          ),
                      SizedBox(
                        height: 130,
                      ),
                      
                   
                    
                      FloatingActionButton.extended(
                          backgroundColor: Color(0xFFFF0000),
                          foregroundColor: Colors.white,
                           onPressed: () async {
                             
                            // Respond to button press
                          
                          //  final ImagePicker _picker = ImagePicker();
                            var result = await FilePicker.platform.pickFiles();
                            var file = result.files.first;
                        //    var file = await _picker.pickImage(source: ImageSource.gallery);
                            var res = await uploadImage(file.path, widget.url);
                           // print("first res :   "+res);
                            Map <String,dynamic> data = jsonDecode(res);
                            String name = data['dict']['firstName']+" "+data['dict']['lastName'];

                            String name2 = data['words']['nomEtPrenom'][0]+" "+data['words']['nomEtPrenom'][1] ;
                            String firstName = data['words']['nomEtPrenom'][0];
                            String firstName1 = data['dict']['firstName'];

                            String cin1= data['dict']['idNumber'];
                            String cin2= data['words']['idNumber'];
                            String vaccintype1= data['words']['nomDeVaccin'];
                            String vaccintype2=data['dict']['vaccinType'];

                            print("Nom ="+name);
                            print("Nom2=" +name2);
                            print("CIN1="+cin1);
                            print("cin2="+cin2);
                            print("vaccintype1="+vaccintype1);
                            print("vaccintype2="+vaccintype2);
                            if( firstName1==firstName && cin1==cin2 && vaccintype1==vaccintype2){
                              print("valide");
                              valide=true;
                            }
                            else {valide=false;
                            print("non valide");}
                            setState(() {
                              if (valide){
                                 textUpload="Hello, ";
                                    nom="Nom et Prénom: "+name;
                                    cin="CIN: "+cin2;
                                    vacc="Vaccin: "+vaccintype1;
                                    size=180;
                                    imagePath1="Assets/success.png";
                              }
                              else{
                                 nom="";
                                    cin="";
                                    vacc="";
                                size=250;
                                    imagePath1="Assets/erreur.png";
                              }
                                   

                                                      });

                           
                         //    print(textUpload);
                            
                           },
                         
                         label: Text('UPLOAD'),
                         icon: Icon(Icons.upload_outlined),
                          )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
