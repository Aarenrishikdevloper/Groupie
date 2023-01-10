import 'package:shared_preferences/shared_preferences.dart';
class helperfunction{
    static  String  userlogedkey = "LOGGEDINKEy";
    static String usernamekey = "UserNameKey";
    static String useremailkey = "USEREMAILKEY";
    static Future<bool?>getuserstatus()async{
      SharedPreferences  preferences = await SharedPreferences.getInstance();
      return  preferences.getBool(userlogedkey);
    }
    static  Future<bool> savedusername(String username) async{
       SharedPreferences preferences = await  SharedPreferences.getInstance();
       return preferences.setString(usernamekey, username);

    }
    static Future<bool> savedemail(String email) async{
        SharedPreferences preferences =  await SharedPreferences.getInstance();
        return preferences.setString(useremailkey, email);
    }
    static Future<bool> saveduserstatus(bool isloged)async{
      SharedPreferences preferences =  await SharedPreferences.getInstance();
      return preferences.setBool(userlogedkey, isloged);
    }
    static Future<String?> getusername()async{
      SharedPreferences preferences =  await SharedPreferences.getInstance();
       return preferences.getString(usernamekey);
    }
    static Future<String?> getuseremail()async{
      SharedPreferences preferences =  await SharedPreferences.getInstance();
      return preferences.getString(useremailkey);
    }


}