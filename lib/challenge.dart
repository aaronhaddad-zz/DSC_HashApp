import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashcode/challenge_list.dart';
import 'package:hashcode/local_db/db.dart';
import 'package:hashcode/widgets/confirmation_dialog.dart';
import 'package:hashcode/widgets/congrats.dart';
import 'package:hashcode/widgets/drawer.dart';
import 'package:hashcode/widgets/hint.dart';
import 'package:hashcode/widgets/information_dialog.dart';
import 'package:hashcode/widgets/solution.dart';
import 'package:hashcode/widgets/solution_confirm_dialog.dart';

import 'login.dart';

class Challenge extends StatefulWidget {
  final String name,
      statement,
      input,
      output,
      exampleInput,
      exampleOutput,
      hint,
      solution;
  final String levelName;
  int level;
  String solvedProblems;
  final int challengeID;
  Challenge(
      this.name,
      this.statement,
      this.input,
      this.output,
      this.exampleInput,
      this.exampleOutput,
      this.hint,
      this.solution,
      this.levelName,
      this.level,
      this.solvedProblems,
      this.challengeID);

  @override
  _ChallengeState createState() => _ChallengeState();
}

List<String> result = ["0", "0", "0", "0", "0", "0", "0"];

void _delete() async {
  final rowsDeleted = await Initdb.instance.delete(0);
}

//this function is to check whether the problem has been solved or not
String check(String uid, int id) {
  var acc =[65 , 99 ,99];
  String result ="",inter ="";
  int x;
  for (int i = 0; i < 7; i++) {
    inter+= uid[4 * i];
  }

  int lastDigit = id % 10, tenTh = id ~/ 10;

  for (int i = 0; i < 3; i++) {
    x =(inter.toString().codeUnitAt(i) + acc[i] ) ~/ 2 - lastDigit;
    if(x==92)
      result+="A";
    else
      result+=String.fromCharCode(x);
  }
  result+=inter[3];
  x =(inter.toString().codeUnitAt(4) + tenTh + 48) ~/ 2;
    if(x==92)
      result+="A";
    else
      result+=String.fromCharCode(x);

  x =(inter.toString().codeUnitAt(5) + lastDigit + 48) ~/ 2;
    if(x==92)
      result+="A";
    else
      result+=String.fromCharCode(x);
  result+= inter[6];
  return result;
}

//this function is used whenver we need to add or remove coins from the user
void _updateCoins(int coinsLeft) async {
  // row to update
  Map<String, dynamic> row = {
    Initdb.columnId: 0,
    Initdb.columnCoins: coinsLeft,
  };
  final rowsAffected = await Initdb.instance.update(row);
  print('updated $rowsAffected row(s)');
}

void _numberOfSolved(int solved) async {
  // row to update
  Map<String, dynamic> row = {
    Initdb.columnId: 0,
    Initdb.columnNumberOfSolved: solved,
  };
  final rowsAffected = await Initdb.instance.update(row);
  print('updated $rowsAffected row(s)');
}

void _solvedProblem(int problem) async {
  // row to update
  Map<String, dynamic> row = {
    Initdb.columnId: 0,
    Initdb.columnNumberOfSolved: problem,
  };
  final rowsAffected = await Initdb.instance.update(row);
  print('updated $rowsAffected row(s)');
}

void _problemsSolved(String problem) async {
  // row to update
  Map<String, dynamic> row = {
    Initdb.columnId: 0,
    Initdb.columnSolvedProblem: problem,
  };
  final rowsAffected = await Initdb.instance.update(row);
  print('updated $rowsAffected row(s)');
}

