import 'package:flutter/material.dart';
import 'package:hashcode/about.dart';
import 'package:hashcode/appin.dart';
import 'package:hashcode/profile.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Container(
        color: Color(0xffffffff),
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                child: Center(
                  child: Text(
                    '# HashApp\nMade in 🇹🇳\nby Google DSC ISI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Product Sans',
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(
                      'assets/images/dsc_logo.png',
                    ),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.dstIn),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                return Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppIn(),
                  ),
                );
              },
              title: Text(
                'Levels',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Product Sans',
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.stacked_line_chart_sharp,
                color: Colors.black,
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            ListTile(
              onTap: () {
                return Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              title: Text(
                'Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Product Sans',
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
            ListTile(
              onTap: () {
                return Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => About(),
                  ),
                );
              },
              title: Text(
                'About',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Product Sans',
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.tag,
                color: Colors.black,
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
