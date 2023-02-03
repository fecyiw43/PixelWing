import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication.dart';
import '../main.dart';

class GuestSignInButton extends StatelessWidget {
  const GuestSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 59, 59, 59)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => StartScreen()),
            );
          } else {
            Authentication.signOut(context: context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(builder: (context) => StartScreen()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Image(
                image: AssetImage('assets/logos/guest_login_logo.png'),
                height: 35.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  '   Sign in as Guest   ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
