import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bt_bluetooth/flutter_bt_bluetooth.dart';

import 'carControl.dart';

final key = GlobalKey<_TextState>();

void main() {
//  SystemChrome.setPreferredOrientations(
//          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
//      .then((_) {
//    runApp(new ExampleApp());
//  });
  runApp(new ExampleApp());
}

class ExampleApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExampleAppState();
}

class ExampleAppState extends State<ExampleApp> {
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
      title: 'Control Pad Example',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 300,
              child: BlueView(
                onBlueViewCreated: (BlueViewController controller) =>
                    setState(() => _controller = controller),
              ),
            ),
//            _controller == null
//                ? Container()
//                : DeviceList(controller: _controller),
          ],
        ),
        Positioned(
          left: 40,
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
            left: 10,
            top: 10,
            child: Container(width: 200, child: new TextMsg(key: key))),
        Positioned(
          left: 50,
          top: 50,
          child: MaterialButton(
            color: Colors.redAccent,
            textColor: Colors.white,
            child: new Text('选择设备'),
            onPressed: () {
              // ...
              //点击后
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(title: Text('选择设备'), children: <Widget>[
                    _controller == null
                        ? Container(color: Colors.red)
                        : Container(child: DeviceList(controller: _controller))
                  ]);
                },
              ).then((val) {
                print(val);
              });
            },
          ),
        ),
      ]),
    );
  }

  void datePrint(
    double degrees,
    double distance,
  ) {
    //发送数据
    String json = "";
    carControl carcontrol = new carControl(0,(distance*100).toInt(), degrees.toInt(), 0, 0, 0);
    json = carcontrol.JsontoString();
    _controller.sendMsg(json);//


    key.currentState.updateMessage(distance, degrees);
    print(json);
    print("角度：" + degrees.toString() + "距离：" + distance.toString());
    SystemChrome.restoreSystemUIOverlays();
  }
}

class TextMsg extends StatefulWidget {
  TextMsg({Key key}) : super(key: key);

  @override
  _TextState createState() => new _TextState();
}

class _TextState extends State<TextMsg> {
  double distance = 0.0;
  double degrees = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text.rich(TextSpan(children: [
        TextSpan(text: "角度: "),
        TextSpan(
          text: this.degrees.toStringAsPrecision(6) + "   ",
          style: TextStyle(color: Colors.deepOrange),
        ),
        TextSpan(text: "距离: "),
        TextSpan(
          text: this.distance.toStringAsPrecision(4),
          style: TextStyle(color: Colors.deepOrange),
        ),
      ])),
    );
  }

  void updateMessage(double distance, double degrees) {
    setState(() {
      this.distance = distance;
      this.degrees = degrees;
    });
  }
}

class DeviceList extends StatefulWidget {
  const DeviceList({@required this.controller}) : assert(controller != null);
  final BlueViewController controller;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  bool isConnect = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<dynamic, dynamic>>(
      stream: Stream.periodic(Duration(seconds: 2))
          .asyncMap((_) => widget.controller.bondedDevices),
      initialData: HashMap(),
      builder: (c, snapshot) {
        List<Widget> list = List();
        if (snapshot.data != null) {
          snapshot.data.forEach((key, value) {
            list.add(Row(
              children: <Widget>[
                Text("$value"),
                FlatButton(
                  child: Text("连接"),
                  onPressed: () async =>
                      await widget.controller.connectBondedDevice(key),
                ),
//                FlatButton(
//                  child: Text("发送"),
//                  onPressed: () async {
//                    await widget.controller.connectBondedDevice(key);
//                    Navigator.of(context).push(
//                      MaterialPageRoute(
//                        builder: (c) => DeviceDataScreen(
//                          device: key,
//                          controller: widget.controller,
//                        ),
//                      ),
//                    );
//                  },
//                ),
              ],
            ));
          });
        }
        return Column(
          children: list,
        );
      },
    );
  }
}

class DeviceDataScreen extends StatelessWidget {
  const DeviceDataScreen({Key key, this.device, this.controller})
      : super(key: key);

  final String device;
  final BlueViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device),
        actions: <Widget>[
          IconButton(
            icon: Text("连接"),
            onPressed: () => controller.connectBondedDevice(device),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: controller == null
            ? Text("Controller NULL")
            : StreamBuilder<BluetoothOutput>(
                stream: controller.outputStream,
                initialData: BluetoothOutput(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data.data == null
                      ? Text("None")
                      : Image.memory(snapshot.data.data);
                },
              ),
      ),
    );
  }
}
