import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:id_card_reader/common.dart';
import 'package:id_card_reader/id_card_reader.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
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

  _fn1() async {
    print('Hello111');
    List<UsbDevice> aa;
    try {
      aa = await IdCardReader.getDeviceList();
      print('aax $aa');
      setState(() {
        _deviceList = aa;
      });
    } catch (e) {
      setState(() {
        _deviceList = 'ERR fn1 $e';
      });
    }
  }

  _fn2() async {
    try {
      var aa = await IdCardReader.test1;
      setState(() {
        _t1 = aa;
      });
    } catch (e) {
      setState(() {
        _t1 = 'ERR fn2 $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
              StreamBuilder<int>(
                stream: IdCardReader.getRandomNumberStream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Text("[EventChannel] Current Random Number: ${snapshot.data}");
                  } else {
                    return const Text("[EventChannel] Waiting for new random number...");
                  }
                },
              ),

              ElevatedButton(onPressed: _fn1, child: const Text('Device list')),
              Text(_deviceList.toString()),
              ElevatedButton(onPressed: _fn2, child: const Text('fn2 test1')),
              Text(_t1.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