class _ChallengeState extends State<Challenge> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeList(
                widget.level, widget.levelName, widget.solvedProblems),
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerMenu(),
        backgroundColor: Color(0xffe9eaeb),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChallengeList(
                      widget.level, widget.levelName, widget.solvedProblems),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          backgroundColor: Color(0xff3e52e7),
          centerTitle: true,
          title: Text(
            widget.name.toString(),
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 25.0,
            ),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: 20.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                ),
              ),
            ),
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
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.only(
              top: 40.0,
              left: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problem statement',
                  style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    widget.statement,
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      color: Color(0xff333333),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    'Input',
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    widget.input,
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      color: Color(0xff333333),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    'Output',
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    widget.output,
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      color: Color(0xff333333),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    'Example',
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    right: 10.0,
                  ),
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.black,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              left: 10.0,
                            ),
                            child: Text(
                              'Input',
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 10.0,
                                ),
                                child: Text(
                                  widget.exampleInput,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              left: 10.0,
                            ),
                            child: Text(
                              'Output',
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 10.0,
                                ),
                                child: Text(
                                  widget.exampleOutput,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(
                        child: Text(
                          'Check',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Product Sans',
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          TextEditingController code =
                              new TextEditingController();
                          confirmSolution(context, () async {
                            if (code.text.isNotEmpty) {
                              String already =
                                  await Initdb.instance.solvedProblems();
                              var temp = ["", "", "", "", "", "", ""];
                              String alreadyTemp = already.toString();
                              for (int i = 0; i < 7; i++) {
                                temp[i] = alreadyTemp[i];
                              }
                              check(FirebaseAuth.instance.currentUser.uid,
                                  widget.challengeID);
                              if (result.toString() == code.text.toString()) {
                                //_solvedProblem(widget.solvedProblems + 1);
                                _updateCoins(
                                    await Initdb.instance.coins() + 50);
                                _numberOfSolved(
                                    await Initdb.instance.numberOfSolved() + 1);
                                switch (widget.challengeID) {
                                  case 0:
                                    _problemsSolved("1000000");
                                    break;
                                  case 1:
                                    temp[1] = "1";
                                    String toPush;
                                    for (int i = 0; i < 7; i++) {
                                      toPush = toPush + temp[i];
                                    }
                                    _problemsSolved(toPush);
                                    break;
                                  case 2:
                                    temp[2] = "1";
                                    String toPush;
                                    for (int i = 0; i < 7; i++) {
                                      toPush = toPush + temp[i];
                                    }
                                    _problemsSolved(toPush);
                                    break;
                                  case 3:
                                    temp[3] = "1";
                                    String toPush;
                                    for (int i = 0; i < 7; i++) {
                                      toPush = toPush + temp[i];
                                    }
                                    _problemsSolved(toPush);
                                    break;
                                  case 4:
                                    temp[4] = "1";
                                    String toPush;
                                    for (int i = 0; i < 7; i++) {
                                      toPush = toPush + temp[i];
                                    }
                                    _problemsSolved(toPush);
                                    break;
                                  case 5:
                                    temp[5] = "1";
                                    String toPush;
                                    for (int i = 0; i < 7; i++) {
                                      toPush = toPush + temp[i];
                                    }
                                    _problemsSolved(toPush);
                                    break;
                                  case 6:
                                    temp[6] = "1";
                                    String toPush;
                                    for (int i = 0; i < 7; i++) {
                                      toPush = toPush + temp[i];
                                    }
                                    _problemsSolved(toPush);
                                    break;
                                  default:
                                }
                                Navigator.pop(context);
                                congrats(context);
                              } else {
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'You unfortunately did not solve the problem. Please try again',
                                      style: TextStyle(
                                        fontFamily: 'Product Sans',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              Navigator.pop(context);
                              informationDialog(context,
                                  "Please make sure to enter the code");
                            }
                          }, code);
                        },
                        color: Color(0xff0fb5ff),
                      ),
                      FlatButton(
                        child: Text(
                          'Hint',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Product Sans',
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          Initdb.instance.coins().then((coins) {
                            if (coins < 50) {
                              informationDialog(context,
                                  "The amount of coins you have is not enough to have a hint.\nA hint costs 50 coins!");
                            } else {
                              confirmationDialog(
                                context,
                                () async {
                                  Navigator.pop(context);
                                  _updateCoins(coins - 50);
                                  hint(context);
                                },
                                'A hint will cost you 50 coins and you don\'t get any in the actual competition.',
                              );
                            }
                          });
                        },
                        color: Color(0xff0fb5ff),
                      ),
                      FlatButton(
                        child: Text(
                          'Solution',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Product Sans',
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          confirmationDialog(
                            context,
                            () async {
                              await Initdb.instance.coins().then((value) {
                                if (value >= 100) {
                                  _updateCoins(value - 100);
                                  Navigator.pop(context);
                                  solution(context, widget.solution);
                                  Timer(Duration(seconds: 5), () {
                                    confirmationDialog(context, () {
                                      Clipboard.setData(
                                          ClipboardData(text: widget.solution));
                                      Navigator.pop(context);
                                      _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            'The code has been copied to your clipboard',
                                            style: TextStyle(
                                              fontFamily: 'Product Sans',
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }, "Do you want to copy the code?");
                                  });
                                } else {
                                  Navigator.pop(context);
                                  informationDialog(
                                    context,
                                    'You unfortunately do not have enough coins to get the solution.\nKeep on trying, you can do it!',
                                  );
                                }
                              });
                            },
                            'The soltuion will cost you 100 coins. Keep in mind that you don\'t get the solution in the competition',
                          );
                        },
                        color: Color(0xff0fb5ff),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
