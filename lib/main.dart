import 'package:flutter/services.dart';
import 'common.dart';
import 'dart:core';

class ThaiIdcardReaderFlutter {
  static const MethodChannel _channel =
      MethodChannel('thai_idcard_reader_flutter_channel');

  static const EventChannel _usbStreamChannel =
      EventChannel('usb_stream_channel');
  static const EventChannel _readerStreamChannel =
      EventChannel('reader_stream_channel');

  static Stream<UsbDevice> get deviceHandlerStream {
    return _usbStreamChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => UsbDevice.fromMap(event));
  }

  static Stream<IDCardReader> get cardHandlerStream {
    return _readerStreamChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => IDCardReader.fromMap(event));
  }

  static Future<ThaiIDCard> read({List<String> only = const []}) async {
    final String res = only.isNotEmpty
        ? await _channel.invokeMethod('read', {'selected': only})
        : await _channel.invokeMethod('readAll');
    return ThaiIDCard.fromJson(res);
  }
}
