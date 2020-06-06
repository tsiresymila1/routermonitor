import 'package:flutter/material.dart';


class CustomDialog extends StatefulWidget {


  CustomDialog({this.title,this.date,this.description,Key key,this.okbtn,this.icon,this.color}) : super(key: key);

  final String title ;
  final String date ;
  final String description ;
  final String okbtn ;
  final IconData icon ;
  final Color color ;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data : Theme.of(context),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width :MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200.0,
                padding: EdgeInsets.only(top:45.0,left: 8.0,right: 8.0),
                margin: EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.title,style: TextStyle(color: Theme.of(context).textTheme.display1.color,fontSize: 14.0,fontFamily: "Raleway",fontWeight: FontWeight.bold ),),
                    ),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.date,style: TextStyle(color: Theme.of(context).textTheme.display1.color,fontSize: 14.0,fontFamily: "Raleway",fontWeight: FontWeight.bold ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.description,
                      maxLines: 2,
                      style: TextStyle(color: Theme.of(context).textTheme.display1.color,fontSize: 14.0,fontWeight: FontWeight.normal,fontFamily: "Raleway"),
                      overflow: TextOverflow.ellipsis,),
                    )
                    ,
                      Padding(
                      padding: EdgeInsets.only(left:16.0,right:16.0,bottom: 16.0,top: 16.0),
                      child: MaterialButton(
                        color: widget.color,
                        height: 40.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        minWidth: MediaQuery.of(context).size.width - 8.0,
                        child: Text(widget.okbtn,style: TextStyle(color: Colors.white),),
                        onPressed: (){
                            Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                    ),
                    child: Container(
                    // margin: EdgeInsets.all(10.0),
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: widget.color,
                    ),
                    child: Icon(widget.icon,color: Colors.white,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}