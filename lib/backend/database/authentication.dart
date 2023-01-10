import 'package:chatapp/backend/database/db.dart';
import 'package:chatapp/backend/service/helper.dart';
import "package:firebase_auth/firebase_auth.dart";
class Authservice{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future userregister(String fullname, String email, String password) async{
    try{
       User user = (await firebaseAuth.createUserWithEmailAndPassword(
         email:  email, password: password
       )).user !;
       if(user != null ){
         await Database(uid: user.uid, ).Save(fullname, email);
         return true;
       }
    } on FirebaseAuthException catch(e){
       return e.message;
    }
  }
  Future Signout() async {
    try {
      await helperfunction.saveduserstatus(false);
      await helperfunction.savedemail("");
      await helperfunction.savedusername("");
      await firebaseAuth.signOut();
    }
    catch (e) {
      return null;
    }
  }
  Future loginwithemail(String email, String password)async{
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user !;
      if(user != null){
         return true;
      }

    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
}

