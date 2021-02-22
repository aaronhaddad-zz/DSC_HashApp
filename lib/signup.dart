import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashcode/confirm_email.dart';
import 'package:hashcode/login.dart';
import 'package:hashcode/widgets/information_dialog.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

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

    _registerFunction() async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      if (email.text.isNotEmpty &&
          password.text.isNotEmpty &&
          confirmPassword.text.isNotEmpty &&
          password.text == confirmPassword.text) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );
          await FirebaseAuth.instance.currentUser.sendEmailVerification();
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ConfirmEmail(email.text);
              },
            ),
          );
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          print(e.code);
          switch (e.code) {
            case "email-already-in-use":
              email.clear();
              password.clear();
              confirmPassword.clear();
              informationDialog(
                  context, "The email you entered already exists!");
              break;
            case "weak-password":
              email.clear();
              password.clear();
              confirmPassword.clear();
              informationDialog(context,
                  "The password you entered is weak! Make sure it has at least 8 characters");
              break;
            case "invalid-email":
              email.clear();
              password.clear();
              confirmPassword.clear();
              informationDialog(context, "Make sure to enter a valid email");
              break;
            default:
              password.clear();
              confirmPassword.clear();
              email.clear();
              informationDialog(context,
                  "An error has occured! Please try again or contact the app developer at contact@aaronhaddad.tech");
          }
        }
      } else if (password.text != confirmPassword.text) {
        password.clear();
        confirmPassword.clear();
        setState(() {
          isLoading = false;
        });
        informationDialog(
          context,
          'The password and password confirmation are not the same',
        );
      } else {
        setState(() {
          isLoading = false;
        });
        informationDialog(context, "Please enter your details");
        email.clear();
        password.clear();
        confirmPassword.clear();
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
                          Text(
                            'REGISTRATION',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Color(0xff3a55c4),
                            ),
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
                              textInputAction: TextInputAction.next,
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
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: TextFormField(
                              controller: confirmPassword,
                              obscureText: show,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.go,
                              onEditingComplete: () async {
                                await _registerFunction();
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontSize: 16.0,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
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
                            elevation: 5.0,
                            onPressed: () async {
                              await _registerFunction();
                            },
                            child: Text(
                              'REGISTER',
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
                        'You already have an account?',
                        style: TextStyle(
                          color: Color(0xffb1b2b2),
                          fontFamily: 'Product Sans',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(
                        'Login',
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
              children: [],
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
