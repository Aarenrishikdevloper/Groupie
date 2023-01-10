import 'package:chatapp/backend/database/authentication.dart';
import 'package:chatapp/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:chatapp/static.dart"as Static;

import 'login.dart';
class profile extends StatelessWidget {
  String name = '';
  String email = '';
     profile({Key? key,required this.name, required this.email}) : super(key: key);
     Authservice auth =  Authservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: Text("Profile", style: GoogleFonts.ubuntu(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white)),
         centerTitle: true,
         elevation: 0,
       ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 130,
              color: Colors.grey[500],
            ),
            SizedBox(height: 15,),
            Text(name, textAlign: TextAlign.center, style: GoogleFonts.ubuntu(fontWeight: FontWeight.w400, fontSize: 16),),
            SizedBox(height: 30,),
            ListTile(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => home()));
              },

              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group, ),
              title: Text("Groups", style: GoogleFonts.ubuntu(color: Colors.black)),
            ),
            ListTile(
              onTap: (){

              },
              selected: true,
              selectedColor: Static.PrimaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person, ),
              title: Text("Profile", style: GoogleFonts.ubuntu(color: Colors.black)),
            ),
            ListTile(
              onTap: (){
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context){

                      return AlertDialog(

                        title: Text("Sign out", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300),),
                        content: Text("Are you sure you want to log  out", style: GoogleFonts.ubuntu(),),
                        actions: [
                          MaterialButton(
                            child: Text("Yes", style: GoogleFonts.ubuntu(color: Colors.white),),
                            onPressed: (){
                              auth.Signout();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
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

              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.logout, ),
              title: Text("Sign Out", style: GoogleFonts.ubuntu(color: Colors.black)),
            ),





          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Center(child: Icon(Icons.account_circle, size: 200, color: Colors.grey[500],)),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Full Name:", style: GoogleFonts.ubuntu( fontWeight: FontWeight.w300 ),)),
                Expanded(child: Text(name, style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300 ) )),
              ],
            ),
            Divider(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Email Id:", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300),)),
                Expanded(child: Text(email, style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300 ) )),
              ],
            ),
          ],


        ),
      ),
    );
  }
}
