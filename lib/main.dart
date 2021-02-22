import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashcode/appin.dart';
import 'package:hashcode/confirm_email.dart';
import 'package:hashcode/login.dart';
import 'package:hashcode/name.dart';
import 'package:hashcode/widgets/network_error.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_restart/flutter_restart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    MaterialApp(
      key: _navigatorKey,
      debugShowCheckedModeBanner: false,
      home: HashCodeApp(),
    ),
  );
}

class HashCodeApp extends StatefulWidget {
  HashCodeApp({Key key}) : super(key: key);

  @override
  _HashCodeAppState createState() => _HashCodeAppState();
}

final _navigatorKey = GlobalKey<NavigatorState>();

class _HashCodeAppState extends State<HashCodeApp> {
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Firebase.app();
    DataConnectionChecker().hasConnection.then((has) {
      if (has) {
        FirebaseAuth.instance.authStateChanges().listen(
          (User user) {
            if (user != null) {
              return Timer(
                Duration(seconds: 2),
                () {
                  FirebaseAuth.instance.currentUser.reload().then((value) {
                    if (FirebaseAuth.instance.currentUser.emailVerified) {
                      if (FirebaseAuth.instance.currentUser.displayName ==
                          null) {
                        return Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Name();
                        }));
                      } else {
                        return Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AppIn();
                            },
                          ),
                        );
                      }
                    } else if (!FirebaseAuth
                        .instance.currentUser.emailVerified) {
                      return Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ConfirmEmail(
                              FirebaseAuth.instance.currentUser.email,
                            );
                          },
                        ),
                      );
                    }
                  });
                },
              );
            } else {
              return Timer(
                Duration(seconds: 2),
                () {
                  setState(() {
                    showButton = true;
                  });
                },
              );
            }
          },
        );
      } else {
        networkError(
          context,
          () {
            FlutterRestart.restartApp();
          },
        );
      }
    });
  }

  bool showButton = false;

  RoundedLoadingButtonController _controller =
      new RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
            colors: [
              Color(0xff5ea2e1),
              Color(0xff3f55e7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '#',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 100.0,
                  fontFamily: 'Product Sans',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  5.0,
                ),
              ),
              Text(
                'HashApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  5.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40.0,
                child: Text(
                  'This app is designed to help you prepare for Google\'s Hash Code competition.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Product Sans',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  20.0,
                ),
              ),
              Visibility(
                visible: showButton,
                child: RoundedLoadingButton(
                  controller: _controller,
                  onPressed: () async {
                    return Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  color: Colors.white,
                  errorColor: Colors.red,
                  successColor: Colors.green,
                  valueColor: Colors.black,
                  child: Text(
                    'LET\'S START',
                    style: TextStyle(
                      color: Color(0xff3a56c7),
                      fontFamily: 'Product Sans',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 200.0,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Image.asset(
        'assets/images/hump.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
