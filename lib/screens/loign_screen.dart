import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_app/controllers/auth.dart';
import 'package:full_app/screens/signup_screen.dart';
import 'package:full_app/screens/tasks.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color secondaryColor = Color(0xff232c51);
  Color primaryColor = Color(0xff18203d);
  Color logoGreen = Color(0xff25bcbb);
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void login() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signin(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TasksPage(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'images/check.jpg',
                height: 200.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Login Here",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: logoGreen,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: logoGreen, fontSize: 20.0),
                        cursorColor: logoGreen,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: logoGreen)),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.white)),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "This Field Is Required"),
                          EmailValidator(errorText: "Invalid Email Address"),
                        ]),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          style: TextStyle(color: logoGreen, fontSize: 20.0),
                          cursorColor: logoGreen,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: logoGreen)),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.white)),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Password Is Required"),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required"),
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      MaterialButton(
                        minWidth: 200.0,
                        height: 50.0,
                        // passing an additional context parameter to show dialog boxs
                        onPressed: login,
                        color: logoGreen,
                        textColor: Colors.white,
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Sign In with',
                    style: TextStyle(color: Colors.white54),
                  ),
                  MaterialButton(
                      onPressed: () => googleSignIn().whenComplete(() async {
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => TasksPage()));
                          }),
                      child: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      )),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  "Sign Up Here",
                  style: TextStyle(color: logoGreen),
                ),
              ),
              SizedBox(height: 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/check.jpg',
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Designed by KZEN',
                    style: TextStyle(color: Colors.white38),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
