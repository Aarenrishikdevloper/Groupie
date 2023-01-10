import 'package:chatapp/backend/database/db.dart';
import 'package:chatapp/pages/info.dart';
import 'package:chatapp/pages/widgets/messagetile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/static.dart' as Static;
import "package:chatapp/backend/service/helper.dart";
class chatpage extends StatefulWidget {
   chatpage({Key? key, required this.groupname, required this.groupid, required this.username}) : super(key: key);
   final String groupname;
   final String groupid;
   final String username;


  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {

  TextEditingController messagecontroller = TextEditingController();
  Stream<QuerySnapshot>?chat;
  bool sentbyme = false;
  String email = '';
  getchat()async{
     Database().getchat(widget.groupid).then((val){
       setState(() {
          chat = val;
       });
     });
     await helperfunction.getuseremail().then((value) {
       setState(() {
         email = value!;
       });
     });

  }
  @override
  void initState() {
    getchat();
    // TODO: implement initState
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("Chats", style: GoogleFonts.ubuntu(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        actions: [
           IconButton(
             onPressed: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=> groupinfo( groupname: widget.groupname, group_id: widget.groupid)));
             },
             icon: Icon(Icons.info, color: Colors.white,),
           )
        ],
        leading: IconButton(
           onPressed: (){
              Navigator.of(context).pop();
           },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: Stack(
          children: [
            SizedBox(height: 10,),
            chatmessage(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                 width: MediaQuery.of(context).size.width, 
                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18), 
                color:  Colors.grey[700], 
                child:Row(
                  children: [
                     Expanded(
                       child: TextField(
                         controller:  messagecontroller,
                         style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                         decoration: InputDecoration(
                           hintText: "Message",
                           hintStyle: GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
                           border: InputBorder.none,

                         ),
                         cursorColor: Colors.white,

                       ),
                     ),
                    SizedBox(width: 12,),  
                    GestureDetector(
                       onTap: (){
                         sendmessage();
                       },
                      child: Container(
                         height: 50, 
                        width: 50, 
                        child: Icon(Icons.send, color: Colors.white,), 
                        decoration: BoxDecoration(
                           color: Static.PrimaryColor, 
                           borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                    )
                    
                  ],
                )
                    
              ),
             
              
              

            )
          ],
      ),
    );
  }
  chatmessage(){
      return StreamBuilder(
         stream: chat,
        builder: (context, AsyncSnapshot snapshot){
           return  snapshot.hasData?ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){

                return Messagetile(
                   message: snapshot.data.docs[index]['message'],
                   sender: snapshot.data.docs[index]['sender'],
                  sendbyme:   email == snapshot.data.docs[index]["email"],


                );
              },

           ):Container();

        },
      );
  }
  sendmessage(){
      if(messagecontroller.text.isNotEmpty){
        Map<String, dynamic> chatmessagemap = {
           "message": messagecontroller.text,
          "sender": widget.username,
          "time": DateTime.now().millisecondsSinceEpoch,
          "email": email,
        };
        Database().sendmessage(widget.groupid, chatmessagemap);
        setState(() {
          messagecontroller.clear();
        });

      }
  }


}
