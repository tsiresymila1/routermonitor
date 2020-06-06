
import 'package:flutter/material.dart';
import 'package:routermonitor/main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('RouterMonitor',style: TextStyle(color: Colors.blue,fontSize: 14.0,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width : 80,
                  height : 80,
                  child : Image.asset("assets/router.png",fit:BoxFit.cover)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:8.0,right:8.0,top: 8.0),
                child: MaterialButton(
                  color: Colors.blue,
                  height: 40.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  minWidth: MediaQuery.of(context).size.width < 200 ?MediaQuery.of(context).size.width -8.0 : 200 ,
                  child: Text('Start',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder :(context){
                          return MyHomePage(title: "RouterMonitor",);
                        }
                      )
                    );
                  },
                ),
              ),
            ],
          )
       ),
    );
  }
}