import 'package:spac/home.dart';
import 'package:spac/screens/aatharsan/signup.dart';
import 'package:spac/screens/praveen/item_list_screen/item_list_screen.dart';
import 'package:spac/services/authenthication.dart';
import 'package:spac/services/validfunctions.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obsecureText = true;
  bool isLoading = false;
  final AuthService _auth = AuthService();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
                key: _signInFormKey,
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  Form.of(primaryFocus!.context!).save();
                },
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                            child: Center(
                              child: Text(
                                'SignIn',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              labelText: 'Email *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter an email';
                              }
                              if (!value.isValidEmail()) {
                                return 'Enter Valid Email';
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: pass,
                                  obscureText: _obsecureText,
                                  decoration: const InputDecoration(
                                    labelText: 'Password *',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obsecureText = !_obsecureText;
                                    });
                                  },
                                  icon:
                                      const Icon(Icons.remove_red_eye_outlined))
                            ],
                          ),
                          Container(
                              height: 70,
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                ),
                                child: const Text('Login'),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  dynamic result = await _auth.signInEmail(
                                      email.text, pass.text);
                                  if (result == 'Success') {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Successfully Logged'),
                                      backgroundColor: Colors.blue,
                                    ));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ItemListScreen()),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(new SnackBar(
                                      content: new Text(result),
                                    ));
                                  }
                                },
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Do you not have an account?'),
                              TextButton(
                                child: const Text(
                                  'signup',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignUp()));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
