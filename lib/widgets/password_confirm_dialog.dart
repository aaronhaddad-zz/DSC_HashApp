import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void passwordDialog(
    BuildContext context, TextEditingController controller, todo()) {
  showDialog(
    context: context,
    child: AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Please confirm your password',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Product Sans',
              fontSize: 16.0,
            ),
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
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
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: 'Product Sans',
              ),
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontFamily: 'Product Sans',
            ),
            textInputAction: TextInputAction.go,
            obscureText: true,
          ),
        ],
      ),
      actions: [
        FlatButton(
          color: Colors.red,
          child: Text(
            'Yes delete my account',
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 16.0,
            ),
          ),
          onPressed: todo(),
        ),
        FlatButton(
          color: Colors.blue,
          child: Text(
            'No, I still want it',
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 16.0,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
