import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hashcode/challenge_list.dart';
import 'package:hashcode/local_db/db.dart';
import 'package:hashcode/login.dart';
import 'package:hashcode/widgets/confirmation_dialog.dart';
import 'package:hashcode/widgets/drawer.dart';
import 'package:hashcode/widgets/information_dialog.dart';
import 'package:hashcode/widgets/network_error.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppIn extends StatefulWidget {
  AppIn({Key key}) : super(key: key);

  @override
  _AppInState createState() => _AppInState();
}

class _AppInState extends State<AppIn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _levelsController = new PageController();

  String name;
  int coins = 0, lockedLevels = 5;
  int solvedProblems = 0;
  bool level1 = false;
  bool level2 = false;
  bool level3 = false;
  bool level4 = false;
  bool isLoading = true;
  bool isOwnerTemp = false;
  bool isOwner = false;

  //This function is used to delete the local db upon logout
  void _delete() async {
    final rowsDeleted = await Initdb.instance.delete(0);
  }

  @override
  void initState() {
    super.initState();
    DataConnectionChecker().hasConnection.then((connection) {
      if (connection) {
        FirebaseAuth.instance.currentUser.reload().then((value) {
          Initdb.instance.coins().then((value) {
            setState(() {
              coins = value;
            });
            Initdb.instance.lockedLevels().then((lvls) {
              lockedLevels = lvls;
              setState(() {
                print("lockedLevels $lockedLevels");
                print("lvls $lvls");
                if (lvls == 1) {
                  setState(() {
                    level4 = true;
                  });
                } else if (lvls == 2) {
                  print("hehe");
                  setState(() {
                    level4 = level3 = true;
                  });
                } else if (lvls == 3) {
                  print("m here");
                  setState(() {
                    level4 = level3 = level2 = true;
                    level1 = false;
                  });
                } else if (lvls == 4) {
                  print("here");
                  setState(() {
                    level4 = level3 = level2 = level1 = true;
                  });
                }
              });
              Initdb.instance.numberOfSolved().then((prblms) {
                setState(() {
                  solvedProblems = prblms;
                  isLoading = false;
                });
              });
            });
          });
        });
      } else {
        networkError(context, () {
          FlutterRestart.restartApp();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () {
            confirmationDialog(context, () {
              exit(0);
            }, 'Are you sure you want to exit HashApp?');
            return Future.value(false);
          },
          child: Scaffold(
            key: _scaffoldKey,
            drawer: DrawerMenu(),
            backgroundColor: Color(0xffe9eaeb),
            appBar: AppBar(
              backgroundColor: Color(0xff3e52e7),
              centerTitle: true,
              title: Text(
                'Levels',
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
                      confirmationDialog(context, () async {
                        await FirebaseAuth.instance.signOut();
                        _delete();
                        return Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      }, 'Signing out will result in complete data loss, including progress and solved problems!');
                    },
                    child: Icon(
                      Icons.logout,
                    ),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hi, ' +
                              FirebaseAuth.instance.currentUser.displayName,
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 18.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/levels/coins.png',
                                width: 25.0,
                              ),
                              Text(
                                coins.toString(),
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                PageView(
                  controller: _levelsController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    //todo: Make it send the level's name
                                    ChallengeList(0, 'Tutorial',
                                        solvedProblems.toString())));
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 5.0,
                              height: MediaQuery.of(context).size.width - 70.0,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          70.0,
                                      height:
                                          MediaQuery.of(context).size.width -
                                              70.0,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          image: ExactAssetImage(
                                            'assets/images/levels/square.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: Container(
                                        width: 300.0,
                                        height: 70.0,
                                        color: Colors.white,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffeeeeee),
                                                        size: 15.0,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffeeeeee),
                                                        size: 15.0,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffeeeeee),
                                                        size: 15.0,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffeeeeee),
                                                        size: 15.0,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffeeeeee),
                                                        size: 15.0,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Tutorial',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Product Sans',
                                                      fontSize: 20.0,
                                                      color: Color(0xff848484),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18.0),
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child:
                                                    LiquidCircularProgressIndicator(
                                                  backgroundColor:
                                                      Color(0xfff5f5f5),
                                                  center: Text(
                                                    '0 / 1',
                                                    style: TextStyle(
                                                      fontSize: 11.0,
                                                    ),
                                                  ),
                                                  value:
                                                      solvedProblems / 10 / 2,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!level1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChallengeList(
                                          1,
                                          'Data Structures',
                                          solvedProblems.toString())));
                            } else {
                              informationDialog(
                                context,
                                'Make sure to solve all previous levels to get access to this one',
                              );
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 5.0,
                                  height:
                                      MediaQuery.of(context).size.width - 70.0,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: ExactAssetImage(
                                                'assets/images/levels/square.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                          ),
                                          child: Container(
                                            width: 300.0,
                                            height: 70.0,
                                            color: Colors.white,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Data Structures',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Product Sans',
                                                          fontSize: 20.0,
                                                          color:
                                                              Color(0xff848484),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        LiquidCircularProgressIndicator(
                                                      backgroundColor:
                                                          Color(0xfff5f5f5),
                                                      center: Text(
                                                        '0 / 4',
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                      value:
                                                          (solvedProblems - 2) /
                                                              10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: level1,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                              size: 150.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!level2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChallengeList(
                                          2,
                                          'Greedy',
                                          solvedProblems.toString())));
                            } else {
                              informationDialog(
                                context,
                                'Make sure to solve all previous levels to get access to this one',
                              );
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 5.0,
                                  height:
                                      MediaQuery.of(context).size.width - 70.0,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: ExactAssetImage(
                                                'assets/images/levels/square.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                          ),
                                          child: Container(
                                            width: 300.0,
                                            height: 70.0,
                                            color: Colors.white,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Greedy',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Product Sans',
                                                          fontSize: 20.0,
                                                          color:
                                                              Color(0xff848484),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        LiquidCircularProgressIndicator(
                                                      backgroundColor:
                                                          Color(0xfff5f5f5),
                                                      center: Text(
                                                        '0 / 2',
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                      value:
                                                          solvedProblems / 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: level2,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                              size: 150.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            /*if (level3 = true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChallengeList(
                                              3, 'Graph', solvedProblems)));
                                } else {
                                  informationDialog(
                                    context,
                                    'Make sure to solve all previous levels to get access to this one',
                                  );
                                }*/
                            informationDialog(context,
                                'This level will arrive in a near, future update.\nStay tuned!');
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 5.0,
                                  height:
                                      MediaQuery.of(context).size.width - 70.0,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: ExactAssetImage(
                                                'assets/images/levels/square.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                          ),
                                          child: Container(
                                            width: 300.0,
                                            height: 70.0,
                                            color: Colors.white,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Graph',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Product Sans',
                                                          fontSize: 20.0,
                                                          color:
                                                              Color(0xff848484),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        LiquidCircularProgressIndicator(
                                                      backgroundColor:
                                                          Color(0xfff5f5f5),
                                                      center: Text(
                                                        '0 / 0',
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                      value: 0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: level3,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.update,
                                              color: Colors.white,
                                              size: 150.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            /*if (level4 = true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChallengeList(
                                                4,
                                                'Dynamic programming',
                                                solvedProblems,
                                              )));
                                } else {
                                  informationDialog(
                                    context,
                                    'Make sure to solve all previous levels to get access to this one',
                                  );
                                }*/
                            informationDialog(context,
                                'This level will arrive in a near, future update.\nStay tuned!');
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 5.0,
                                  height:
                                      MediaQuery.of(context).size.width - 70.0,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              70.0,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: ExactAssetImage(
                                                'assets/images/levels/square.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                          ),
                                          child: Container(
                                            width: 300.0,
                                            height: 70.0,
                                            color: Colors.white,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color: Color(
                                                                0xffeeeeee),
                                                            size: 15.0,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Dynamic programming',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Product Sans',
                                                          fontSize: 20.0,
                                                          color:
                                                              Color(0xff848484),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 18.0),
                                                  child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child:
                                                        LiquidCircularProgressIndicator(
                                                      backgroundColor:
                                                          Color(0xfff5f5f5),
                                                      center: Text(
                                                        '0 / 0',
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                      value: 0.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !level4,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.8),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.update,
                                              color: Colors.white,
                                              size: 150.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            extendBody: true,
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  child: GestureDetector(
                    onDoubleTap: () async {
                      isOwnerTemp = true;
                      await Future.delayed(Duration(seconds: 4));
                      isOwnerTemp = false;
                    },
                  ),
                ),
                Container(
                  height: 50.0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _levelsController,
                      count: 5,
                      onDotClicked: (index) {
                        _levelsController.animateToPage(index,
                            duration: Duration(milliseconds: 900),
                            curve: Curves.fastOutSlowIn);
                      },
                    ),
                  ),
                ),
                Container(
                  width: 50.0,
                  height: 50.0,
                  child: GestureDetector(
                    onDoubleTap: () {
                      if (isOwnerTemp) {
                        setState(() {
                          level1 = level2 = level3 = level4 = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.7),
            child: SpinKitCircle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
