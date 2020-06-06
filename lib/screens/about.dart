import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color:Colors.white),
        title: Text("About"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Image(image: AssetImage("assets/router.png"),filterQuality: FilterQuality.high,fit: BoxFit.fill,width: 100,),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("RouterMonitor",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16.0),),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 4.0),
                child: Text("Version 1.0",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.0),),
              ),
            ),
          ),
          Divider(height: 8.0,),
          ListTile(
            leading: Icon(Icons.laptop,color: Colors.blue,),
            title: Text("Power by  "),
            trailing: Text("Miora && Tsiresy Milà",textAlign: TextAlign.end,),
          ),
          Divider(height: 8.0,),
          ListTile(
            leading: Icon(Icons.info_outline,color: Colors.pink,),
            title: Text("Description "),
            subtitle: Padding(
              padding: const EdgeInsets.only(top:8.0,left: 8.0,bottom: 8.0),
              child: Text(
                "This application is concus as a monitor of a remote router, to show all logs, and notify when alert was dectected\n"+
                "",textAlign: TextAlign.justify,
              ),
            ),
          ),
          Divider(height: 8.0,),
        ],
      ),
    );
  }
}