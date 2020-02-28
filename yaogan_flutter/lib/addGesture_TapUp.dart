
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bt_bluetooth/flutter_bt_bluetooth.dart';
import 'carControl.dart';

class addGesture_TapUp {
  BlueViewController _controller;
  Widget _child;
  addGesture_TapUp(this._controller, this._child);

  Widget addTapUp() {
    return new GestureDetector(
      onTapUp: (TapUpDetails details) {
        print("================================================");
        String json = "";
        carControl carcontrol = new carControl(0, 0, 0, 0, 0, 0);
        json = carcontrol.JsontoString();
        _controller.sendMsg(json); //
      },
      child: _child,
    );
  }
}
