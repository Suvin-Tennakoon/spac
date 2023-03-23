import 'package:flutter/material.dart';
import 'package:spac/screens/aatharsan/signin.dart';
import 'package:spac/services/authenthication.dart';
import 'package:spac/services/validfunctions.dart';
import 'package:spac/widgets/loading.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService auth = AuthService();

  bool isLoading = false;
  bool _obsecureText = true;

  final registrationFormUser = GlobalKey<FormState>();

  //Declaring text editing controllers
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Form(
                key: registrationFormUser,
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  Form.of(primaryFocus!.context!).save();
                },
                child: Wrap(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: Center(
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: firstName,
                            decoration: const InputDecoration(
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
                            controller: lastName,
                            decoration: const InputDecoration(
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: confirmPass,
                                  obscureText: _obsecureText,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password *',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a password';
                                    }
                                    if (pass.text != confirmPass.text) {
                                      return 'Password do not match';
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
                                  minimumSize: const Size.fromHeight(
                                      40), // fromHeight use double.infinity as width and 40 is the height
                                ),
                                child: const Text('SignUp'),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (registrationFormUser.currentState!
                                      .validate()) {
                                    dynamic result = await auth.signupUser(
                                        firstName.text,
                                        lastName.text,
                                        email.text,
                                        pass.text);

                                    if (result == 'Success') {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Successfully Created'),
                                        backgroundColor: Colors.blue,
                                      ));
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const SignIn()));
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(result),
                                      ));
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Please check the fields'),
                                    ));
                                  }
                                },
                              )),
                        ],
                      ),
                    )
                  ],
                )),
          ));
}
