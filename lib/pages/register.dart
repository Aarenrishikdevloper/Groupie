import 'package:chatapp/backend/database/authentication.dart';
import 'package:chatapp/backend/service/helper.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/static.dart' as Static;
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  String name = '';
  String email = "";
  String password  = '';
  Authservice auth = Authservice();
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0,),
      body:_isloading?Center(child: CircularProgressIndicator(color: Static.PrimaryColor),):SingleChildScrollView(
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
                  Text('Create your account to chat and explore', style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.w400 ),),
                  Image.asset("images/register.png"),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: GoogleFonts.ubuntu(color: Colors.black, fontWeight: FontWeight.w400),
                      prefixIcon: Icon(Icons.person, color: Static.PrimaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Static.PrimaryColor, width: 2),

                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Static.PrimaryMaterialColor, width: 2),

                      ),




                    ),
                    onChanged: (val){
                      setState(() {
                        name = val;
                      });

                    },
                    validator: (val){
                      if(val !.isNotEmpty){
                        return null;
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "please enter your full name",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                  SizedBox(height: 15,),

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
                        RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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

                   } ,
                    validator: (val){
                       if(password.length > 6){
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
                    },

                    obscureText: true,

                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                  SizedBox(height: 15,),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: (){
                        register();
                      },
                      color: Static.PrimaryColor,
                      padding: EdgeInsets.all(13.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Text("Sign Up", style: GoogleFonts.ubuntu(fontWeight: FontWeight.w300, color: Colors.white, fontSize: 19),),


                    ),
                  ),
                  SizedBox(height:15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.black),),
                      GestureDetector(child: Text("Login now", style: GoogleFonts.ubuntu(color:Colors.black, decoration: TextDecoration.underline ),),
                        onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
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
  register() async{


     if(formkey.currentState!.validate()){
       setState(() {
          _isloading = true;
       });
       await auth.userregister(name, email, password).then((value)async{
            if(value == true){
              await helperfunction.saveduserstatus(true);

              await helperfunction.savedemail(email);
              await helperfunction.savedusername(name);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home()));

            }
            else{
              setState(() {
                _isloading = false;
              });
              Fluttertoast.showToast(
                  msg: value,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
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
