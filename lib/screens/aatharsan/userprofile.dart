import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spac/home.dart';
import 'package:spac/models/aatharsan/user.dart';
import 'package:spac/screens/aatharsan/signin.dart';
import 'package:spac/screens/aatharsan/userlistpage.dart';
import 'package:spac/services/authenthication.dart';
import 'package:spac/services/validfunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});
  final AuthService _auth = AuthService();

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserModel currentUser = UserModel();

  bool isLoading = false;
  late final String UserId;
  late dynamic result = 'Email';

  final updateUserForm = GlobalKey<FormState>();

  String? img = '';
  // Initial Selected Value
  String dropdownvalue = 'Male';
  String? dropVal;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    result = auth.currentUser?.uid;
    isLoading = true;

    setState(() {
      UserId = result!;
      if (auth.currentUser?.photoURL != null) {
        img = auth.currentUser?.photoURL;
      }
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Main()),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<UserModel?>(
          future: readUser(UserId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return user == null
                  ? const Center(child: Text('No User'))
                  : buildUserForm(user);
            } else {
              return Container();
            }
          },
        ),
      );
  Future<UserModel?> readUser(userId) async {
    final docUser = _fireStore.collection("users").doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      if (kDebugMode) {}

      currentUser = UserModel.fromMap(snapshot.data()!);
      return currentUser;
    }
    return null;
  }

  Widget buildUserForm(UserModel user) {
    firstNameController.text = user.firstName ?? 'First Name';
    lastNameController.text = user.lastName ?? 'Last Name';
    emailController.text = user.email ?? 'Email';

    return Form(
        key: updateUserForm,
        autovalidateMode: AutovalidateMode.always,
        onChanged: () {
          updateUserForm.currentState!.save();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              child: Text('View Users'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListPage()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0.0, 20, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: GestureDetector(
                          child: Column(
                        children: [
                          const SizedBox(height: 10),
                        ],
                      )),
                    ),
                  ),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your First name?',
                      labelText: 'First Name *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your First Name';
                      }
                      if (!value.isValidName()) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your Last name?',
                      labelText: 'Last Name *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your Last Name';
                      }
                      if (!value.isValidName()) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your Email?',
                      labelText: 'Email *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a email';
                      }
                      if (!value.isValidEmail()) {
                        return 'Phone Number should be a number';
                      }
                      return null;
                    },
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('Update Profile'),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          dynamic result = await _auth.updateUser(
                              firstNameController.text,
                              lastNameController.text,
                              emailController.text,
                              dropVal,
                              img);
                          if (result == 'Success') {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text("User Data Updated"),
                              backgroundColor: Colors.blue,
                            ));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text(result),
                            ));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                      )),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: const Text('Delete Account'),
                      onPressed: () async {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext contextF) => AlertDialog(
                            title: const Text('Delete Account'),
                            content: const Text(
                                "Deleting this account will result in the loss of all your entered data, and you won't be able to recover the account."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(contextF, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.pop(contextF, 'OK');
                                  dynamic result = await _auth.deleteUser();
                                  print(result);
                                  if (result == 'Success') {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignIn()));
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print('Error');
                                  }
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
