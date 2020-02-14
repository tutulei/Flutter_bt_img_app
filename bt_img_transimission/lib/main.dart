import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bt_bluetooth/flutter_bt_bluetooth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BlueViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
//            color:  Colors.red,
            child: BlueView(
              onBlueViewCreated: (BlueViewController c) =>
                  setState(() => controller = c),
            ),
          ),
          MaterialButton(
            color: Colors.redAccent,
            textColor: Colors.white,
            child: new Text('选择设备'),
            onPressed: () {
              //点击后
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return controller == null ? Container(color:Colors.red) : DeviceList(controller: controller);
                },
              ).then((val) {
                print(val);
              }
              );
            },
          ),
//          controller == null ? Container(color:Colors.red) : DeviceList(controller: controller),
        ],
      ),
    );
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
                FlatButton(
                  child: Text("发送"),
                  onPressed: () async {
                    await widget.controller.connectBondedDevice(key);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => DeviceDataScreen(
                          device: key,
                          controller: widget.controller,
                        ),
                      ),
                    );
                  },
                ),
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
