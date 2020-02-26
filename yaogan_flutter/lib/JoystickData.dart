
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoystickData extends StatefulWidget {
  JoystickData({Key key}) : super(key: key);
  final KEY = GlobalKey<_JoystickDataState>();
  @override
  _JoystickDataState createState() => new _JoystickDataState();


}

class _JoystickDataState extends State<JoystickData> {
  int distance = 0;
  int degrees = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text.rich(TextSpan(style: TextStyle(fontSize: 10), children: [
        TextSpan(text: "deg: "),
        TextSpan(
          text: this.degrees.toString() + "   ",
          style: TextStyle(color: Colors.deepOrange),
        ),
        TextSpan(text: "dis: "),
        TextSpan(
          text: this.distance.toString(),
          style: TextStyle(color: Colors.deepOrange),
        ),
      ])),
    );
  }

  void updateMessage(int distance, int degrees) {
    setState(() {
      this.distance = distance;
      this.degrees = degrees;
    });
  }
}
