import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:id_card_reader/common.dart';
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // Intl.defaultLocale = 'th';
    // initializeDateFormatting();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await IdCardReader.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // _fn1() async {
  //   print('Hello111');
  //   List<UsbDevice> aa;
  //   try {
  //     aa = await IdCardReader.getDeviceList();
  //     print('aax $aa');
  //     setState(() {
  //       _deviceList = aa;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _deviceList = 'ERR fn1 $e';
  //     });
  //   }
  // }

  // _fn2() async {
  //   try {
  //     var aa = await IdCardReader.test1;
  //     setState(() {
  //       _t1 = aa;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _t1 = 'ERR fn2 $e';
  //     });
  //   }
  // }

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

  warm1() async {
    try {
      var aa = await IdCardReader.warm1;
      setState(() {
        _warm1 = aa;
      });
    } catch (e) {
      setState(() {
        _warm1 = 'ERR warm1 $e';
        _data = null;
      });
    }
  }

  protocal1() async {
    try {
      var aa = await IdCardReader.protocol1;
      setState(() {
        _protocal1 = aa;
      });
    } catch (e) {
      setState(() {
        _protocal1 = 'ERR protocal1 $e';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ACS Thai ID Card Reader'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  ElevatedButton(onPressed: open1, child: const Text('open')),
                  ElevatedButton(onPressed: warm1, child: const Text('warm')),
                  ElevatedButton(
                      onPressed: protocal1, child: const Text('protocal')),
                  ElevatedButton(onPressed: readAll, child: const Text('read')),
                ],
              ),
              Text(_open1.toString()),
              Text(_warm1.toString()),
              Text(_protocal1.toString()),
              if (_data != null) ...[
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
              StreamBuilder(
                stream: IdCardReader.getStream1,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text("[EventChannel]: ${snapshot.data.toString()}");
                  } else {
                    return const Text("[EventChannel] Waiting....");
                  }
                },
              ),
            ],
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
