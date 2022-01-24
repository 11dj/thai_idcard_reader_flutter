import 'dart:convert';
import 'dart:core';

import 'dart:typed_data';

class UsbDevice {
  String? identifier;
  String? manufacturerName;
  String? productName;
  int? vendorId;
  int? productId;
  int? deviceId;
  int? interfaceCount;
  bool hasPermission;
  bool isAttached;

  UsbDevice({
    this.identifier,
    this.manufacturerName,
    this.productName,
    this.vendorId,
    this.productId,
    this.deviceId,
    this.interfaceCount,
    this.hasPermission = false,
    this.isAttached = false,
  });

  factory UsbDevice.fromMap(Map<dynamic, dynamic> map) {
    return UsbDevice(
      identifier: map['identifier'],
      manufacturerName: map['manufacturerName'],
      productName: map['productName'],
      vendorId: map['vendorId'],
      productId: map['productId'],
      deviceId: map['deviceId'],
      interfaceCount: map['interfaceCount'],
      hasPermission: map['hasPermission'],
      isAttached: map['isAttached'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'manufacturerName': manufacturerName,
      'productName': productName,
      'vendorId': vendorId,
      'productId': productId,
      'deviceId': deviceId,
      'interfaceCount': interfaceCount,
      'hasPermission': hasPermission,
      'isAttached': isAttached,
    };
  }

  @override
  String toString() => toMap().toString();
}

class IDCardReader {
  int? currentState;
  int? previousState;
  String? status;
  bool isReady;

  IDCardReader({
    this.currentState,
    this.previousState,
    this.status,
    this.isReady = false,
  });

  factory IDCardReader.fromMap(Map<dynamic, dynamic> map) {
    return IDCardReader(
      currentState: map['currentState'],
      previousState: map['previousState'],
      status: map['status'],
      isReady: map['status'] == 'Present',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentState': currentState,
      'previousState': previousState,
      'status': status,
      'isReady': isReady,
    };
  }

  @override
  String toString() => toMap().toString();
}

class ThaiIDCard {
  String? nationID;
  String? titleTH;
  String? firstnameTH;
  String? lastnameTH;
  String? titleEN;
  String? firstnameEN;
  String? lastnameEN;
  String? address;
  String? birthdate;
  String? issueDate;
  String? expireDate;
  int? gender;
  List<int> image;
  ThaiIDCard({
    this.nationID,
    this.titleTH,
    this.firstnameTH,
    this.lastnameTH,
    this.titleEN,
    this.firstnameEN,
    this.lastnameEN,
    this.address,
    this.birthdate,
    this.issueDate,
    this.expireDate,
    this.gender,
    this.image = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'nationID': nationID,
      'titleTH': titleTH,
      'firstnameTH': firstnameTH,
      'lastnameTH': lastnameTH,
      'titleEN': titleEN,
      'firstnameEN': firstnameEN,
      'lastnameEN': lastnameEN,
      'address': address,
      'birthdate': birthdate,
      'issueDate': issueDate,
      'expireDate': expireDate,
      'gender': gender,
      'image': image,
    };
  }

  factory ThaiIDCard.fromMap(Map<String, dynamic> map) {
    return ThaiIDCard(
      nationID: map['nationID'] ?? '',
      titleTH: map['titleTH'] ?? '',
      firstnameTH: map['firstnameTH'] ?? '',
      lastnameTH: map['lastnameTH'] ?? '',
      titleEN: map['titleEN'] ?? '',
      firstnameEN: map['firstnameEN'] ?? '',
      lastnameEN: map['lastnameEN'] ?? '',
      address: map['address'] ?? '',
      birthdate: map['birthdate'],
      issueDate: map['issueDate'],
      expireDate: map['expireDate'],
      gender: map['gender'],
      image: map['image'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThaiIDCard.fromJson(String source) =>
      ThaiIDCard.fromMap(json.decode(source));
}
