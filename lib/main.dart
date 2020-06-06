import 'dart:convert';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:routermonitor/packages/database.dart';
import 'package:routermonitor/screens/about.dart';
import 'package:routermonitor/screens/logs.dart';
import 'package:routermonitor/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data.dart';
import 'models/custom_dialog.dart';
import 'screens/notifications.dart';
import 'screens/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouterMonitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  SocketIOManager manager ;
  NotificationProvider dbprovider ;
  SocketIO socketIO ;
  int notif ;
  bool isConnected = false;
  String URI ;

  void initState(){
      initnotif();
      dbprovider = new NotificationProvider("database.db");
      super.initState();
      initSocket();
  }
  initnotif()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notif = prefs.getInt("notif") ?? 0;
  }
  decrementNotif()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notif = prefs.getInt("notif");
    if(notif != 0){
      notif += 1 ;
      prefs.setInt("notif", notif);
    }
  }

  @override
  void dispose(){
    socketIO.disconnect();
    socketIO.destroy();
    super.dispose();
  }

  void initSocket()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      URI = prefs.getString("URI") ?? Contants.URL;
      isConnected = false;
    });

    manager = new SocketIOManager();
    socketIO = manager.createSocketIO(URI,'/');
    socketIO.init();
    socketIO.subscribe("connected",(data){
      setState(() {
        isConnected = true;
      });
    });
    socketIO.subscribe("data", dataReceived);
    socketIO.subscribe("alert", alertReceived);
    socketIO.disconnect();
    socketIO.connect();
  }

  dataReceived(jsondata){
    print(jsondata.toString());
  }
  alertReceived(alertdata)async{
    print(alertdata.toString());
    dynamic datajson = jsonDecode(alertdata);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(datajson["type"]);
    if(prefs.getBool(datajson["type"]) ?? false){
      NotData  data = await dbprovider.insert(
        NotData(
          address: datajson["address"],
          type: datajson["type"],
          date: DateTime.now().millisecondsSinceEpoch,
          description: datajson["description"],
          isRead: 0
        )
      );
    _diplayNotification(data.id,"ALERT",alertdata.toString());
      setState(() {
        notif+=1 ;
        prefs.setInt("notif", notif);
      });
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      }
      NotData data = await dbprovider.getNotData(int.parse(payload));
      data.isRead = 1 ;
      await dbprovider.update(data);
      decrementNotif();
      showDialog(
        context: context,
        builder: (context){
          return CustomDialog(
            title: data.address,
            date: DateTime.fromMillisecondsSinceEpoch(data.date).toUtc().toIso8601String(),
            description: data.description,
            okbtn: "Ok",
            icon: Icons.alarm_on,
            color: Colors.green,
          );
        }
      );
  }

  Future onDidReceiveLocalNotification(value, id, id2, id3) async {}

  _diplayNotification(int id, title, description) async{

    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
    
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        id.toString(), title, description,
        importance: Importance.Max,
        priority: Priority.High,
        enableLights: true,
        style: AndroidNotificationStyle.BigText,
        ticker: 'ticker',
        enableVibration: true,
        vibrationPattern: vibrationPattern);
      
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print("----------------------------------------------------------------");
    await flutterLocalNotificationsPlugin.show(
        0,
        title.toString(),
        description.toString(),
        platformChannelSpecifics,
        payload: id.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[

          InkWell(
            child:Badge(
              badgeContent:Text(notif.toString(),style:TextStyle(
                fontSize: 10,
                color: Colors.white
              )),
              position: BadgePosition.topRight(top: 2, right: -10),
              child :Icon(Icons.notifications)
            ),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder : (context){
                    return Notifications();
                }
              ));
            },
          ),
          new Container(width: 20,),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width : 100,
              height: 100,
              child: Image.asset("assets/myrouter.png",fit:BoxFit.cover),
            ),
            Container(
              height: 20,
              margin:EdgeInsets.only(top:16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    margin : EdgeInsets.only(right:10),
                    decoration: BoxDecoration(
                      color : isConnected ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(isConnected ? "CONNECTED" : "NOT CONNECTED",style:TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ))
                ],
              ),
            ),
            Container(
              height: 20,
              margin:EdgeInsets.only(top:16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Server address : " ,style:TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  )),
                  Text(URI,style:TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green
                  ))
                  
                ],
              ),
            )
          ],
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          elevation: 20.0,
          child : Scrollbar(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                      child: Column(
                        children : [
                          Container(
                            width : 80,
                            height : 80,
                            child : Image.asset("assets/router.png",fit:BoxFit.cover)
                          ),
                          Container(
                            child: Text('RouterMonitor',style:TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                            )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:10),
                            child: Text('mail@maildomain.com',style:TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            )),
                          )
                        ]
                      ),
                  )
                ,),

                ListTileTheme(
                  iconColor: Colors.blue,
                  child: ListTile(
                    leading: Icon(Icons.featured_video),
                    title: Text("Logs",style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    )),
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder : (context){
                            socketIO.disconnect();
                            return Logs(connected: isConnected,socket: socketIO,);
                        }
                      ));
                    },
                  ),
                ),
                ListTileTheme(
                  iconColor: Colors.blue,
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings",style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    )),
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder : (context){
                            return Settings();
                        }
                      ));
                    },
                  ),
                ),
                ListTileTheme(
                  iconColor: Colors.blue,
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("About",style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                    )),
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder : (context){
                            return About();
                        }
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child : Icon(Icons.sync,color: Colors.white,),
        onPressed : ()async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            URI = prefs.getString("URI") ?? Contants.URL;
            isConnected = false;
          });
           initSocket();
        }
      ),
    );
  }
}
