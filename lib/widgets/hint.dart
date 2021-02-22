import 'package:flutter/material.dart';

hint(BuildContext context) {
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text(
        'HINT',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xff576ae7),
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Product Sans',
          fontSize: 14.0,
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
