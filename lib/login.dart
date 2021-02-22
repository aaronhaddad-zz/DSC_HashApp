import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashcode/signup.dart';
import 'package:hashcode/widgets/information_dialog.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:loading_animations/loading_animations.dart';

import 'appin.dart';
import 'local_db/db.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  //Just to show the password
  bool show = true;
  Icon passwordEye = Icon(
    Icons.visibility_off,
    color: Colors.black,
  );
  Icon clearEmail = Icon(
    Icons.clear,
    color: Colors.white,
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    GestureDetector emailClear = new GestureDetector(
      onTap: () {
        email.text = '';
        setState(() {
          clearEmail = Icon(
            Icons.clear,
            color: Colors.white,
          );
        });
      },
      child: clearEmail,
    );
    GestureDetector passwordShow = new GestureDetector(
      onTap: () {
        if (show) {
          setState(() {
            show = false;
            passwordEye = Icon(
              Icons.visibility,
              color: Colors.black,
            );
          });
        } else {
          setState(() {
            show = true;
            passwordEye = Icon(
              Icons.visibility_off,
              color: Colors.black,
            );
          });
        }
      },
      child: passwordEye,
    );

    void _insert(
      int uid,
      int coins,
      int lockedLevels,
      String solvedProblems,
      int numberOfSolved
    ) async {
      // row to insert
      Map<String, dynamic> row = {
        Initdb.columnId: uid,
        Initdb.columnCoins: coins,
        Initdb.columnLockedLevels: lockedLevels,
        Initdb.columnSolvedProblem: solvedProblems,
        Initdb.columnNumberOfSolved: numberOfSolved
      };
      final id = await Initdb.instance.insert(row);
    }

    _loginFunction() async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email.text, password: password.text);
          await Future.delayed(
            Duration(seconds: 1),
          );
          _insert(0, 100, 4, "0000000", 0);
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AppIn();
              },
            ),
          );
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          switch (e.code) {
            case "ERROR_INVALID_EMAIL":
              email.clear();
              password.clear();
              informationDialog(context, "The email you entered is invalid");
              break;
            case "ERROR_WRONG_PASSWORD":
              password.clear();
              informationDialog(
                  context, "The password you entered is not correct");
              break;
            case "ERROR_USER_NOT_FOUND":
              email.clear();
              password.clear();
              informationDialog(context,
                  "Oops, we don'\t seem to find you in our servers? Create an account!");
              break;
            case "ERROR_USER_DISABLED":
              email.clear();
              password.clear();
              informationDialog(context,
                  "The user with this email has his account disabeled. Please contact the app developer at contact@aaronhaddad.tech");
              break;
            case "ERROR_TOO_MANY_REQUESTS":
              email.clear();
              password.clear();
              informationDialog(context,
                  "Too many requests. Try again later.\nIf the error persists, contact the app developer at contact@aaronhaddad.tech");
              break;
            case "ERROR_OPERATION_NOT_ALLOWED":
              email.clear();
              password.clear();
              informationDialog(context,
                  "Due to some violations, we have disabeled the user with this email\nIf you think this is a mistake please leave a message at contact@aaronhaddad.tech");
              break;
            default:
              email.clear();
              password.clear();
              informationDialog(context,
                  "Oops an error has occured. Try again or contact the app developer at contact@aaronhaddad.tech");
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
        informationDialog(context, 'Please make sure to fill your details');
        email.clear();
        password.clear();
      }
    }

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Color(0xfff1f2f3),
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                color: Color(0xff5995e2),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 100.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 80.0,
                      height: 340.0,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                          Image.asset(
                            'assets/images/login/hash.png',
                            height: 90.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 0) {
                                  setState(() {
                                    clearEmail = Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    );
                                  });
                                } else {
                                  setState(() {
                                    clearEmail = Icon(
                                      Icons.clear,
                                      color: Colors.redAccent,
                                    );
                                  });
                                }
                              },
                              controller: email,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: emailClear,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 16.0,
                                  color: Color(0xffcecece),
                                ),
                                icon: Image.asset(
                                  'assets/images/login/username.png',
                                  height: 30.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: TextFormField(
                              controller: password,
                              obscureText: show,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.go,
                              onEditingComplete: () async {
                                await _loginFunction();
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontSize: 16.0,
                                  color: Color(0xffcecece),
                                ),
                                icon: Image.asset(
                                  'assets/images/login/password.png',
                                  height: 30.0,
                                ),
                                suffixIcon: passwordShow,
                              ),
                              enableSuggestions: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (email.text.isNotEmpty) {
                                try {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: email.text);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'An email has been sent to ' +
                                            email.text,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontFamily: 'Product Sans',
                                        ),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  informationDialog(context,
                                      'An error has occured. Please contact the app developer at contact@aaronhaddad.tech');
                                }
                              } else {
                                informationDialog(
                                    context, 'Please enter your email');
                              }
                            },
                            onLongPress: () {
                              informationDialog(
                                context,
                                'If you have forgotten your password this will send you an email to recover and create a new password!',
                              );
                            },
                            child: Text(
                              'Forgot your password? Click here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                color: Color(0xffb1b2b2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200.0,
                        height: 70.0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 18.0),
                          child: MaterialButton(
                            onPressed: () async {
                              await _loginFunction();
                            },
                            child: Text(
                              'LOG IN',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xfffcfcfc),
                              ),
                            ),
                            color: Color(0xff3e52e7),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'If you don\'t have an account',
                        style: TextStyle(
                          color: Color(0xffb1b2b2),
                          fontFamily: 'Product Sans',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xff3b52b2),
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 100.0,
            color: Color(0xff3e52e7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*GestureDetector(
                onTap: () {},
                onLongPress: () {
                  informationDialog(context,
                      'Using Google will make you an account with your Google account, thus simplifying the login process');
                },
                child: Image.asset(
                  'assets/images/login/google.png',
                  height: 40.0,
                ),
              ),
              GestureDetector(
                onTap: () {},
                onLongPress: () {
                  informationDialog(context,
                      'Using Facebook will make you an account with your Facebook account, thus simplifying the login process');
                },
                child: Image.asset(
                  'assets/images/login/facebook.png',
                  height: 40.0,
                ),
              ),
              GestureDetector(
                onTap: () {},
                onLongPress: () {
                  informationDialog(context,
                      'Using Facebook will make you an account with your Facebook account, thus simplifying the login process');
                },
                child: Image.asset(
                  'assets/images/login/github.png',
                  height: 40.0,
                ),
              ),*/
              ],
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: LoadingBouncingGrid.square(
                backgroundColor: Colors.black,
                borderColor: Color(0xff),
                size: 100.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
