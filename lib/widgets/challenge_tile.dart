import 'package:flutter/material.dart';

challengeTile(context, String challengeName, String done) {
  return Container(
    width: MediaQuery.of(context).size.width - 50.0,
    height: 60.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
      color: Colors.white,
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            challengeName,
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            'assets/images/lvl_list/' + done + '.png',
          ),
        ],
      ),
    ),
  );
}
