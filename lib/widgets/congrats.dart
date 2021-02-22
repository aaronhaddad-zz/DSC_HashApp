import 'package:flutter/material.dart';

congrats(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    child: AlertDialog(
      title: Image.asset(
        'assets/images/problems/cong.png',
      ),
      content: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        child: Text(
          'Yeyy!\n You have solved this problem. You did a really good job! You get 25 extra coins for this!\nKeep up the hard work',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Product Sans',
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cotinue',
              style: TextStyle(
                color: Color(0xff576ae7),
                fontFamily: 'Product Sans',
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
