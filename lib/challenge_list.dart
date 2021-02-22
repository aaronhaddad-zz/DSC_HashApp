import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hashcode/appin.dart';
import 'package:hashcode/challenge.dart';
import 'package:hashcode/local_db/db.dart';
import 'package:hashcode/widgets/challenge_tile.dart';
import 'package:hashcode/widgets/confirmation_dialog.dart';
import 'package:hashcode/widgets/drawer.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'login.dart';

class ChallengeList extends StatefulWidget {
  final String levelName;
  int level;
  String solvedProblems;
  ChallengeList(this.level, this.levelName, this.solvedProblems);

  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int globalSolved = 0;

  int numOfChallenges = 1;
  var tutorial = [
    {
      "id": 0,
      "name": "Square²",
      "statement":
          "Simple task, you are given a set of numbers and you have to print the square of each of them.",
      "input":
          "The first line contains an integer n, (0 < n < 10^5)\nThe next n line contain a number x, (0 < x < 10^7)",
      "output":
          "Print n lines, where the ith line contains the square of the ith number",
      "exampleInput": "3\n\n3\n\n6\n\n7",
      "exampleOutput": "9\n\n36\n\n49",
      "hint":
          "-you must store the number of queries in a separate variable\n-use this variable to iterate over the input file\n-int variable may not fit\n-you can directly print the result after calculating it",
      "solution":
          "#include <bits/stdc++.h>\nusing namespace std;\nint main(){\n\t\tlong long q,x;\n\t\tcin>>q;\n\t\tq--;\n\t\twhile(q--){\n\t\t\t\tcin>>x;\n\t\t\t\tcout<<x*x<<'\n';\n\t\t}\n\t\tcin>>x;\n\t\tcout<<x*x;}",
      "solved": "false"
    }
  ];

