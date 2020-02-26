import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bt_bluetooth/flutter_bt_bluetooth.dart';

import 'carControl.dart';
import 'DeviceList.dart';
import 'JoystickData.dart';

JoystickData j = new JoystickData();
final key = j.KEY;

List<Widget> list;
List keylist;
void main() {
  runApp(new ExampleApp());
}

class ExampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CarJoystickState();
}

class CarJoystickState extends State<ExampleApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
//      DeviceOrientation.portraitUp
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Control',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  BlueViewController _controller;
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              width: 500,
              color: Colors.black12,
              child: BlueView(
                onBlueViewCreated: (c) => setState(() {
                  if (c != null) {
                    _controller = c;
                    _controller.stateStream.listen((event) =>
                        setState(() => isConnected = event == STATE_CONNECTED));
                  }
                }),
              ),
            ),
            _controller == null
                ? Container(color: Colors.red)
                : Container(
                    child: DeviceList(
                        isConnected: isConnected, controller: _controller))
          ],
        ),
        Positioned(
          left: 30,
          bottom: 0,
          child: Container(
            width: 220,
            height: 220,
//                color: Colors.yellow,
            child: JoystickView(
                size: 170,
                iconsColor: Colors.blue,
                backgroundColor: Colors.grey,
                opacity: 0.5,
                innerCircleColor: Colors.white30,
                onDirectionChanged: datePrint),
          ),
        ),
        Positioned(
          left: 530,
          bottom: 50,
          child: Row(children: <Widget>[
            IconButton(
              iconSize: 80,
              color: Colors.grey,
              icon: new Icon(Icons.undo),
              onPressed: () {
                String json = "";
                carControl carcontrol = new carControl(0, 60, 0, 0, 3000, 0);
                json = carcontrol.JsontoString();
                _controller.sendMsg(json); //
              },
            ),
            IconButton(
              iconSize: 80,
              color: Colors.grey,
              icon: new Icon(Icons.redo),
              onPressed: () {
                String json = "";
                carControl carcontrol = new carControl(0, 60, 0, 1, 3000, 0);
                json = carcontrol.JsontoString();
                _controller.sendMsg(json); //
              },
            ),
          ]),
        ),
        Positioned(
            left: 5,
            top: 1,
            child: Container(width: 200, child: new JoystickData(key: key))),
      ]),
    );
  }

  void datePrint(double degrees, double distance) {
    int dis = (distance * 7).toInt() * 10;
    int der = (degrees ~/ 10) * 10;
    //发送数据
    String json = "";
    carControl carcontrol = new carControl(0, dis, der, 0, 0, 0);
    json = carcontrol.JsontoString();
    _controller.sendMsg(json); //

    key.currentState.updateMessage(dis, der);
    print(json);
    print("角度：" + dis.toString() + "距离：" + der.toString());
    SystemChrome.restoreSystemUIOverlays();
  }
}
