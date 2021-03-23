import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

signIn(String email, String password, Function ok, Function mailOrPasswordError,
    Function otherError) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  try {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;

    ok();

    User userObj = await getUserObject(user.uid);
    return userObj;
  } catch (e) {
    if (e.code == "ERROR_INVALID_EMAIL" ||
        e.code == "ERROR_WRONG_PASSWORD" ||
        e.code == "ERROR_USER_NOT_FOUND") {
      mailOrPasswordError();
    } else {
      otherError();
      print(e);
    }
  }
}

signInBegoodier(String username, String password, Function ok,
    Function mailOrPasswordError, Function otherError) async {
  try {
    Firestore.instance
        .collection('provider')
        .document(username)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.data != null) {
        if (ds.data["password"] == password) {
          ok();
          // shared preferences ile hafızaya atcaz
        } else {
          mailOrPasswordError();
        }
      } else {
        print("kullanıcı bulunamadı");
        mailOrPasswordError();
      }
    });
  } catch (e) {
    otherError();
  }
}

createUser({
  String uid,
  int gender,
  String city,
  String address,
}) {
  Firestore.instance.collection('users').document(uid).setData({
    'gender': gender,
    'city': city,
    'address': address,
  });
}

signUp(
    {String email,
    String password,
    String name,
    int gender,
    String city,
    String address,
    Function alreadyInUse,
    Function weakPassword,
    Function error}) async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  try {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    createUser(
      uid: user.uid,
      gender: gender,
      city: city,
      address: address,
    );

    return user.uid;
  } catch (e) {
    if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
      alreadyInUse();
    } else if (e.code == "ERROR_WEAK_PASSWORD") {
      weakPassword();
    } else {
      error();
    }

    print(e);
  }
}

getUserObject(String uid) async {
  User user;
  await Firestore.instance
      .collection('users')
      .document(uid)
      .get()
      .then((DocumentSnapshot ds) {
    user = User(
      uid: uid,
      gender: ds.data["gender"],
      address: ds.data["address"],
      city: ds.data["city"],
      name: ds.data["name"],
    );
  });
  return user;
}

getProvider(String username) async {
  DocumentSnapshot data;
  data =
      await Firestore.instance.collection('provider').document(username).get();
  return data;
}

getCurrentUser() async {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser userAuth = await _firebaseAuth.currentUser();

  User user = await getUserObject(userAuth.uid);
  return user;
}

class User {
  String uid;
  String name;
  int gender;
  String city;
  String address;

  User({this.uid, this.name, this.gender, this.city, this.address});
}
