import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
Map data;
List features;
void main()async
{ data= await getquake();
  features = data['features'];
  runApp(new MaterialApp(
    title: "EarthQuake",
    home: new Eq(),
  ));
}
class Eq extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Earthquakes"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: new  Center(
        child: new ListView.builder(itemBuilder:(
        BuildContext context , int pos
        ){ if(pos.isOdd) return new Divider();
          final index = pos ~/2;
          var date = new DateTime.fromMicrosecondsSinceEpoch(features[index]['properties']['time']*1000);
          return new ListTile(
          subtitle: new Text("${features[index]['properties']['place']}",
          style: new TextStyle(fontSize: 14.5),),
          leading: CircleAvatar(
            child: new Text("${features[index]['properties']['mag']}"),
            backgroundColor: Colors.blueAccent,
          ),
            title: new Text("${date}",
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold
            ),),
            onTap: ()=>{showalert(context,"${features[index]['properties']['title']}")},

        );
          
        },
        itemCount:features.length ,
        padding: const EdgeInsets.all(15.0),),
      ),
    );
  }

  showalert(BuildContext context, String s) {
    var alert = new AlertDialog(
      title: new Text("Info"),
      content:  new Text(s),
      actions: <Widget>[
        new FlatButton(onPressed:(){
          Navigator.pop(context);
        }, child: new Text("OK"))
      ],
    );
    // ignore: deprecated_member_use
    showDialog(context:context,child: alert);
  }
}
Future<Map> getquake() async{
  String url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(url);
  return json.decode(response.body);
}