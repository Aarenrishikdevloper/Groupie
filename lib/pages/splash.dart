import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/login.dart';
import 'package:flutter/material.dart';
import "package:chatapp/backend/service/helper.dart";
class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  bool _status = false;
  // This widget is the root of your application.
  getlogedstatus() async{
    await helperfunction.getuserstatus().then((value){
      if(value != null){
        setState(() {
          _status = value;
        });
      }
      if(_status == true){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home()));
      }
      else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    } );
  }

  @override
  void initState() {
    getlogedstatus();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12)

            ),
            padding: EdgeInsets.all(16.0),

          ),
        )
    );
  }
}
