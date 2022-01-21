import 'package:flutter/material.dart';
import 'package:id_card_reader/id_card_reader.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:typed_data';

import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = 'th_TH';
  initializeDateFormatting('th_TH', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  var _deviceList;
  var _aa1;
  var _t1;
  var _t2;
  var _open1;
  var _warm1;
  var _protocal1;
  var _data;
  var _error;
  var _device;

  @override
  void initState() {
    super.initState();
    IdCardReader.getReaderStream.listen(_onData);
    IdCardReader.getUSBStream.listen(_onUSB);
  }

  void _onUSB(event) {
    try {
      setState(() {
        _device = event;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _onData(event) {
    try {
      if (event['status'] == 'Present') {
        readAll();
      } else if (event['status'] == 'Absent') {
        _clear();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  open1() async {
    try {
      var aa = await IdCardReader.open1;
      setState(() {
        _open1 = aa;
      });
    } catch (e) {
      setState(() {
        _open1 = 'ERR open1 $e';
        _data = null;
      });
    }
  }

  readAll() async {
    try {
      var aa = await IdCardReader.readAll;
      setState(() {
        _data = aa;
      });
    } catch (e) {
      setState(() {
        _data = 'ERR readAll $e';
      });
    }
  }

  formattedDate(dt) {
    try {
      DateTime dateTime = DateTime.parse(dt);
      String formattedDate = DateFormat.yMMMMd('th_TH').format(dateTime);
      return formattedDate;
    } catch (e) {
      return e.toString();
    }
  }

  _clear() {
    setState(() {
      _data = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Thai ID Card Reader'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // StreamBuilder(
              //   stream: IdCardReader.getUSBStream,
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.hasData) {
              //       return UsbDeviceCard(
              //         device: snapshot.data,
              //       );
              //     } else {
              //       return const EmptyHeader(
              //         text: 'เสียบเครื่องอ่านบัตรก่อน',
              //       );
              //     }
              //   },
              // ),
              if (_device != null)
                UsbDeviceCard(
                  device: _device,
                ),
              if (_device == null || !_device.isAttached)
                const EmptyHeader(
                  text: 'เสียบเครื่องอ่านบัตรก่อน',
                ),
              if (_error != null) Text(_error.toString()),
              if (_data == null && (_device != null && _device.hasPermission))
                const EmptyHeader(
                  icon: Icons.credit_card,
                  text: 'เสียบบัตรประชาชนได้เลย',
                ),
              if (_data != null) ...[
                const Padding(padding: EdgeInsets.all(8.0)),
                Center(
                  child: Image.memory(
                    Uint8List.fromList(_data.image),
                  ),
                ),
                DisplayInfo(
                    title: 'เลขบัตรประชาชน', value: '${_data.nationID}'),
                DisplayInfo(
                    title: 'ชื่อ-นามสกุล (ภาษาไทย)',
                    value:
                        '${_data.titleTH} ${_data.firstnameTH} ${_data.lastnameTH}'),
                DisplayInfo(
                    title: 'ชื่อ-นามสกุล (ภาษาอังกฤษ)',
                    value:
                        '${_data.titleEN} ${_data.firstnameEN} ${_data.lastnameEN}'),
                DisplayInfo(
                    title: 'เพศ',
                    value:
                        '(${_data.gender}) ${_data.gender == 1 ? 'ชาย' : 'หญิง'}'),
                DisplayInfo(
                    title: 'วันเดือนปีเกิด',
                    value:
                        '${_data.birthdate.toString()}\n${formattedDate(_data.birthdate)}'),
                DisplayInfo(title: 'ที่อยู่', value: _data.address),
                DisplayInfo(
                    title: 'วันออกบัตร',
                    value:
                        '${_data.issueDate.toString()}\n${formattedDate(_data.issueDate)}'),
                DisplayInfo(
                    title: 'วันหมดอายุ',
                    value:
                        '${_data.expireDate.toString()}\n${formattedDate(_data.expireDate)}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyHeader extends StatelessWidget {
  final IconData? icon;
  final String? text;
  const EmptyHeader({
    this.icon,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon ?? Icons.usb,
                  size: 60,
                ),
                Center(
                    child: Text(
                  text ?? 'Empty',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            )));
  }
}

class UsbDeviceCard extends StatelessWidget {
  final dynamic device;
  const UsbDeviceCard({
    Key? key,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: device.isAttached ? 1.0 : 0.5,
      child: Card(
        child: ListTile(
          leading: const Icon(
            Icons.usb,
            size: 32,
          ),
          title: Text('${device.manufacturerName} ${device.productName}'),
          subtitle: Text(device.identifier),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            color: device.hasPermission ? Colors.green : Colors.grey,
            child: Text(
                device.hasPermission
                    ? 'Listening'
                    : (device.isAttached ? 'Connected' : 'Disconnected'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }
}

class DisplayInfo extends StatelessWidget {
  const DisplayInfo({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    TextStyle sTitle =
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    TextStyle sVal = const TextStyle(fontSize: 28);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$title : ',
                style: sTitle,
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: sVal,
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
