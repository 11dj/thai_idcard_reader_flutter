import 'dart:async';
import 'common.dart';
import 'package:flutter/services.dart';

class IdCardReader {
  static const MethodChannel _channel = MethodChannel('id_card_reader');
  static const EventChannel _eventChannel = EventChannel('reader_stream');
  static const EventChannel _randomNumberChannel =
      EventChannel('random_number_channel');

  // static const EventChannel _eventChannel = EventChannel('streamTest');

  static Stream<List>? _deviceStream;

  static Stream<int> get getRandomNumberStream {
    return _randomNumberChannel.receiveBroadcastStream().cast();
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

  static Future get test1 async {
    final res = await _channel.invokeMethod('test1');
    return res;
  }

  static Future get open1 async {
    final res = await _channel.invokeMethod('open1');
    return res;
  }

  static Future get warm1 async {
    final res = await _channel.invokeMethod('warm1');
    return res;
  }

  static Future get protocal1 async {
    final res = await _channel.invokeMethod('protocal1');
    return res;
  }

  static Future get read1 async {
    final res = await _channel.invokeMethod('read1');
    return res;
  }

  static Stream<List>? get getDevices {
    _deviceStream = _eventChannel.receiveBroadcastStream().cast();
    return _deviceStream;
  }

  static Future<void> requestPermission(UsbDevice usbDevice) {
    return _channel.invokeMethod('requestPermission', usbDevice.toMap());
  }

  static Future getData() {
    return _channel.invokeMethod('getData');
  }
}
