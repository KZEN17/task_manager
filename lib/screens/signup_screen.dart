import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_app/controllers/auth.dart';
import 'package:full_app/screens/loign_screen.dart';
import 'package:full_app/screens/tasks.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void handleSignup() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signUp(email.trim(), password, context).then((value) {
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
              Image.asset('images/check.jpg', height: 200,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Signup Here",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
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
                        validator: (_val) {
                          if (_val.isEmpty) {
                            return "Can't be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          obscureText: true,
                          style: TextStyle(color: logoGreen, fontSize: 20.0),
                          cursorColor: logoGreen,
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
                                errorText: "This Field Is Required."),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required.")
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      MaterialButton(
                        height: 50.0,
                        minWidth: 200.0,
                        onPressed: handleSignup,
                        color: logoGreen,
                        textColor: Colors.white,
                        child: Text(
                          "Sign Up",
                            style: TextStyle(fontSize: 20.0)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () => googleSignIn().whenComplete(() async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => TasksPage()));
                }),
                child: Icon(FontAwesomeIcons.google,color: Colors.white54,),
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Login Here",
                  style: TextStyle(color: logoGreen),
                ),
              ),
              SizedBox(height: 30.0,),
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
