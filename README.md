# thai_idcard_reader_flutter

A plugin for communicating with ACS ACR39U Smart Card reader to read Thai ID card instantly.

## Support
- Android 5.0 or newer
- iOS is unavailable

## Tested Devices 
- ACR39U-NF PocketMate II Smart Card Reader (USB Type-C)
- or Any Products tha made from ACS if it works.



## Getting Started

```dart

// import packages
import 'package:thai_idcard_reader_flutter/thai_idcard_reader_flutter.dart';

// put this line to initState() for listening Reader if it connect to device.
ThaiIdcardReaderFlutter.deviceHandlerStream.listen(_onUSB);


// create function to handle reader connects to app.
void _onUSB(usbEvent) {
    try {
        // if reader connected and accepted permission to device.
        if (usbEvent.hasPermission) {
        // add subscription to listen to card insert to reader.
        subscription = ThaiIdcardReaderFlutter.cardHandlerStream.listen(_onData);
        } else {
        // if reader is disconnected. cancel listen to card from reader
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

// create function to listen card to read data.
void _onData(readerEvent) {
    try {
        setState(() {
        _card = readerEvent;
        });
        if (readerEvent.isReady) {
        // to read all data from ID card.
        readCard();
        } else {
        _clear();
        }
    } catch (e) {
        setState(() {
        _error = "_onData " + e.toString();
        });
    }
}

// create function to read all data ID card if card has inserted to reader.
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

```

## Optional from `ThaiIdcardReaderFlutter.read()`


```dart

// for reall all data from ID card.
await ThaiIdcardReaderFlutter.read();


// for read any data from ID card. you can add/remove in List as you want.
await ThaiIdcardReaderFlutter.read(only: [
    ThaiIDType.cid,
    ThaiIDType.photo,
    ThaiIDType.nameTH,
    ThaiIDType.nameEN,
    ThaiIDType.gender,
    ThaiIDType.birthdate,
    ThaiIDType.address,
    ThaiIDType.issueDate,
    ThaiIDType.expireDate,
  ]);

```