  var lvl1 = [
    {
      "id": 1,
      "name": "Chocolate lover",
      "statement":
          "Meriem loves to eat chocolate, so her mom bought her a bag of chocolate.\nnow she wonders how much of a different kind of chocolate she had?\n\nHelp her find the answer.",
      "input":
          "The first line contains an integer n , the number of chocolate in the bag where (1 < n < 10^5)\nThe following line contains a list of chocolate names of length n, the length of the chocolate name is not more than 20 characters.",
      "output": "Print the number of different chocalates Meriem has.",
      "exampleInput": "DarkChocolate MilkChocolate DarkChocolate",
      "exampleOutput": "2",
      "hint":
          "-set / unordered_set should definitely help you\n-you need to store the number of queries in a separate variable\n-use this variable to iterate through the input file\n",
      "solution":
          "#include <bits/stdc++.h>\nusing namespace std;\nunordered_set<string> se;\nstring s;\nint main(){\n\t\tint q;\n\t\tcin>>q;\n\t\twhile(q--){\n\t\t\t\tcin>>s;\n\t\t\t\tse.insert(s);\n\t\t}\n\t\tcout<<se.size();\n}",
      "solved": "false"
    },
    {
      "id": 2,
      "name": "Perfect numbers",
      "statement":
          "A decimal number is called a Good Number if it contains at least one \"1\" followed by zeros.\nFor example, 1 and 1100 are Good Numbers, while 112 and 1001 are not.\n\ngiven you a set of numbers x, Print the minimum number of positive Good Numbers needed so that they sum up to each x",
      "input":
          "The first line contains an integer n , the size of the set (1 < n < 10^5)\nThe next n lines contain a number x (0 < x < 2^64-1)",
      "output":
          "For each line print the minimum number of positive Good Numbers",
      "exampleInput": "2\n\n55\n\n10",
      "exampleOutput":
          "2\n\n1\n\nExplnation:\n(55)10 = (110111)2 = (110000)2 + (111)2",
      "hint":
          "-Example : (55)10 = (110111)2 = (110000)2 + (111)2\n-focus on the alternation between ones and zeros",
      "solution":
          "#include <bits/stdc++.h>\nusing namespace std;\nconst long long one = 1;\nint fun(long long x){\n\t\tint i = 62,ans=0;\n\t\twhile(!(x&(one<<i))){\n\t\t\t\ti--;\n\t\t\t\tif(i<0)\n\t\t\t\t\t\tbreak;\n\t\t}\n\t\twhile(i>=0){\n\t\t\t\tans++;\n\t\t\t\twhile(x&(one<<i)){\n\t\t\t\t\t\ti--;\n\t\t\t\t\t\tif(i<0)\n\t\t\t\t\t\t\t\tbreak;\n\t\t\t\t}\n\t\t\t\twhile(!(x&(one<<i))){\n\t\t\t\t\t\ti--;\n\t\t\t\t\t\tif(i<0)\n\t\t\t\t\t\t\t\tbreak;\n\t\t\t\t}\n\t\t\t\t}\n\t\t\t\treturn ans;\n\t\t\t\t}int main(){long long x;int q;cin>>q;q--;while(q--){cin>>x;cout<<fun(x)<<'\n';}cin>>x;cout<<fun(x);}",
      "solved": "false"
    },
    {
      "id": 3,
      "name": "Sum of the cubes",
      "statement":
          "You are given a positive integer x. Check whether the number x is representable as the sum of the cubes of two positive integers.\nFor example, if x=35, then the numbers a=2 and b=3 are suitable (2^3+3^3=8+27=35). If x=4, then no pair of numbers a and b is suitable.",
      "input":
          "The first line contains one integer t (1≤t≤100) — the number of test cases.\nThen t test cases follow, Each test case contains one integer x(1≤x≤10^12).",
      "output":
          "For each test case, output on a separate line: \"YES\" if x is representable as the sum of the cubes of two positive integers. \"NO\" otherwise. ",
      "exampleInput": "7\n\n1\n\n2\n\n4\n\n34\n\n35\n\n16\n\n703657519796",
      "exampleOutput": "NO\n\nYES\n\nNO\n\nNO\n\nYES\n\nYES\n\nYES",
      "hint":
          "The number 1 is not representable as the sum of two cubes.\n\nThe number 2 is represented as 1^3+1^3\n\nThe number 4 is not representable as the sum of two cubes.\n\nThe number 34 is not representable as the sum of two cubes.\n\nThe number 35 is represented as 2^3+3^3\n\nThe number 16 is represented as 23+23\n\nThe number 703657519796 is represented as 5779^3+7993^3\n- a^3 + b^3 = x <=> a^3 = x - b^3\n- calculating the cubic root of A could solve the problem",
      "solution":
          "int main()\n{\nlong long nb;\ncin>>nb;\nwhile(nb--){\nlong long x;\ncin>>x;\nbool ka=0;\nfor (ll i = 1; i*i*i < x; ++i)\n{\nll f=cbrt(x-i*i*i); //cube root of x-i*i*i;\nif(f*f*f==x-i*i*i){\nka=1;\nbreak;\n}\n}\nif(ka)cout<<\"YES\"<<'\n';\nelse cout<<\"NO\"<<'\n';\n}\nreturn 0;\n}\n",
      "solved": "false"
    },
    {
      "id": 4,
      "name": "High end chocolate",
      "statement":
          "Aaron is an arrogant man, he only eats high quality chocolate.\nHe walked into the candy store one day with exactly that coin.\nThe store offers n different chocoaltes of different qualities q at different prices p.\nThe quality of the chocolate is indexed by a number, the higher the number, the more quality the chocolate.\ndetermine what is the maximum number of good chocolate he can have\n",
      "input":
          "The first line contains an integer n and c, the number of chocolate that the store offers and coins Aaron had (1 < n < 10^5)\nThe next n lines contain q, p, x. the quality of the chocolate, its price and the number of chocolate available of quality q.",
      "output": "Print the maximum number of good chocolate Aaron can have",
      "exampleInput": "3\t5\n\n1\t1\t2\n\n3\t3\t1\n\n2\t3\t3",
      "exampleOutput": "3",
      "hint":
          "Aaron had 5 coins\nhe will buy a quality 3 chocolate which will cost him 3 coins\nand he will buy the two type-1 chocolates where each one costs him 1 coin.\n- sorting the entry should definitely help.\n- you should try to spend as much money as possible",
      "solution":
          "#include <bits/stdc++.h>\nusing namespace std;\n#define pb push_back\n#define mp make_pair\nvector<pair<int,pair<int,int>>> v;\nint q;\nlong long c,x,y,z,ans;\nint main(){\ncin>>q>>c;\nwhile(q--){\ncin>>x>>y>>z;\nv.pb(mp(x,mp(y,z)));\n}\nsort(v.begin(),v.end());\nans = 0;\nfor(int i=v.size()-1;i>=0;i--)\nif( c/v[i].second.first < v[i].second.second ){\nans+=c/v[i].second.first;\nc = c%v[i].second.first;\n}else{\nans += v[i].second.second;\nc -= v[i].second.second*v[i].second.first;\n}\ncout<<ans;\n}\n",
      "solved": "false"
    }
  ];
  var lvl2 = [
    {
      "id": 5,
      "name": "Deci-Binary numbers",
      "statement":
          "A decimal number is called deci-binary if each of its digits is either 0 or 1 without any leading zeros.\nFor example, 101 and 1100 are deci-binary, while 112 and 3001 are not.\n\nGiven a string n that represents a positive decimal integer, return the minimum number of positive deci-binary numbers needed so that they sum up to n.",
      "input": "One line contains a number n (1<= n.length() <=10^5)",
      //todo: Don't forget to add the missing output
      "output": "",
      "exampleInput": "32",
      "exampleOutput": "3",
      "hint": "10 + 11 + 11 = 32\n-the answer is in the digits of the number",
      "solution":
          "#include <bits/stdc++.h>\nusing namespace std;\n\nint main(){\nstring s;\nint ans = 0;\ncin>>s;\nfor(int i=0;i<s.size();i++)\nans = max(ans,s[i]-'0');\ncout<<ans;\n}",
      "solved": "false"
    },
    {
      "id": 6,
      "name": "Array game",
      "statement":
          "Aaron calls an array dense if the greater of any two adjacent elements is not more than twice bigger than the smaller.\nMore formally, for any i (1≤i≤n−1), this condition must be satisfied:\nmax(a[i],a[i+1]) ≤ 2*min(a[i],a[i+1])\n\nFor example, the arrays [1,2,3,4,3], [1,1,1] and [5,10] are dense. And the arrays [5,11], [1,4,2], [6,6,1] are not dense.\n\nYou are given an array a of n integers.\nWhat is the minimum number of numbers you need to add to an array to make it dense?\nYou can insert numbers anywhere in the array.\nIf the array is already dense, no numbers need to be added.\nFor example, if a=[4,2,10,1], then the answer is 5, and the array itself after inserting elements into it may look like this:\na=[4,2,3,5,10,6,4,2,1] (there are other ways to build such a).",
      "input":
          "The first line contains one integer t (1≤t≤1000).\nThen t test cases follow.\nThe first line of each test case contains one integer n (2≤n≤50) — the length of the array a.\nThe next line contains n integers a1,a2,…,an (1≤ai≤50).",
      "output":
          "For each test case, output one integer, the minimum number of numbers that must be added to the array to make it dense",
      "exampleInput": "! An example has been provided in the statement !",
      "exampleOutput": "! An example has been provided in the statement !",
      "hint":
          "-the safest way to insert a number between two numbers, a and b (a> b) where a> 2 * b, is to insert 2 * b or a / 2\n-for example, the fastest way to fix this table [1 10] is to follow the method given above => [1 2 4 8 10]",
      "solution":
          "#include <bits/stdc++.h>\nusing namespace std;\nint q,n;\nint main(){\ncin>>q;\nwhile(q--){\ncin>>n;\nint curr,prev,ans = 0;\ncin>>prev;\nfor(int i=1;i<n;i++){\ncin>>curr;\nif(curr > prev){\nwhile((prev<<1) < curr ){\nans++;\nprev<<=1;\n}\n\nprev = curr;\n}\nelse{\nint iprev = curr;\nwhile((curr<<1) < prev){\nans++;\ncurr<<=1;\n}\nprev = iprev;\n}\n}\ncout<<ans<<'\n';\n}\n}",
      "solved": "false"
    },
  ];
  int coins = 0;

