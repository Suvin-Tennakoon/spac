import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spac/models/aatharsan/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  var uuid = Uuid();
  late final String _uid;

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _fireStore.collection('users').get();

      List<UserModel> users = [];
      querySnapshot.docs.forEach((doc) {
        UserModel user = UserModel.fromMap(doc.data());
        users.add(user);
      });

      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future signupUser(firstName, lastName, email, password) async {
    try {
      UserModel userModel = UserModel();

      userModel.firstName = firstName;
      userModel.lastName = lastName;
      userModel.email = email;

      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((userCredential) async {
        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(firstName + " " + lastName);
          userModel.uid = user.uid;
        }
      });

      await _fireStore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());

      await _auth.signOut();

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  //Sign in with email and password
  Future signInEmail(formEmail, formPassword) async {
    if (_auth.currentUser != null) {
      return 'User already Signed In in to the System';
    } else {
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
            email: formEmail, password: formPassword);

        DateTime today = DateTime.now();
        String nowTime = "$today";
        String dateStr = "${today.year}-${today.month}-${today.day}";
        String hourStr = "${today.hour}";
        String minuteStr = "${today.minute}";

        await _fireStore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('userLog')
            .doc(nowTime);

        return 'Success';
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        }
      } catch (e) {
        return e.toString();
      }
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return (result);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  //Delete user from the firebase
  Future deleteUser() async {
    try {
      String? userid = _auth.currentUser?.uid;
      await _auth.currentUser!.delete().then((value) async =>
          await _fireStore.collection('users').doc(userid).delete());

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
      return null;
    }
  }

  //User state check
  Future authStateCheck() async {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        return null;
      } else {
        print('User is signed in!');
      }
    });
  }

  //Password reset
  Future changePassword(password) async {
    try {
      final user = _auth.currentUser;

      await user?.updatePassword(password);

      print("Successfully changed password");
      return 'Success';
    } catch (e) {
      print(e);
      return 'Failed';
    }
  }

  //Return user id from firebaseAuth
  Future getCurrentUserId() async {
    final user = await _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return 'No User';
    }
  }

  //Update firestore data
  Future updateUser(firstNameUpdated, lastNameUpdated, emailUpdated,
      dropdownval, image) async {
    try {
      if (image != null) {
        await _auth.currentUser?.updatePhotoURL(image);
      }

      await _auth.currentUser?.updateEmail(emailUpdated);
      await _auth.currentUser
          ?.updateDisplayName(firstNameUpdated + " " + lastNameUpdated);
      await _fireStore.collection('users').doc(_auth.currentUser?.uid).update({
        'firstName': firstNameUpdated,
        'lastName': lastNameUpdated,
        'email': emailUpdated,
        'gender': dropdownval
      });
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }
}
