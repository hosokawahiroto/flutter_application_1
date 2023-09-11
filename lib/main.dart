import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState(){
    return _State();
  }
}

class _State extends State<MyApp> {
  var _navIndex = 0;
  final display = [Home(), Graph()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マスク判別アプリ'),
      ),
      body: display[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'graph'),
        ],
        onTap: (int index) {
          setState(() {
            _navIndex = index;
          });
        },
        currentIndex: _navIndex,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List myList = [];
  List myList1=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getdatafromapi2(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              myList = kosuu(snapshot.data);
              myList1=kosuu1(snapshot.data);
              
              return GridView.builder(
                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 列数を2に設定
              
                  ),
                itemCount: myList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    Row(
                      children: [
                        Image.memory(myList[index], width: 200.0,
                  height: 200.0, fit: BoxFit.contain,),
                     Image.memory(myList1[index], width: 200.0,
                  height: 200.0, fit: BoxFit.contain,),
                      ],
                    )
                   ,
                  Text(snapshot.data[index]["getTIME"]),
                  ],);
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  State<Graph> createState() => _Graph();
}

class _Graph extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getdatafromapi(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Text(snapshot.data),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Future<String> getdatafromapi() async {
  String response = '';
  
  var url = Uri.parse('http://10.16.202.94:5000/graph_page',);
  final result = await http.get(url);

  if (result.statusCode == 200) {
      response = result.body;
  }
  return response;
}

Future<List<dynamic>> getdatafromapi2() async {
  String response = '';
  List<dynamic> image;
  int value=0;

  var url = Uri.parse('http://10.16.202.94:5000/main_page',);
  final result = await http.get(url);

  if (result.statusCode == 200) {
      response = result.body;
      // print(response);
  }
  image=jsonDecode(response);
  // print(value);
  return image;
}

List kosuu(List a,){
  Uint8List byteImage  = Uint8List(0);
  List<Uint8List> myList = []; // 空のリストを作成
  int b=a.length;
  for (var i=0; i<b; i++){
      byteImage =const Base64Decoder().convert(a[i]["getIMAGE1"]);
      // byteImag =const Base64Decoder().convert(a[i]["getIMAGE2"]);
      myList.insert(0,byteImage);
      // myList.insert(1,byteImag);
      // print(myList);
     // final byteImag=const Base64Decoder().convert(snapshot.data[1]["getIMAGE2"]);
    }
  return myList;
}
List kosuu1(List a,){
  Uint8List byteImag  = Uint8List(0);
  List<Uint8List> myList1 = []; // 空のリストを作成
  int b=a.length;
  for (var i=0; i<b; i++){
      // byteImage =const Base64Decoder().convert(a[i]["getIMAGE1"]);
      byteImag =const Base64Decoder().convert(a[i]["getIMAGE2"]);
      // myList.insert(0,byteImage);
      myList1.insert(0,byteImag);
      // print(myList);
     // final byteImag=const Base64Decoder().convert(snapshot.data[1]["getIMAGE2"]);
    }
  return myList1;
}
