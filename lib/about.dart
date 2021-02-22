import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashcode/widgets/confirmation_dialog.dart';
import 'package:hashcode/widgets/drawer.dart';
import 'package:hashcode/widgets/social_dialog.dart';

import 'local_db/db.dart';
import 'login.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    void _delete() async {
      final rowsDeleted = await Initdb.instance.delete(0);
    }

    return Scaffold(
      drawer: DrawerMenu(),
      backgroundColor: Color(0xfff1f2f3),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff3e52e7),
        centerTitle: true,
        title: Text(
          'HashApp',
          style: TextStyle(
            fontFamily: 'Product Sans',
            fontSize: 25.0,
          ),
        ),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
          ),
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(
              Icons.menu,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 20.0,
            ),
            child: GestureDetector(
              onTap: () async {
                confirmationDialog(
                  context,
                  () async {
                    await FirebaseAuth.instance.signOut();
                    _delete();
                    return Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  'Are you sure you want to logout? This will result in complete data loss including your score and progress',
                );
              },
              child: Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Overview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'This app is designed to help you preapre for the HashCode programming contest.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30.0,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Rules',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Score:',
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Your score depends on the problems you solved, submissions and coins.\nYour rank is determined by your score.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Coins:',
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Everyone starts with 25 coins. You can earn coins by solving problems.\nPS: Wrong outputs will decrease the bonus points you will earn.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Cost:',
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Each hint will cost you 50 coins.\nEach solution will cost you 150 coins.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Levels:',
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Each level excpet the tutorial one will be unlocked as you complete levels.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 50.0,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Behind HashApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff313131),
                    fontFamily: 'Product Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 12.0,
                left: 8.0,
                right: 8.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          socialDialog(
                              context,
                              'Aziz Bel Haj Amor',
                              'https://www.linkedin.com/',
                              'https://www.github.com/');
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: ExactAssetImage(
                            'assets/images/about/aziz.jpg',
                          ),
                        ),
                      ),
                      Text(
                        'Aziz Bel Haj Amor',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Content & Design',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Product Sans',
                          color: Color(0xffaaaaab),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          socialDialog(
                              context,
                              'Meriem Jazzar',
                              'https://www.linkedin.com/',
                              'https://www.github.com/');
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: ExactAssetImage(
                            'assets/images/about/meriem.jpg',
                          ),
                        ),
                      ),
                      Text(
                        'Meriem Jazzar',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Project manager',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Product Sans',
                          color: Color(0xffaaaaab),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          socialDialog(
                            context,
                            'Aaron Haddad',
                            'https://www.linkedin.com/in/haddadaaron',
                            'https://www.github.com/aaronhaddad',
                          );
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: ExactAssetImage(
                            'assets/images/about/aaron.jpg',
                          ),
                        ),
                      ),
                      Text(
                        'Aaron Haddad',
                        style: TextStyle(
                          fontFamily: 'Product Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'App development',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Product Sans',
                          color: Color(0xffaaaaab),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
