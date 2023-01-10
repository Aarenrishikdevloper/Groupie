import 'package:chatapp/backend/database/db.dart';
import 'package:chatapp/backend/service/helper.dart';
import 'package:chatapp/pages/chat.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/static.dart' as Static;
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
   TextEditingController searchcontroller = TextEditingController();
   String username = "";
   User?user;
   bool isjoined = false;
   bool _isloading = false;
   bool hassearch = false;
   QuerySnapshot? searchsnapshot;
   String getname(String res){
     return res.substring(res.indexOf("_") + 1);
   }
   String getid(String res){
     return res.substring(0, res.indexOf("_"));
   }
   getusername()async{
     await helperfunction.getusername().then((value) {
     setState(() {
      username = value!;
     });
     });
     user = FirebaseAuth.instance.currentUser;
   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusername();
  }
  joinedornot(String username, String groupid, String groupname, String admin)async{
     await Database(uid: user!.uid).isuserjoined(groupname, groupid, username).then((value){
          setState(() {
             isjoined = value!;
          });
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search group", style: GoogleFonts.ubuntu(
              fontSize: 27, fontWeight: FontWeight.bold),

          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
               Navigator.pop(context);
            },
          )
        ),
       body: Column(
           children: [
              Container(
               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10 ),
               color: Static.PrimaryMaterialColor,
                child: Row(
                   children: [
                      Expanded(
                        child: TextField(
                           controller: searchcontroller,
                           style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 16),
                           decoration: InputDecoration(
                               border: InputBorder.none,
                             hintText: "Search Group",
                             hintStyle: GoogleFonts.ubuntu(color: Colors.white, fontSize: 16),

                           ),
                          cursorColor: Colors.white,

                        ),
                      ),
                     GestureDetector(
                        onTap: (){
                          intializeserach();
                        },
                       child: Container(
                         height: 40,
                         width: 40,
                         decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(12),

                         ),
                         child: Icon(
                            Icons.search,
                           color: Colors.white,
                         ),
                       ),
                     )
                   ],
                ),
              ),
              SizedBox(height: 18,),

             _isloading?Center(child: CircularProgressIndicator(color: Static.PrimaryColor, )):grouplist(),

           ],
       ),
    );
  }
  grouplist(){
      return hassearch?ListView.builder(
        shrinkWrap: true,
         itemCount: searchsnapshot!.docs.length,
        itemBuilder: (context, index){
            return grouptile(
               username,
              searchsnapshot!.docs[index]["admin"],
              searchsnapshot!.docs[index]["groupid"],
              searchsnapshot!.docs[index]["groupname"],


            );
        },
      ):Container();
  }
  intializeserach() async{
      if(searchcontroller.text.isNotEmpty){
          setState(() {
              _isloading = true;

          });
          await Database().searchbyname(searchcontroller.text).then((value){
            setState(() {
                 searchsnapshot = value;
                 _isloading = false;
                 hassearch = true;

            });
          });
          print(searchsnapshot);
      }
  }
 Widget grouptile(String Username, String admin, String groupid, String groupname){
      joinedornot(Username, groupid, groupname, admin);
      return ListTile(

         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        leading: CircleAvatar(
           backgroundColor: Static.PrimaryColor,
          radius: 30,
          child: Text(groupname.substring(0,1).toUpperCase(), style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.bold),),

        ),
        title: Text(groupname, style: GoogleFonts.ubuntu(fontWeight: FontWeight.w500),),
        subtitle: Text("admin: ${getname(admin)}"),
         trailing: GestureDetector(
           onTap:() async{
              await Database(uid: user!.uid).togglegroupjoin(groupid, Username, groupname);
              if(isjoined){
                    setState(() {
                       isjoined = ! isjoined;

                    });
                    Fluttertoast.showToast(
                      msg: "Group join Sucessfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Future.delayed(Duration(seconds: 2), (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> chatpage(groupname: groupname, groupid: groupid, username: Username)));

                    });
              }
              else{
                setState(() {
                  isjoined = !isjoined;
                });
                Fluttertoast.showToast(
                  msg: "Left the group ${groupname}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }

           },
           child: isjoined?Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             decoration: BoxDecoration(
                color: Static.PrimaryMaterialColor,
               borderRadius: BorderRadius.circular(18),
               border: Border.all(color: Colors.white, width: 1),

             ),
             child:Text("Joined", style: GoogleFonts.ubuntu(color: Colors.white),),

           ):Container(
             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             decoration: BoxDecoration(
               color: Colors.green,
               borderRadius: BorderRadius.circular(18),
               border: Border.all(color: Colors.white, width: 1),

             ),
             child:Text("Join now", style: GoogleFonts.ubuntu(color: Colors.white),),
           ),
         ) ,
      );
  }
}
