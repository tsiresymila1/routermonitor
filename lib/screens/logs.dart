import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:routermonitor/data/data.dart';
import 'package:routermonitor/models/custom_dialog.dart';
import 'package:routermonitor/packages/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logs extends StatefulWidget {

  bool connected ;
  SocketIO socket ;

  Logs({Key key,this.connected,this.socket}) : super(key: key);

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {

  SocketIOManager manager ;
  SocketIO socketIO ;
  bool isConnected = false;
  NotificationProvider dbprovider;
  String content = "<br><strong>Router:\$</strong> Connecting . . . please wait";
  ScrollController scrollcontroller = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  String URI ;

  @override
  void initState(){
      dbprovider = new NotificationProvider("database.db");
      initSocket();
      super.initState();
  }

  @override
  void dispose() {
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
    if(widget.connected){
      widget.socket.disconnect();
    }
    manager = new SocketIOManager();
    socketIO = manager.createSocketIO(URI,'/');
    socketIO.init();
    socketIO.subscribe("connected", (data){
      print('CONNECTED');
      setState(() {
        isConnected = true;
        content += "<br><strong>Router:\$ </strong>Connection . . . . . .OK";
      });
    });
    socketIO.subscribe("disconnected", (data){
      print('DISCONNECTED');
      setState(() {
        isConnected = false;
        content += '<br><strong>Router:\$ </strong><span style="color:red;">Disconnected . . . . . . </span> ';
      });
    });
    socketIO.subscribe("data", dataReceived);
    socketIO.subscribe("alert", alertReceived);
    socketIO.connect();

  }

  dataReceived(jsondata){
    dynamic data = jsonDecode(jsondata.toString());
    //print(jsondata.toString());
    //scrollcontroller.animateTo(0.0, duration: const Duration(microseconds:300), curve: Curves.easeOut);
    scrollcontroller.jumpTo(scrollcontroller.position.maxScrollExtent);
    setState(() {
      isConnected = true;
      content+='<br><strong>Router:\$ '+data["address"].toString()+"</strong>-::-"+data['description'].toString();
    });
  }
  alertReceived(alertdata)async{
    print(alertdata.toString());
    dynamic datajson = jsonDecode(alertdata);
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      int notif = prefs.getInt("notif") ?? 0 ;
      setState(() {
        notif+=1 ;
        prefs.setInt("notif", notif);
      });
    }
  }

  Future onDidReceiveLocalNotification(value, id, id2, id3) async {}
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      }
      NotData data = await dbprovider.getNotData(int.parse(payload));
      data.isRead = 1 ;
      await dbprovider.update(data);
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
        'alertid', 'Monitor alert', 'Alerter',
        importance: Importance.Max,
        priority: Priority.High,
        enableLights: true,
        style: AndroidNotificationStyle.BigText,
        ticker: 'ticker',
        enableVibration: true,
        vibrationPattern: vibrationPattern);
      
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

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
         leading : BackButton(color:Colors.white),
          title: Text("Logs"),
          actions: <Widget>[
            Center(
              child: Container(
                width: 10,
                height: 10,
                margin : EdgeInsets.only(right:4.0),
                decoration: BoxDecoration(
                  color : isConnected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.more_vert), onPressed: (){

            }),
        ],
       ),
       body: Container(
         padding: EdgeInsets.all(2.0),
         color: Colors.black,
         margin: EdgeInsets.all(0.0),
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height,
         child: SingleChildScrollView(
           controller: scrollcontroller,
           padding: EdgeInsets.all(0.0),
           child: HtmlWidget(content,
           bodyPadding: EdgeInsets.all(0),
           textStyle:TextStyle(
             fontSize: 14,
             color:Colors.green,
             fontFamily: "Consolas"
           ))
         ),
       ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child : Icon(Icons.sync,color: Colors.white,),
        onPressed : (){
          initSocket();
        }
      ),
    );
  }
}
