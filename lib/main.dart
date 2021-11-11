// @dart=2.9
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flag/flag.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'VaccinDoc',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home:
          const MyHomePage(title: 'Vaccin Doc', url: 'http://10.0.2.2:6969'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title,  this.url})
      : super(key: key);

  final String title;
  final String url;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 // http.post(Uri.parse(loginUrl),headers: headers, body: json.encode (loginObject)).then((http.Response response)
class _MyHomePageState extends State<MyHomePage> {
  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('fileImage', filename));
    var res = await request.send();
    var response = http.Response.fromStream(res);
    String string ;
   response.then((value) => string = value.body);
   print(string);
    return res.reasonPhrase;
  }

  @override
  Widget build(BuildContext context) {
    String textUpload = "Please Upload your Certificate";
     
    return Scaffold(
     /* appBar: AppBar(
        backgroundColor:  Color(0xFF393E46),
        titleTextStyle: const TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: true,
        title: Text(widget.title),
      ),*/
      body: SafeArea(
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
                    SizedBox(
                      height: 130,
                    ),
                    /*
                    TextButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        var file = await _picker.pickImage(source: ImageSource.gallery);
                        var res = await uploadImage(file.path, widget.url);
                        setState(() {
                          // ignore: avoid_print
                          print(res);
                          print(file.toString());
                        });
                      },
                      child: Text('upload'),
                    ),*/
                    FloatingActionButton.extended(
                        backgroundColor: Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                         onPressed: () async {
                           setState(() {
                            textUpload ="done";
                            print(textUpload);
                            /*print("done set state");
                              print("second res :   "+res);
                          print(file.toString());*/
                       
                                            });
                          // Respond to button press
                        
                        //  final ImagePicker _picker = ImagePicker();
                          var result = await FilePicker.platform.pickFiles();
                          var file = result.files.first;
                      //    var file = await _picker.pickImage(source: ImageSource.gallery);
                          var res = await uploadImage(file.path, widget.url);
                          print("first res :   "+res);
                          
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
    );
  }
}
