import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void confirmSolution(BuildContext context, todo(), TextEditingController code) {
  showDialog(
    context: context,
    child: AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Check solution',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Product Sans',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: TextFormField(
              controller: code,
              textInputAction: TextInputAction.go,
              onEditingComplete: todo,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Product Sans',
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                hintText: 'Verification key',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'Product Sans',
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        FlatButton(
          color: Colors.black,
          onPressed: todo,
          child: Text(
            'Check it!',
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ),
  );
}
