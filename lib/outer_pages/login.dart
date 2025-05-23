//import 'package:firebase_auth/firebase_auth.dart';

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traderapp/components/button.dart';
import 'package:traderapp/components/mytextfeild.dart';
import 'package:traderapp/models/current_userdetails.dart';
//import 'package:traderapp/models/current_userdetails.dart';
import 'package:traderapp/models/retailer.dart';
import 'package:traderapp/models/supplier.dart';
//import 'package:traderapp/retailerpages/home.dart';
import 'package:traderapp/services/firebaseauthentication.dart';
import 'package:traderapp/services/firestoreuseroptions.dart';
//import 'package:traderapp/supplierpages/home.dart';
//import 'package:traderapp/themes.dart';

class LoginPage extends StatefulWidget {
  final void Function()? changepage;
  const LoginPage({super.key, required this.changepage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final fireBaseAuthentication = FireBaseAuthentication();

      try {
        await fireBaseAuthentication
            .signInWithEmailPassword(_email.text.trim(), _pword.text.trim())
            .then(
              (value) => navigate(context),
            );
      } on FirebaseAuthException catch (e) {
        // TODO
        log(e.toString());
        showDialog(
          context: context,
          builder: (context) => AlertDialog(backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text(e.toString(),style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
          ),
        );
      }
    }
  }

  navigate(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirestoreReadUser().readUserInfo().then((myuser) {
          Provider.of<CurrentUserDraft>(context, listen: false)
              .loadCurrentUser(myuser);

          if (myuser is Supplier) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/SupHome', (_) => false);
          } else if (myuser is Retailer) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/RetHome', (_) => false);
          }
        });
      } on FirebaseAuthException catch (e) {
        // TODO
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('account login error'),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                        width: 100,
                        height: 100,
                        image: AssetImage('lib/assets/sell.png')),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'WELCOME BACK !',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextFeild(
                        hinttext: 'email',
                        textController: _email,
                        validator: validateEmail),
                    const SizedBox(
                      height: 3,
                    ),
                    MyTextFeild(
                      hinttext: 'password',
                      textController: _pword,
                      obscuretext: true,
                      validator: (string) {
                        if (string == null || string == '') {
                          return 'password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyButton(
                      msg: 'login',
                      onPressed: () => login(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'don\'t have an account ?',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          GestureDetector(
                            onTap: widget.changepage,
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    // if (!password.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    // if (!password.contains(RegExp(r'[a-z]'))) {
    //   return 'Password must contain at least one lowercase letter';
    // }
    // if (!password.contains(RegExp(r'[0-9]'))) {
    //   return 'Password must contain at least one number';
    // }
    return null; // Return null if password is valid
  }
}
