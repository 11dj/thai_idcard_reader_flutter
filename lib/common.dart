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

class ThaiIDType {
  static String get cid => 'cid';
  static String get nameTH => 'nameTH';
  static String get nameEN => 'nameEN';
  static String get address => 'address';
  static String get birthdate => 'birthdate';
  static String get issueDate => 'issueDate';
  static String get expireDate => 'expireDate';
  static String get gender => 'gender';
  static String get photo => 'photo';
}

class ThaiIDCard {
  String? cid;
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
  List<int> photo;
  ThaiIDCard({
    this.cid,
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
    this.photo = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'nationID': cid,
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
      'photo': photo,
    };
  }

  factory ThaiIDCard.fromMap(Map<String, dynamic> map) {
    String formattedDate(dt) {
      String dtx = dt.toString();
      try {
        final yearTH = dtx.substring(0, 4);
        final month = dtx.substring(4, 6);
        final date = dtx.substring(6, 8);
        final yearEN = int.parse(yearTH) - 543;
        return '$yearEN-$month-$date';
      } catch (e) {
        return dt.toString() + e.toString();
      }
    }

    String removeWhitespaceAddr(str) {
      final rmSpaces = str.split('').where((ea) => ea != ' ').toList().join('');
      final rmHashtags =
          rmSpaces.split('#').where((ea) => ea != '').toList().join(' ');
      return rmHashtags.substring(0, rmHashtags.length - 2);
    }

    String formattedName(String? s, int i) {
      if (i == 2) {
        var sx = List.from(s!.split('#').where((ea) => ea != ''))[i]
            .split(' ')
            .where((ea) => ea != '')
            .join('');
        return sx.substring(0, sx.length - 2);
      } else {
        return List.from(s!.split('#').where((ea) => ea != ''))[i];
      }
    }

    return ThaiIDCard(
      cid: map['cid']?.substring(0, 13),
      titleTH: map['nameTH'] != null ? formattedName(map['nameTH'], 0) : null,
      firstnameTH:
          map['nameTH'] != null ? formattedName(map['nameTH'], 1) : null,
      lastnameTH:
          map['nameTH'] != null ? formattedName(map['nameTH'], 2) : null,
      titleEN: map['nameEN'] != null ? formattedName(map['nameEN'], 0) : null,
      firstnameEN:
          map['nameEN'] != null ? formattedName(map['nameEN'], 1) : null,
      lastnameEN:
          map['nameEN'] != null ? formattedName(map['nameEN'], 2) : null,
      address:
          map['address'] != null ? removeWhitespaceAddr(map['address']) : null,
      birthdate:
          map['birthdate'] != null ? formattedDate(map['birthdate']) : null,
      issueDate:
          map['issueDate'] != null ? formattedDate(map['issueDate']) : null,
      expireDate:
          map['expireDate'] != null ? formattedDate(map['expireDate']) : null,
      gender:
          map['gender'] != null ? int.parse(map['gender'].split('')[0]) : null,
      photo: map['photo'] != null ? map['photo'].cast<int>() : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThaiIDCard.fromJson(String source) =>
      ThaiIDCard.fromMap(json.decode(source));
}
