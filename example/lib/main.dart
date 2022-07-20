import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';
import 'package:thai_idcard_reader_flutter/common.dart';
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
  ThaiIDCard? _data;
  var _error;
  UsbDevice? _device;
  var _card;
  StreamSubscription? subscription;
  final List _idCardType = [
    ThaiIDType.cid,
    ThaiIDType.photo,
    ThaiIDType.nameTH,
    ThaiIDType.nameEN,
    ThaiIDType.gender,
    ThaiIDType.birthdate,
    ThaiIDType.address,
    ThaiIDType.issueDate,
    ThaiIDType.expireDate,
  ];
  List<String> selectedTypes = [];

  @override
  void initState() {
    super.initState();
    ThaiIdcardReaderFlutter.deviceHandlerStream.listen(_onUSB);
  }

  void _onUSB(usbEvent) {
    try {
      if (usbEvent.hasPermission) {
        subscription =
            ThaiIdcardReaderFlutter.cardHandlerStream.listen(_onData);
      } else {
        if (subscription == null) {
          subscription?.cancel();
          subscription = null;
        }
        _clear();
      }
      setState(() {
        _device = usbEvent;
      });
    } catch (e) {
      setState(() {
        _error = "_onUSB " + e.toString();
      });
    }
  }

  void _onData(readerEvent) {
    try {
      setState(() {
        _card = readerEvent;
      });
      if (readerEvent.isReady) {
        readCard(only: selectedTypes);
      } else {
        _clear();
      }
    } catch (e) {
      setState(() {
        _error = "_onData " + e.toString();
      });
    }
  }

  readCard({List<String> only = const []}) async {
    try {
      var response = await ThaiIdcardReaderFlutter.read(only: only);
      setState(() {
        _data = response;
      });
    } catch (e) {
      setState(() {
        _error = 'ERR readCard $e';
      });
    }
  }

  formattedDate(dt) {
    try {
      DateTime dateTime = DateTime.parse(dt);
      String formattedDate = DateFormat.yMMMMd('th_TH').format(dateTime);
      return formattedDate;
    } catch (e) {
      return dt.split('').toString() + e.toString();
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
              if (_device != null)
                UsbDeviceCard(
                  device: _device,
                ),
              if (_card != null) Text(_card.toString()),
              if (_device == null || !_device!.isAttached) ...[
                const EmptyHeader(
                  text: 'เสียบเครื่องอ่านบัตรก่อน',
                ),
              ],
              if (_error != null) Text(_error.toString()),
              if (_data == null &&
                  (_device != null && _device!.hasPermission)) ...[
                const EmptyHeader(
                  icon: Icons.credit_card,
                  text: 'เสียบบัตรประชาชนได้เลย',
                ),
                SizedBox(
                  height: 200,
                  child: Wrap(children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                            value: selectedTypes.isEmpty,
                            onChanged: (val) {
                              setState(() {
                                if (selectedTypes.isNotEmpty) {
                                  selectedTypes = [];
                                }
                              });
                            }),
                        const Text('readAll'),
                      ],
                    ),
                    for (var ea in _idCardType)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: selectedTypes.contains(ea),
                              onChanged: (val) {
                                print(ea);
                                setState(() {
                                  if (selectedTypes.contains(ea)) {
                                    selectedTypes.remove(ea);
                                  } else {
                                    selectedTypes.add(ea);
                                  }
                                });
                              }),
                          Text('$ea'),
                        ],
                      ),
                  ]),
                ),
              ],
              if (_data != null) ...[
                const Padding(padding: EdgeInsets.all(8.0)),
                if (_data!.photo.isNotEmpty)
                  Center(
                    child: Image.memory(
                      Uint8List.fromList(_data!.photo),
                    ),
                  ),
                if (_data!.cid != null)
                  DisplayInfo(title: 'เลขบัตรประชาชน', value: _data!.cid!),
                if (_data!.firstnameTH != null)
                  DisplayInfo(
                      title: 'ชื่อ-นามสกุล (ภาษาไทย)',
                      value:
                          '${_data!.titleTH} ${_data!.firstnameTH} ${_data?.lastnameTH!}'),
                if (_data!.firstnameEN != null)
                  DisplayInfo(
                      title: 'ชื่อ-นามสกุล (ภาษาอังกฤษ)',
                      value:
                          '${_data!.titleEN} ${_data!.firstnameEN} ${_data!.lastnameEN}'),
                if (_data!.gender != null)
                  DisplayInfo(
                      title: 'เพศ',
                      value:
                          '(${_data!.gender}) ${_data!.gender == 1 ? 'ชาย' : 'หญิง'}'),
                if (_data!.birthdate != null)
                  DisplayInfo(
                      title: 'วันเดือนปีเกิด',
                      value:
                          '${_data!.birthdate.toString()}\n${formattedDate(_data!.birthdate)}'),
                if (_data!.address != null)
                  DisplayInfo(title: 'ที่อยู่', value: _data!.address!),
                if (_data!.issueDate != null)
                  DisplayInfo(
                      title: 'วันออกบัตร',
                      value:
                          '${_data!.issueDate.toString()}\n${formattedDate(_data!.issueDate)}'),
                if (_data!.expireDate != null)
                  DisplayInfo(
                      title: 'วันหมดอายุ',
                      value:
                          '${_data!.expireDate.toString()}\n${formattedDate(_data!.expireDate)}'),
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
          title: Text('${device!.manufacturerName} ${device!.productName}'),
          subtitle: Text(device!.identifier ?? ''),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            color: device!.hasPermission ? Colors.green : Colors.grey,
            child: Text(
                device!.hasPermission
                    ? 'Listening'
                    : (device!.isAttached ? 'Connected' : 'Disconnected'),
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

    _copyFn(value) {
      Clipboard.setData(ClipboardData(text: value)).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Copy it already")));
      });
    }

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
          Stack(
            alignment: Alignment.centerRight,
            children: [
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
              GestureDetector(
                onTap: () => _copyFn(value),
                child: const Icon(Icons.copy),
              )
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
