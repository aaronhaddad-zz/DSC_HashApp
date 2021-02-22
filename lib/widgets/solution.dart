import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

solution(BuildContext context, String solution) {
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text(
        'SOLUTION',
        style: TextStyle(
          fontFamily: 'Product Sans',
        ),
      ),
      content: Container(
        color: Color(0xfff6f6f6),
        child: Padding(
          padding: EdgeInsets.all(
            8.0,
          ),
          child: Text(
            solution,
            style: TextStyle(
              fontFamily: 'Input',
              fontSize: 12.0,
            ),
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