  @override
  void initState() {
    super.initState();
    int solved = int.parse(widget.solvedProblems);
    if (widget.level == 0) {
      Initdb.instance.numberOfSolved().then((value) {
        solved = value;
      });
      setState(() {
        numOfChallenges = tutorial.length;
      });
    } else if (widget.level == 1) {
      Initdb.instance.numberOfSolved().then((value) {
        solved = value - 1;
      });
      setState(() {
        numOfChallenges = lvl1.length;
        tutorial = lvl1;
      });
    } else if (widget.level == 2) {
      Initdb.instance.numberOfSolved().then((value) {
        solved = value - 5;
      });
      numOfChallenges = lvl2.length;
      tutorial = lvl2;
    }
    setState(() {
      globalSolved = solved;
    });
    Initdb.instance.coins().then((value) {
      setState(() {
        coins = value;
      });
      Initdb.instance.solvedProblems().then((solved) {
        switch (solved) {
          case "1000000":
            tutorial[0]["solved"] = "true";
            break;
          case "1100000":
            tutorial[0]["solved"] = lvl1[0]["solved"] = "true";
            break;
          case "1010000":
            tutorial[0]["solved"] = lvl1[1]["solved"] = "true";
            break;
          case "1001000":
            tutorial[0]["solved"] = lvl1[2]["solved"] = "true";
            break;
          case "1000100":
            tutorial[0]["solved"] = lvl1[3]["solved"] = "true";
            break;
          case "1111100":
            tutorial[0]["solved"] = lvl1[0]["solved"] = lvl1[1]["solved"] =
                lvl1[2]["solved"] = lvl1[3]["solved"] = "true";
            break;
          case "1111110":
            tutorial[0]["solved"] = lvl1[0]["solved"] = lvl1[1]["solved"] =
                lvl1[2]["solved"] =
                    lvl1[3]["solved"] = lvl2[0]["solved"] = "true";
            break;
          case "1111101":
            tutorial[0]["solved"] = lvl1[0]["solved"] = lvl1[1]["solved"] =
                lvl1[2]["solved"] =
                    lvl1[3]["solved"] = lvl2[1]["solved"] = "true";
            break;
          case "1111111":
            tutorial[0]["solved"] = lvl1[0]["solved"] = lvl1[1]["solved"] =
                lvl1[2]["solved"] = lvl1[3]["solved"] =
                    lvl2[0]["solved"] = lvl2[1]["solved"] = "true";
            break;
          case "1110000":
            tutorial[0]["solved"] =
                lvl1[0]["solved"] = lvl1[1]["solved"] = "true";
            break;
          case "1101000":
            tutorial[0]["solved"] = lvl1[0]["solved"] =
                lvl1[1]["solved"] = lvl1[2]["solved"] = "true";
            break;
          case "1100100":
            tutorial[0]["solved"] =
                lvl1[0]["solved"] = lvl1[3]["solved"] = "true";
            break;
          case "1011000":
            tutorial[0]["solved"] =
                lvl1[1]["solved"] = lvl1[2]["solved"] = "true";
            break;
          case "1010100":
            tutorial[0]["solved"] =
                lvl1[1]["solved"] = lvl1[3]["solved"] = "true";
            break;
          case "1001100":
            tutorial[0]["solved"] =
                lvl1[2]["solved"] = lvl1[3]["solved"] = "true";
            break;
          default:
        }
      });
    });
  }

