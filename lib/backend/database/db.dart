import "package:cloud_firestore/cloud_firestore.dart";

class Database {
  final String?uid;

  Database({this.uid});

  final CollectionReference Usercollect = FirebaseFirestore.instance.collection(
      "users");
  final CollectionReference groupcollection = FirebaseFirestore.instance
      .collection("groups");

  Future Save(String fullname, String email) async {
    Usercollect.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "groups": [],
      "uid": uid,
    }


    );
  }

  Future getuserdata(String email) async {
    QuerySnapshot snapshot = await Usercollect.where("email", isEqualTo: email)
        .get();
    return snapshot;
  }

  Future creategroup(String username, String id, String groupname) async {
    DocumentReference groupreference = await groupcollection.add({
      "groupname": groupname,
      "admin": "${uid}_${username}",
      "groupicon": " ",
      "groupid": " ",
      "members": [],
      "recentmessage": " ",
      "recentmessagesender": " ",

    });
    await groupreference.update({
      "members": FieldValue.arrayUnion(["${uid}_${username}"]),
      "groupid": groupreference.id,
    });
    DocumentReference userreference = Usercollect.doc(uid);
    return await userreference.update({
            "groups": FieldValue.arrayUnion(["${groupreference.id}_$groupname"]),
    });
  }

  getgroup() async {
    return Usercollect.doc(uid).snapshots();
  }

  groupmember(String groupid) async {
    return groupcollection.doc(groupid).snapshots();
  }

  getgroupadmin(String groupid) async {
    DocumentReference d = await groupcollection.doc(groupid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot[ "admin"];
  }

  searchbyname(String groupname) {
    return groupcollection.where("groupname", isEqualTo: groupname).get();
  }
  Future<bool?> isuserjoined(String groupname, String groupid, String username)async{
    DocumentReference userdocreference = Usercollect.doc(uid);
    DocumentSnapshot documentSnapshot = await userdocreference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupid}_$groupname")){
       return true;
    }
    else{
      return false;
    }
  }
  Future togglegroupjoin(String groupid, String username, String groupname) async {
    DocumentReference userdocreference = Usercollect.doc(uid);
    DocumentReference grouppreference = groupcollection.doc(groupid);
    DocumentSnapshot documentSnapshot = await userdocreference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupid}_$groupname")) {
      await userdocreference.update({
        "groups": FieldValue.arrayRemove(["${groupid}_$groupname"]),
      });
      await grouppreference.update({
        "members": FieldValue.arrayRemove(["${uid}_${username}"]),

      });
    }
    else {
      await userdocreference.update({
        "groups": FieldValue.arrayUnion(["${groupid}_$groupname"]),
      });
      await grouppreference.update({
        "members": FieldValue.arrayUnion(["${uid}_${username}"]),

      });
    }
  }
  Future togglegroupleave(String groupid,String groupname, String username) async {
    DocumentReference userdocreference = Usercollect.doc(uid);
    DocumentReference grouppreference = groupcollection.doc(groupid);
    DocumentSnapshot documentSnapshot = await userdocreference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

      await userdocreference.update({
        "groups": FieldValue.arrayRemove(["${groupid}_$groupname"]),
      });
      await grouppreference.update({
        "members": FieldValue.arrayRemove(["${uid}_${username}"]),

      });


  }
  sendmessage(String groupid, Map<String, dynamic> chatmessagedata)async{
    await  groupcollection.doc(groupid).collection("message").add(chatmessagedata);
    await groupcollection.doc(groupid).update({
      "recentmessage": chatmessagedata['message'],
    "recentmessagesender": chatmessagedata['sender'],
      "time": chatmessagedata["time"].toString(),
      "email": chatmessagedata['email'],
    });
  }
 getchat(String groupid)async{
     return groupcollection
         .doc(groupid)
         .collection('message')
         .orderBy("time")
         .snapshots();
 }
}

