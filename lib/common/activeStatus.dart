import 'package:flutter/material.dart';

class RatingBox extends StatefulWidget {
  @override
  _RatingBoxState createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  var _rating = true;
  void _setActive() {
    setState(() {
      !_rating;
    });
  }

  Widget build(BuildContext context) {
    double _size = 20;
    print(_rating);
    return Container(
      padding: EdgeInsets.all(0),
      child: IconButton(
        icon: (_rating
            ? Icon(
                Icons.local_activity,
                size: _size,
              )
            : Icon(
                Icons.local_activity_outlined,
                size: _size,
              )),
        color: Colors.red[500],
        onPressed: _setActive,
        iconSize: _size,
      ),
    );
  }
}
