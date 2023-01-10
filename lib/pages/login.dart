import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/backend/database/authentication.dart';
import 'package:chatapp/backend/database/db.dart';
import 'package:chatapp/backend/service/helper.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/static.dart' as Static;
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  bool _loading = false;
  String password  = '';
  Authservice auth = Authservice();
  @override
  Widget build(BuildContext context) {
    return _loading? Scaffold(body: Center(child: CircularProgressIndicator(color: Static.PrimaryColor,) ,)):Scaffold(
      appBar: AppBar(toolbarHeight: 0.0,),
       body: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
           child: Form(
              key: formkey,
             child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [

                      Center(child: Text("Groupie", style: GoogleFonts.ubuntu(fontSize: 40, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center,)), 
                     SizedBox(height: 10,), 
                    Text('Login to see what they are taking!', style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w400 ),),
                    Image.asset("images/login.png"),
                   TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.ubuntu(color: Colors.black, fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.email, color: Static.PrimaryColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Static.PrimaryColor, width: 2),

                        ),
                        enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Static.PrimaryMaterialColor, width: 2),

                        ),




                      ),
                     onChanged: (val){
                        setState(() {
                          email = val;
                        });

                     },
                     validator: (val){

                      RegExp (r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                           .hasMatch(val!)
                       ? null
                           : Fluttertoast.showToast(
                       msg: "please Enter a valid email",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       timeInSecForIosWeb: 1,
                       backgroundColor: Colors.red,
                       textColor: Colors.white,
                       fontSize: 16.0,
                       );


                     },
                     style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                   ),
                 SizedBox(height: 15,),
                 TextFormField(
                   decoration: InputDecoration(
                     labelText: "Password",
                     labelStyle: GoogleFonts.ubuntu(color: Colors.black, fontWeight: FontWeight.w400),
                     prefixIcon: Icon(Icons.lock, color: Static.PrimaryColor),
                     focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Static.PrimaryColor, width: 2),

                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Static.PrimaryMaterialColor, width: 2),

                     ),




                   ),
                   onChanged: (val){
                     setState(() {
                       password= val;
                     });

                   },
                   obscureText: true,
                   validator: (val){
                      if(password.length < 6){
                        Fluttertoast.showToast(
                          msg: "please enter a password more then 6 chracter",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                      else{
                        return null;
                      }



                   },
                   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                 ),
                 SizedBox(height: 15,),
                 SizedBox(
                    width: double.infinity,
                   child: MaterialButton(
                      onPressed: (){
                         login();
                      },
                     color: Static.PrimaryColor,
                     padding: EdgeInsets.all(14),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                     child: Text("Sign in", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 19),),


                   ),
                 ),
                 SizedBox(height: 15,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text("Do not have account? ", style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.black),),
                       GestureDetector(child: Text("Register Here", style: GoogleFonts.ubuntu(color:Colors.black, decoration: TextDecoration.underline ),),
                            onTap: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register()));
                            },
                       ),
                    ],
                 )



               ]
             ),

           ),
         ),
       ),
    );
  }
  login() async{
     if(formkey.currentState!.validate()){
       setState(() {
         _loading = true;
       });
        await auth.loginwithemail(email, password).then((value)async{
          if(value == true){
             QuerySnapshot snapshot =await Database(uid: FirebaseAuth.instance.currentUser!.uid).getuserdata(email);
             await  helperfunction.saveduserstatus(true);
             await helperfunction.savedemail(email);
             await helperfunction.savedusername(snapshot.docs[0]["fullname"]);

             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> home()));
          }
          else{
            setState(() {
              _loading = false;
            });
            Fluttertoast.showToast(
              msg: value,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        });
     }
  }
}
