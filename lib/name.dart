import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashcode/appin.dart';
import 'package:hashcode/local_db/db.dart';
import 'package:hashcode/widgets/information_dialog.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Name extends StatefulWidget {
  Name({Key key}) : super(key: key);

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController name = new TextEditingController();
  TextEditingController famName = new TextEditingController();

  //all db related stuff
  final dbHelper = Initdb.instance;
  void _insert(int uid, int coins, int lockedLevels, String solvedProblems,
      int numberOfSolved) async {
    // row to insert
    Map<String, dynamic> row = {
      Initdb.columnId: uid,
      Initdb.columnCoins: coins,
      Initdb.columnLockedLevels: lockedLevels,
      Initdb.columnSolvedProblem: solvedProblems,
      Initdb.columnNumberOfSolved: numberOfSolved
    };
    final id = await dbHelper.insert(row);
  }

  void saveName() async {
    if (name.text.isNotEmpty && famName.text.isNotEmpty) {
      String fullName = name.text + ' ' + famName.text;
      try {
        FirebaseAuth.instance.currentUser.updateProfile(
          displayName: fullName,
        );
        await FirebaseAuth.instance.currentUser.reload();
        _insert(0, 100, 4, "0000000", 0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AppIn()));
      } catch (e) {
        informationDialog(
          context,
          'An error has occured while setting your name. Please try again or contact the app developer at contact@aaronhaddad.tech.\n' +
              e.toString(),
        );
      }
    }
  }

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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'HashApp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 50.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
            Text(
              'One last step!',
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: Color(0xff3f54e7),
            ),
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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 40.0,
              height: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: name,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'First name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Product Sans',
                        fontSize: 16.0,
                      ),
                      suffixIcon: Icon(
                        Icons.text_fields,
                        color: Colors.white,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans',
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextFormField(
                    controller: famName,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Last name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Product Sans',
                        fontSize: 16.0,
                      ),
                      suffixIcon: Icon(
                        Icons.text_fields,
                        color: Colors.white,
                      ),
                    ),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      saveName();
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans',
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      width: 200.0,
                      height: 50.0,
                      child: MaterialButton(
                        child: Text(
                          'GO!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Product Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          saveName();
                        },
                        color: Color(0xff3e52e7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
