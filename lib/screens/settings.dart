import 'package:flutter/material.dart';
import 'package:routermonitor/data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}



class _SettingsState extends State<Settings> {

  bool isNotificationActive ,isSystemEvents ,isFirewallEvents,isDNSEvents,isDHCPEvents,isPPPEvents,isCaptivePortalEvents,isVPNEvents,isGatewayMonitorEvents,isRouting,isLoadBalancer,isWirelessEvents ;
  String Socket_URI ;
  TextEditingController _ipcontroller = TextEditingController();

  @override
  void initState() { 
    super.initState();
    loadPreference() ;
  }

  loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationActive = prefs.getBool("isNotActive") ?? false;
      isSystemEvents = prefs.getBool("isSystemEvents") ?? false;
      isFirewallEvents = prefs.getBool("isFirewallEvents") ?? false;
      isDNSEvents = prefs.getBool("isDNSEvents") ?? false;
      isDHCPEvents = prefs.getBool("isDHCPEvents") ?? false;
      isPPPEvents = prefs.getBool("isPPPEvents") ?? false;
      isCaptivePortalEvents = prefs.getBool("isCaptivePortalEvents") ?? false;
      isVPNEvents = prefs.getBool("isVPNEvents") ?? false;
      isGatewayMonitorEvents = prefs.getBool("isGatewayMonitorEvents") ?? false;
      isRouting = prefs.getBool("isRouting") ?? false;
      isLoadBalancer = prefs.getBool("isLoadBalancer") ?? false;
      isWirelessEvents = prefs.getBool("isWirelessEvents") ?? false;
      Socket_URI = prefs.getString("URI") ?? Contants.URL;
      _ipcontroller.text = Socket_URI;
    });
  }

  Widget dialog(){
    return Theme(
      data : Theme.of(context),
        child:SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom:16.0),
                padding: EdgeInsets.all(8.0),
                color: Colors.blue,
                width :MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 40,
                child: Text("Change server address ",style:TextStyle(color: Colors.white)),
              ),
              Padding(
               padding: const EdgeInsets.only(left:16.0,right:16.0,bottom: 16.0,top: 8.0),
               child: TextField(
                 controller: _ipcontroller,
                 decoration: InputDecoration(
                   icon: Icon(Icons.router,color: Colors.blue,
                   
                   ),
                   labelText:"Server address", 
                   labelStyle: TextStyle(fontSize: 14)
                   ),
               ),
             ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: (){
                              Navigator.of(context).pop();
                          }, 
                          child: Text("Cancel",style:TextStyle(color: Colors.blue)
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: ()async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("URI",_ipcontroller.text);
                              setState(() {
                                Socket_URI = _ipcontroller.text ;
                              });
                              Navigator.of(context).pop();
                          }, 
                          child: Text("Save",style:TextStyle(color: Colors.blue)
                          )
                        ),
                      )
                    ],
                ),
              )
            ],
          ),
      ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         leading:BackButton(color: Colors.white,),
         title: Text('Settings'),

       ),
       body: Container(
         child: Padding(
           padding: const EdgeInsets.only(top:8.0,bottom:8.0,left:12.0,right:12.0),
           child: ListView(
             children: <Widget>[
               ListTile(
                title: Text("Server address",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                subtitle: Text(Socket_URI,style: TextStyle(fontSize: 12),),
                trailing:IconButton(
                    icon: Icon(Icons.mode_edit,size: 20,),
                    color: Colors.blue,
                    onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return dialog();
                          }
                        );
                    },
                )
              ) ,
              ListTile(
                title: Text("Notification",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isNotificationActive,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isNotActive",switced);
                      setState(() {
                        isNotificationActive = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("System Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isSystemEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isSystemEvents",switced);
                      setState(() {
                        isSystemEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("Firewall Events",style: TextStyle(fontSize: 14)),
                contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isFirewallEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isFirewallEvents",switced);
                      setState(() {
                        isFirewallEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("DNS Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isDNSEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isDNSEvents",switced);
                      setState(() {
                        isDNSEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("DHCP Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isDHCPEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isDHCPEvents",switced);
                      setState(() {
                        isDHCPEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("PPP Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isPPPEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isPPPEvents",switced);
                      setState(() {
                        isPPPEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("Captive Portal Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isCaptivePortalEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isCaptivePortalEvents",switced);
                      setState(() {
                        isCaptivePortalEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("VPN Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isVPNEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isVPNEvents",switced);
                      setState(() {
                        isVPNEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("Gateway Monitor Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isGatewayMonitorEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isGatewayMonitorEvents",switced);
                      setState(() {
                        isGatewayMonitorEvents = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("Routing",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isRouting,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isRouting",switced);
                      setState(() {
                        isRouting = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("Server Load Balancer",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isLoadBalancer,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isLoadBalancer",switced);
                      setState(() {
                        isLoadBalancer = switced ;
                      });
                  },
                ),
              ),
              ListTile(
                title: Text("Wireless Events",style: TextStyle(fontSize: 14)),contentPadding: EdgeInsets.all(0),
                trailing: Switch(
                  value: isWirelessEvents,
                  activeColor: Colors.blue,
                  onChanged: (switced)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("isWirelessEvents",switced);
                      setState(() {
                        isWirelessEvents = switced ;
                      });
                  },
                ),
              ),
             ],
           ),
         ),
       ),
    );
  }
}
