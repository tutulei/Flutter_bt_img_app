import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bt_bluetooth/flutter_bt_bluetooth.dart';

import 'main.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({@required this.isConnected, this.controller})
      : assert(controller != null);
  final BlueViewController controller;
  final bool isConnected;
  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<dynamic, dynamic>>(
      stream: Stream.periodic(Duration(seconds: 2))
          .asyncMap((_) => widget.controller.bondedDevices),
      initialData: HashMap(),
      builder: (c, snapshot) {
        List<Widget> l = List();
        List l2 = List();
        if (snapshot.data != null) {
          snapshot.data.forEach((key, value) {
            l.add(
//                Row(
//                  children: <Widget>[
              Text("$value",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0)),
//                FlatButton(
//                  child: Text("连接"),
//                  onPressed: () async =>
//                      await widget.controller.connectBondedDevice(key),
//                ),
//              ],
//            )
            );
            l2.add(key);
          });
        }
        list = l;
        keylist = l2;
        return widget.isConnected
            ? Container(
                child:
                    Text("设备已连接", style: TextStyle(color: Colors.green[300])))
            : BT_bottom(widget, context);
      },
    );
  }
  Widget BT_bottom(widget, context) {
    return Container(

      child: MaterialButton(
        color: Colors.redAccent,
        textColor: Colors.white,
        child: new Text('选择设备'),
        onPressed: () {
          // ...
          //点击后
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ListView.builder(
                  padding: const EdgeInsets.all(14.0),
                  itemCount: 1 + list.lastIndexOf(list.last),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Column(children: <Widget>[
                        Text("请选择设备",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.deepOrange))
                      ]);
                    }
                    return new InkWell(
                      onTap: ()
                      //处理点击事件
                      async =>
                      await widget.controller
                          .connectBondedDevice(keylist[index]),
                      child:
                      Column(children: <Widget>[new Divider(), list[index]]),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
