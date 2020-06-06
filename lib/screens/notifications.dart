import 'package:flutter/material.dart';
import 'package:routermonitor/models/custom_dialog.dart';
import 'package:routermonitor/packages/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  NotificationProvider dbprovider ;

  @override
  void initState() {
    dbprovider = new NotificationProvider("database.db");
  }
  decrementNotif()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int notif = prefs.getInt("notif");
    if(notif != 0){
      notif += 1 ;
      prefs.setInt("notif", notif);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color:Colors.white),
        title: Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: dbprovider.getAll(),
          builder : (context , AsyncSnapshot snapshot){
          List<NotData> nodatas = snapshot.data ;
          return  nodatas == null ? Center(
            child: ListTile(
              leading: Icon(Icons.notifications_none,color: Colors.grey,),
              title: Text('No Notification'),
              )
            )
            :ListView.builder(itemCount: nodatas == null ? 0 : nodatas.length,itemBuilder: (context,pos){
            NotData data = nodatas[pos];
              return ListTileTheme(
                iconColor: Colors.blue,
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(top:8),
                    child: Icon(Icons.notifications_active), 
                  ),
                  title: Text(data.address),
                  trailing: data.isRead == 1 ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                  onLongPress: ()async{
                    data.isRead = 1 ; 
                    await dbprovider.update(data);
                    decrementNotif();
                    showDialog(context: context,builder: (context){
                      return CustomDialog(
                        title: data.address,
                        date: DateTime.fromMillisecondsSinceEpoch(data.date).toUtc().toIso8601String(),
                        description: data.description,
                        okbtn: "OK",
                        icon: Icons.notifications,
                        color: Colors.green,
                      );
                    });
                  },
                ),
              );
          });
        }),
      ),
    );
  }
}
