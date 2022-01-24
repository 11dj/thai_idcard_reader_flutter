import 'dart:async';
import 'common.dart';
import 'package:flutter/services.dart';

class ThaiIdcardReaderFlutter {
  static const MethodChannel _channel =
      MethodChannel('thai_idcard_reader_flutter_channel');

  static const EventChannel _usbStreamChannel =
      EventChannel('usb_stream_channel');
  static const EventChannel _readerStreamChannel =
      EventChannel('reader_stream_channel');

  static Stream get deviceHandlerStream {
    return _usbStreamChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => UsbDevice.fromMap(event));
  }

  static Stream get cardHandlerStream {
    return _readerStreamChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => IDCardReader.fromMap(event));
    ;
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<UsbDevice>> getDeviceList() async {
    List<Map<dynamic, dynamic>> list =
        (await _channel.invokeListMethod('getDeviceList'))!;
    return list.map((e) => UsbDevice.fromMap(e)).toList();
  }

  static Future get open1 async {
    final res = await _channel.invokeMethod('open1');
    return res;
  }

  static Future get warm1 async {
    final res = await _channel.invokeMethod('warm1');
    return res;
  }

  static Future get protocol1 async {
    final res = await _channel.invokeMethod('protocol1');
    return res;
  }

  static Future<ThaiIDCard> get readAll async {
    formattedDate(dt) {
      String dtx = dt.toString();
      try {
        final yearTH = dtx.substring(0, 4);
        final month = dtx.substring(4, 6);
        final date = dtx.substring(6, 8);
        final yearEN = int.parse(yearTH) - 543;
        return '$yearEN-$month-$date';
      } catch (e) {
        return e;
      }
    }

    removeWhitespaceAddr(str) {
      final rmSpaces = str.split('').where((ea) => ea != ' ').toList().join('');
      final rmHashtags =
          rmSpaces.split('#').where((ea) => ea != '').toList().join(' ');
      return rmHashtags;
    }

    bool isNumeric(String? s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    final res = await _channel.invokeMethod('readAll');
    final resx = {
      "nationID": res['cid'].split('').where((ea) => isNumeric(ea)).join(''),
      "titleTH": List.from(res['nameTH'].split('#').where((ea) => ea != ''))[0],
      "firstnameTH":
          List.from(res['nameTH'].split('#').where((ea) => ea != ''))[1],
      "lastnameTH":
          List.from(res['nameTH'].split('#').where((ea) => ea != ''))[2]
              .split(' ')
              .where((ea) => ea != '')
              .join(''),
      "titleEN": List.from(res['nameEN'].split('#').where((ea) => ea != ''))[0],
      "firstnameEN":
          List.from(res['nameEN'].split('#').where((ea) => ea != ''))[1],
      "lastnameEN":
          List.from(res['nameEN'].split('#').where((ea) => ea != ''))[2]
              .split(' ')
              .where((ea) => ea != '')
              .join(''),
      "gender": int.parse(res['gender'].split('')[0]),
      "birthdate": formattedDate(res['birthdate']),
      "address": removeWhitespaceAddr(res['address']),
      "issueDate": formattedDate(res['issueDate']),
      "expireDate": formattedDate(res['expireDate']),
      "image": res['pictureBuffer']
    };
    return ThaiIDCard.fromMap(resx);
  }

  static Future<void> requestPermission(UsbDevice usbDevice) {
    return _channel.invokeMethod('requestPermission', usbDevice.toMap());
  }

  static Future test1({List<String>? selected}) async {
    final res =
        await _channel.invokeMethod('read', {'selected': selected ?? []});
    return res;
  }

  static Future getData() {
    return _channel.invokeMethod('getData');
  }
}
