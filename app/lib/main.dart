import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({@required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String image = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image == ""
                ? Container()
                : Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(base64Decode(image)))),
                  ),
            GestureDetector(
              onTap: () {
                sendImageToAPI();
              },
              child: Container(
                  color: Colors.red,
                  height: 50,
                  width: 100,
                  child: Text("send image")),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadImage();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> TestApi() async {
    print("send api");
    var client = http.Client();
    Map<String, String> Header = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var url = Uri.parse("http://192.168.137.1:3000/");
    var uriResponse = await client.get(
      url,
      // body: jsonEncode({"data": "hello"}),
      headers: Header,
    );

    var res = uriResponse.body;
    print(res);
  }

  Future<void> sendImageToAPI() async {
    print("send api image");
    var client = http.Client();
    Map<String, String> Header = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var url = Uri.parse("http://192.168.137.1:3000/image");
    var uriResponse = await client.post(
      url,
      body: jsonEncode({"image": image}),
      headers: Header,
    );

    var res = uriResponse.body;
    print(res);
  }

  Future<void> uploadImage() async {
    ImagePicker picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    // var dd = await pickedFile.toString();
    Uint8List bytes = File(pickedFile.path).readAsBytesSync();
    String base64 = base64Encode(bytes);
    // Uint8List _binary = base64Decode(base64);
    setState(() {
      image = base64;
    });
  }
}
