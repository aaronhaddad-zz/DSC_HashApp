import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashcode/widgets/confirmation_dialog.dart';
import 'package:hashcode/widgets/drawer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'local_db/db.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  RoundedLoadingButtonController _controller =
      new RoundedLoadingButtonController();

  void _delete() async {
    final rowsDeleted = await Initdb.instance.delete(0);
  }

  int rank = 0, accepted = 0, score = 0, coins = 0;

  @override
  void initState() {
    super.initState();
    Initdb.instance.numberOfSolved().then((solved) {
      setState(() {
        accepted = solved;
        score = accepted * 25;
      });
      Initdb.instance.coins().then((gotCoins) {
        setState(() {
          coins = gotCoins;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //todo: update thr rank in the inits
    return Scaffold(
      backgroundColor: Color(0xfff1f2f3),
      key: _scaffoldKey,
      drawer: DrawerMenu(),
      appBar: AppBar(
        backgroundColor: Color(0xff3e52e7),
        centerTitle: true,
        title: Text(
          'Profile',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 40.0,
                  ),
                ),
                Image.asset(
                  'assets/images/profile/level0.png',
                  height: 100.0,
                ),
                Text(
                  FirebaseAuth.instance.currentUser.email,
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser.displayName,
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(new ClipboardData(
                        text: FirebaseAuth.instance.currentUser.uid));
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'The userID has been copied to your clipboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Product Sans',
                        ),
                      ),
                    ));
                  },
                  child: Text(
                    FirebaseAuth.instance.currentUser.uid,
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  'Level 0',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontSize: 17.0,
                    color: Color(0xffb6b6b7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(
                20.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width - 40.0,
            height: 300.0,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Color(0xff),
                      title: Text(
                        'Score board',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Product Sans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/profile/solution.png',
                              height: 30.0,
                            ),
                            Text(
                              accepted.toString() + '\nAccepted',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/profile/score.png',
                              height: 30.0,
                            ),
                            Text(
                              score.toString() + '\nScore            ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              coins.toString() + '\nCoins             ',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/profile/rank.png',
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            rank.toString(),
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
