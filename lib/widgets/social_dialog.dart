import 'package:flutter/material.dart';
import 'package:hashcode/widgets/information_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

void socialDialog(
    BuildContext context, String name, String linkedin, String github) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name + ' is on',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Product Sans',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  8.0,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunch(linkedin)) {
                          launch(linkedin);
                        } else {
                          informationDialog(
                            context,
                            'An error has occured.\nPlease visit $linkedin',
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/images/social/linkedin.png',
                        width: 40.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (await canLaunch(github)) {
                          launch(github);
                        } else {
                          informationDialog(
                            context,
                            'An error has occured.\nPlease visit $github',
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/images/login/github.png',
                        width: 40.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text(
                'OK',
              ),
              onPressed: () {
                return Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
