import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:chatapp/static.dart"as Static;
import 'package:google_fonts/google_fonts.dart';
class Messagetile extends StatefulWidget {
  const Messagetile({Key? key, required this.message, required this.sender, required this.sendbyme}) : super(key: key);
   final String message;
   final String sender;
   final bool sendbyme;

  @override
  State<Messagetile> createState() => _MessagetileState();
}

class _MessagetileState extends State<Messagetile> {
  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.only(top:4, bottom: 4, left: widget.sendbyme?0:24, right: widget.sendbyme?24:0),
       alignment:  widget.sendbyme?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
          margin: widget.sendbyme?EdgeInsets.only(left: 30):EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top:17, bottom: 17, right: 20, left: 20),
        decoration: BoxDecoration(
           borderRadius: widget.sendbyme?BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20)):
               BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
        ),
       color: widget.sendbyme?Static.PrimaryColor:Colors.grey[700],
        ),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,

          children: [
             Text(
                widget.sender,
               textAlign: TextAlign.start,
               style: GoogleFonts.ubuntu(color: Colors.white, letterSpacing: -0.5, fontWeight:FontWeight.w200 , fontSize: 13),


             ),
            SizedBox(height: 8,),
            Text(widget.message,style: GoogleFonts.ubuntu(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 16), textAlign: TextAlign.start, )
          ],
        ),
      ),
    );
  }
}
