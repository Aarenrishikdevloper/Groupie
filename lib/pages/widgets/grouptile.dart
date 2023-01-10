import 'package:chatapp/pages/chat.dart';
import "package:flutter/material.dart";
import 'package:chatapp/static.dart' as Static;
import 'package:google_fonts/google_fonts.dart';
 class Grouptile extends StatefulWidget {
   String Groupname;
   String group_id;
   String  Username;
      Grouptile({Key? key, required this.Groupname, required this.group_id,required this.Username}) : super(key: key);

   @override
   State<Grouptile> createState() => _GrouptileState();
 }

 class _GrouptileState extends State<Grouptile> {
   @override
   Widget build(BuildContext context) {
     return GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> chatpage(groupid: widget.group_id, groupname: widget.Groupname, username: widget.Username,)));
          },
       child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
         child: ListTile(
           leading: CircleAvatar(
              radius: 30,
              backgroundColor: Static.PrimaryColor ,
             child: Text(
                 widget.Groupname.substring(0,1).toUpperCase(),
               textAlign: TextAlign.center,
               style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.w500),


             ),
           ),
           title: Text(
              widget.Groupname,
              style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),

           ),
           subtitle: Text("Join the Conversion as ${widget.Username}", style: GoogleFonts.ubuntu(fontSize: 12),),
         ),

       ),
     );
   }
 }
