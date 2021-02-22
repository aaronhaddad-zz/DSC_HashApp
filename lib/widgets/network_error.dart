import 'dart:io';

import 'package:flutter/material.dart';

void networkError(BuildContext context, todo()) {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/caution.png',
            height: 30.0,
          ),
          Text(
            'Network Error',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Product Sans',
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Please make sure you have an internet connection.',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Product Sans',
              ),
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            exit(0);
          },
          child: Text(
            'Exit',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Product Sans',
            ),
          ),
        ),
        FlatButton(
          onPressed: todo,
          child: Text(
            'Try again',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Product Sans',
            ),
          ),
        ),
      ],
    ),
  );
}
