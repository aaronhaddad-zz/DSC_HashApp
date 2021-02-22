import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashcode/login.dart';
import 'package:hashcode/name.dart';
import 'package:hashcode/widgets/confirmation_dialog.dart';
import 'package:hashcode/widgets/information_dialog.dart';

class ConfirmEmail extends StatelessWidget {
  final String emailAddress;
  ConfirmEmail(this.emailAddress);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        shadowColor: Color(0xff),
        backgroundColor: Color(0xff),
        toolbarHeight: 200.0,
        leading: Icon(
          Icons.exit_to_app,
          color: Color(0xff),
        ),
        centerTitle: true,
        title: Text(
          '#',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Product Sans',
            fontSize: 150.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            color: Color(0xff3f54e7),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).size.height / 3),
              color: Color(0xff5996e1),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please confirm your email!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Product Sans',
                  fontSize: 20.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  10.0,
                ),
              ),
              Text(
                'We have sent an email to ' + emailAddress,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Product Sans',
                  fontSize: 18.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  10.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 20.0,
                    child: FlatButton(
                      color: Color(0xff3e52e7),
                      child: Text(
                        'Send again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.currentUser
                            .sendEmailVerification();
                        await Future.delayed(
                          Duration(seconds: 1),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 20.0,
                    child: FlatButton(
                      color: Color(0xff3e52e7),
                      child: Text(
                        'I have clicked the link',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.currentUser.reload();
                          if (FirebaseAuth.instance.currentUser.emailVerified) {
                            await Future.delayed(
                              Duration(seconds: 1),
                            );
                            return Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                //todo: Get user to enter his name
                                builder: (context) => Name(),
                              ),
                            );
                          } else {
                            informationDialog(
                              context,
                              'Please confirm your email, make sure to check your spam folder',
                            );
                          }
                        } catch (e) {
                          informationDialog(
                            context,
                            'An error has occured. Please try again.\nIf the error persists contact the app developer',
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 10.0,
        ),
        child: GestureDetector(
          onLongPress: () {},
          onTap: () {
            confirmationDialog(
              context,
              () async {
                try {
                  await FirebaseAuth.instance.currentUser.delete();
                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'Your account has been succesfully deleted.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Product Sans',
                        ),
                      ),
                    ),
                  );
                  await Future.delayed(Duration(seconds: 1));
                  return Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                } catch (e) {
                  informationDialog(context, e.toString());
                }
              },
              'Are you sure you want to delete your account?',
            );
          },
          child: Text(
            'Cancel and delete my account',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Product Sans',
            ),
          ),
        ),
      ),
    );
  }
}
