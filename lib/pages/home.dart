import 'package:chatapp/backend/database/authentication.dart';
import 'package:chatapp/backend/database/db.dart';
import 'package:chatapp/backend/service/helper.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/profile.dart';
import 'package:chatapp/pages/search.dart';
import 'package:chatapp/pages/widgets/grouptile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/static.dart' as Static;
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late String email = "";
  late String name = "";
  bool _isloading = false;
  String groupname = "";


  Authservice auth = Authservice();


  userdata() async {
    await helperfunction.getusername().then((value) {
      setState(() {
        name = value!;
      });
    });
    await helperfunction.getuseremail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await  Database(uid: FirebaseAuth.instance.currentUser!.uid).getgroup().then((snapshot){
       setState(() {
          groups = snapshot;
       });
    });
  }

  @override
  void initState() {
    userdata();
    // TODO: implement initState
    super.initState();
  }
  Stream?groups;
 String getname(String res){
    return res.substring(res.indexOf("_") + 1);
 }
 String getid(String res){
    return res.substring(0, res.indexOf("_"));
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupdialog(context);
        },
        backgroundColor: Static.PrimaryColor,
        elevation: 0,
        child: Icon(Icons.add, size: 30, color: Colors.white),

      ),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Groups", style: GoogleFonts.ubuntu(
            fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Search()));
              },
              icon: Icon(Icons.search, color: Colors.white,)

          )
        ],


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
            Text(name, textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w400, fontSize: 16),),
            SizedBox(height: 30,),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: Static.PrimaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group,),
              title: Text(
                  "Groups", style: GoogleFonts.ubuntu(color: Colors.black)),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => profile(email: email, name: name,)));
              },

              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person,),
              title: Text(
                  "Profile", style: GoogleFonts.ubuntu(color: Colors.black)),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(

                        title: Text("Sign out",
                          style: GoogleFonts.ubuntu(fontWeight: FontWeight
                              .w300),),
                        content: Text("Are you sure you want to log  out",
                          style: GoogleFonts.ubuntu(),),
                        actions: [
                          MaterialButton(
                            child: Text("Yes",
                              style: GoogleFonts.ubuntu(color: Colors.white),),
                            onPressed: () {
                              auth.Signout();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            color: Colors.red,

                          ),
                          MaterialButton(
                            child: Text("No",
                              style: GoogleFonts.ubuntu(color: Colors.white),),
                            onPressed: () {
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
              leading: Icon(Icons.logout,),
              title: Text(
                  "Sign Out", style: GoogleFonts.ubuntu(color: Colors.black)),
            ),


          ],
        ),
      ),
      body: grouplist(),

    );
  }

  popupdialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text("Create Group", style: GoogleFonts.ubuntu(),),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                          onChanged: (val) {
                            setState(() {
                              groupname = val;
                            });
                          },
                          style: GoogleFonts.ubuntu(color: Colors.black),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Static.PrimaryColor
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Static.PrimaryMaterialColor,

                                ),
                                borderRadius: BorderRadius.circular(16),
                              )
                          )
                      ),


                    ],

                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                        style: GoogleFonts.ubuntu(color: Colors.white),),
                      color: Static.PrimaryColor,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (groupname != "") {
                          setState(() {
                            _isloading = true;
                          });
                          Database(
                              uid: FirebaseAuth.instance.currentUser!.uid
                          ).creategroup(name, FirebaseAuth.instance.currentUser!
                              .uid, groupname).whenComplete(() {
                            _isloading = false;
                          });
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: "Group Created Sucessfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text("Create",
                        style: GoogleFonts.ubuntu(color: Colors.white),),
                      color: Static.PrimaryColor,
                    ),

                  ],

                );
              });
        }
    );
  }
  grouplist(){
    return StreamBuilder(
       stream: groups,
      builder: (context,  AsyncSnapshot snapshot){
        if( snapshot.hasData){
           if(snapshot.data["groups"] != null){
              if(snapshot.data["groups"].length != 0){
                return ListView.builder(
                    itemCount: snapshot.data['groups'].length,
                    itemBuilder: (context, index) {
                    int  reverseindex = snapshot.data['groups'].length - index -1;
                  return Grouptile(
                    Groupname: getname(snapshot.data['groups'][reverseindex]),
                     group_id: getid(snapshot.data['groups'][reverseindex]),

                    Username: snapshot.data['fullname'],
                  );
                },
                );

              }
              else{
                 return nodisplay();
              }
           }else{
             return  nodisplay();
           }
        }
        else{
           return Center(child: Center(child: CircularProgressIndicator(color: Static.PrimaryColor,),),);
        }








      },
    );
  }
  nodisplay(){
    return Container(
       padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Center(child: Icon(Icons.add_circle, size: 76, color: Colors.grey[500] )),
          SizedBox(height: 25),
          Text("You have not  joinned any groups, tap the add button to create a group or also search from top search button", textAlign: TextAlign.center, style: GoogleFonts.ubuntu(),),
        ],
      ),
    );
  }
}