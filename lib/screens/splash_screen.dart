import 'package:flutter/material.dart';

import 'loign_screen.dart';

class SplashScreen extends StatelessWidget {
  Color secondaryColor = Color(0xff232c51);
  Color primaryColor = Color(0xff18203d);
  Color logoGreen = Color(0xff25bcbb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //We take the image from the assets
          Image.asset(
            'images/check.jpg',
            height: 250,
          ),
          SizedBox(
            height: 20,
          ),
          //Texts and Styling of them
          Text(
            'Welcome to Zen  Tasks !',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          SizedBox(height: 20),
          Text(
            'A one-stop portal for you to get organized and increase productivity',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 30,
          ),
          //Our MaterialButton which when pressed will take us to a new screen named as
          //LoginScreen
          MaterialButton(
            elevation: 0,
            height: 50,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
            color: logoGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Get Started',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}
