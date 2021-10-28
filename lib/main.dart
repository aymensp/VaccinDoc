// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaccinDoc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const MyHomePage(title: 'VaccinDoc', url: 'http://192.168.1.4:8080'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.url})
      : super(key: key);

  final String title;
  final String url;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String?> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('fileImage', filename));
    var res = await request.send();
    return res.reasonPhrase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Please Upload your Certificate',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                var file = await _picker.pickImage(source: ImageSource.gallery);
                var res = await uploadImage(file!.path, widget.url);
                setState(() {
                  // ignore: avoid_print
                  print(res);
                  print(file.toString());
                });
              },
              child: Text('upload'),
            )
          ],
        ),
      ),
    );
  }
}