  void _delete() async {
    final rowsDeleted = await Initdb.instance.delete(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => AppIn()));
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerMenu(),
        backgroundColor: Color(0xffe9eaeb),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              return Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AppIn()));
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          backgroundColor: Color(0xff3e52e7),
          centerTitle: true,
          title: Text(
            widget.levelName,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/levels/coins.png',
                    width: 25.0,
                  ),
                  Text(
                    ' ' + coins.toString(),
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20.0,
              ),
              child: Container(
                height: 490.0,
                child: ListView.builder(
                  //todo: item count should be length of array
                  itemCount: numOfChallenges,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Challenge(
                                        tutorial[index]["name"],
                                        tutorial[index]["statement"],
                                        tutorial[index]["input"],
                                        tutorial[index]["output"],
                                        tutorial[index]["exampleInput"],
                                        tutorial[index]["exampleOutput"],
                                        tutorial[index]["hint"],
                                        tutorial[index]["solution"],
                                        widget.levelName,
                                        widget.level,
                                        widget.solvedProblems,
                                        tutorial[index]["id"],
                                      )));
                        },
                        child: challengeTile(
                          context,
                          tutorial[index]["name"],
                          tutorial[index]["solved"],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40.0,
              height: 50.0,
              child: LiquidLinearProgressIndicator(
                value: globalSolved / 10,
                /*widget.solvedProblems / 10*/ //todo work on the value
                valueColor: AlwaysStoppedAnimation(Color(0xff4464c8)),
                backgroundColor: Color(0xffd2d3d4),
                borderRadius: 12.0,
                direction: Axis.horizontal,
              ),
            ),
          ],
        ),
        extendBody: true,
      ),
    );
  }
}
