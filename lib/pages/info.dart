import 'package:chatapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/static.dart' as Static;

import '../backend/database/db.dart';
class groupinfo extends StatefulWidget {
  const groupinfo({Key? key,  required this.groupname, required this.group_id}) : super(key: key);

    final String groupname;
    final String group_id;

  @override
  State<groupinfo> createState() => _groupinfoState();
}

class _groupinfoState extends State<groupinfo> {
  String getname(String res){
    return res.substring(res.indexOf("_") + 1);
  }
  String getid(String res){
    return res.substring(0, res.indexOf("_"));
  }
  String admin = "";
  Stream?members;
  getadminandchat() async{
     await Database(uid: FirebaseAuth.instance.currentUser!.uid).getgroupadmin(widget.group_id).then((value){
      setState(() {
        admin = value;
      });
    });
     await Database(uid: FirebaseAuth.instance.currentUser!.uid).groupmember(widget.group_id).then((value){
        setState(() {
           members = value;
        });
     });
  }
  @override
  void initState() {
    getadminandchat();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info", style: GoogleFonts.ubuntu(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
             icon: Icon(Icons.exit_to_app, color: Colors.white,),
            onPressed: (){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context){

                    return AlertDialog(

                      title: Text("Exit Group", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300),),
                      content: Text("Are you sure you want to exit from group", style: GoogleFonts.ubuntu(),),
                      actions: [
                        MaterialButton(
                          child: Text("Yes", style: GoogleFonts.ubuntu(color: Colors.white),),
                          onPressed: (){
                            Database(uid: FirebaseAuth.instance.currentUser!.uid).togglegroupleave(widget.group_id, widget.groupname, getname(admin)).whenComplete((){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> home()));
                            });
                          },
                          color: Colors.red,

                        ),
                        MaterialButton(
                          child: Text("No", style: GoogleFonts.ubuntu(color: Colors.white),),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          color: Colors.green,

                        ),

                      ],
                    );
                  }

              );
            },
          )
        ],
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
           children: [
              Container(
                 padding: EdgeInsets.all(20),
                 decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                   color: Static.PrimaryMaterialColor.withOpacity(0.5),
                 ),
                child: Column(
                   children: [
                      Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           CircleAvatar(
                              backgroundColor: Static.PrimaryColor,
                             radius: 30,
                             child: Text(widget.groupname.substring(0,1).toUpperCase(), style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.white),),
                           ), 
                            SizedBox(width: 20,), 
                          Column(
                             crossAxisAlignment: CrossAxisAlignment.start, 
                             children: [
                                 Text("Group: ${widget.groupname}", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500),),
                                SizedBox(height: 7,),
                               Text("Admin: ${getname(admin)}", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500),),
                             ],
                          )
                        ],
                      ),

                   ],
                ),
              ),
             member(),
           ],

        ),
      ),

    );

  }
    member(){
     return StreamBuilder(
        stream: members,
       builder: (context,  AsyncSnapshot snapshot){
           if(snapshot.hasData){
               if(snapshot.data[  "members"] != null){
                     if(snapshot.data[  "members"].length != 0){
                        return ListView.builder(
                           itemCount: (snapshot.data[  "members"].length) ,
                          shrinkWrap: true,
                          itemBuilder:(context, index){
                              return Container(
                                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Static.PrimaryColor,
                                      child: Text(

                                          getname(snapshot.data["members"][index]).substring(0,1).toUpperCase(),
                                          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),


                                    ),
                                   title: Text(getname(snapshot.data["members"][index]), style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),),
                                  subtitle: Text(getid(snapshot.data["members"][index]), style: GoogleFonts.ubuntu(fontSize: 12),),
                                ),
                              );
                          },
                        );
                     }
                     else{
                       return Text("NOthing to display");
                     }

               }
               else{
                 return Text("NOthing to display");
               }
           }
           else{
              return Container();
           }
       },
     );
    }
}
