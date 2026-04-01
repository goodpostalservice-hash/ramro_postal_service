import 'dart:convert';

import 'package:equatable/equatable.dart';

class RestartRouterResponse extends Equatable {
  final num? responseCode;
  final String? responseDescription;
  final dynamic oltName;
  final dynamic frame;
  final dynamic slot;
  final dynamic port;
  final dynamic serialNumber;
  final dynamic ontid;
  final dynamic ontName;
  final dynamic equipmentId;
  final dynamic vlanid;
  final dynamic wanUsername;
  final dynamic wifiStatResult;
  final dynamic wifiStatResult5G;
  final dynamic vlanInfoResult;
  final dynamic vlanInfoList;
  final dynamic wlanInfoList;
  final dynamic ontInfoList;
  final dynamic alarmList;
  final dynamic lpList;
  final dynamic oltList;
  final dynamic connectedDeviceList;

  const RestartRouterResponse({
    this.responseCode,
    this.responseDescription,
    this.oltName,
    this.frame,
    this.slot,
    this.port,
    this.serialNumber,
    this.ontid,
    this.ontName,
    this.equipmentId,
    this.vlanid,
    this.wanUsername,
    this.wifiStatResult,
    this.wifiStatResult5G,
    this.vlanInfoResult,
    this.vlanInfoList,
    this.wlanInfoList,
    this.ontInfoList,
    this.alarmList,
    this.lpList,
    this.oltList,
    this.connectedDeviceList,
  });

  factory RestartRouterResponse.fromMap(Map<String, dynamic> data) {
    return RestartRouterResponse(
      responseCode: data['ResponseCode'] as num?,
      responseDescription: data['ResponseDescription'] as String?,
      oltName: data['OLTName'] as dynamic,
      frame: data['Frame'] as dynamic,
      slot: data['Slot'] as dynamic,
      port: data['Port'] as dynamic,
      serialNumber: data['SerialNumber'] as dynamic,
      ontid: data['ONTID'] as dynamic,
      ontName: data['ONTName'] as dynamic,
      equipmentId: data['EquipmentID'] as dynamic,
      vlanid: data['VLANID'] as dynamic,
      wanUsername: data['WANUsername'] as dynamic,
      wifiStatResult: data['WifiStatResult'] as dynamic,
      wifiStatResult5G: data['WifiStatResult5G'] as dynamic,
      vlanInfoResult: data['VLANInfoResult'] as dynamic,
      vlanInfoList: data['VLANInfoList'] as dynamic,
      wlanInfoList: data['WLANInfoList'] as dynamic,
      ontInfoList: data['OntInfoList'] as dynamic,
      alarmList: data['AlarmList'] as dynamic,
      lpList: data['LP_List'] as dynamic,
      oltList: data['OLTList'] as dynamic,
      connectedDeviceList: data['ConnectedDeviceList'] as dynamic,
    );
  }

  Map<String, dynamic> toMap() => {
        'ResponseCode': responseCode,
        'ResponseDescription': responseDescription,
        'OLTName': oltName,
        'Frame': frame,
        'Slot': slot,
        'Port': port,
        'SerialNumber': serialNumber,
        'ONTID': ontid,
        'ONTName': ontName,
        'EquipmentID': equipmentId,
        'VLANID': vlanid,
        'WANUsername': wanUsername,
        'WifiStatResult': wifiStatResult,
        'WifiStatResult5G': wifiStatResult5G,
        'VLANInfoResult': vlanInfoResult,
        'VLANInfoList': vlanInfoList,
        'WLANInfoList': wlanInfoList,
        'OntInfoList': ontInfoList,
        'AlarmList': alarmList,
        'LP_List': lpList,
        'OLTList': oltList,
        'ConnectedDeviceList': connectedDeviceList,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RestartRouterResponse].
  factory RestartRouterResponse.fromJson(String data) {
    return RestartRouterResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RestartRouterResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  RestartRouterResponse copyWith({
    int? responseCode,
    String? responseDescription,
    dynamic oltName,
    dynamic frame,
    dynamic slot,
    dynamic port,
    dynamic serialNumber,
    dynamic ontid,
    dynamic ontName,
    dynamic equipmentId,
    dynamic vlanid,
    dynamic wanUsername,
    dynamic wifiStatResult,
    dynamic wifiStatResult5G,
    dynamic vlanInfoResult,
    dynamic vlanInfoList,
    dynamic wlanInfoList,
    dynamic ontInfoList,
    dynamic alarmList,
    dynamic lpList,
    dynamic oltList,
    dynamic connectedDeviceList,
  }) {
    return RestartRouterResponse(
      responseCode: responseCode ?? this.responseCode,
      responseDescription: responseDescription ?? this.responseDescription,
      oltName: oltName ?? this.oltName,
      frame: frame ?? this.frame,
      slot: slot ?? this.slot,
      port: port ?? this.port,
      serialNumber: serialNumber ?? this.serialNumber,
      ontid: ontid ?? this.ontid,
      ontName: ontName ?? this.ontName,
      equipmentId: equipmentId ?? this.equipmentId,
      vlanid: vlanid ?? this.vlanid,
      wanUsername: wanUsername ?? this.wanUsername,
      wifiStatResult: wifiStatResult ?? this.wifiStatResult,
      wifiStatResult5G: wifiStatResult5G ?? this.wifiStatResult5G,
      vlanInfoResult: vlanInfoResult ?? this.vlanInfoResult,
      vlanInfoList: vlanInfoList ?? this.vlanInfoList,
      wlanInfoList: wlanInfoList ?? this.wlanInfoList,
      ontInfoList: ontInfoList ?? this.ontInfoList,
      alarmList: alarmList ?? this.alarmList,
      lpList: lpList ?? this.lpList,
      oltList: oltList ?? this.oltList,
      connectedDeviceList: connectedDeviceList ?? this.connectedDeviceList,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      responseCode,
      responseDescription,
      oltName,
      frame,
      slot,
      port,
      serialNumber,
      ontid,
      ontName,
      equipmentId,
      vlanid,
      wanUsername,
      wifiStatResult,
      wifiStatResult5G,
      vlanInfoResult,
      vlanInfoList,
      wlanInfoList,
      ontInfoList,
      alarmList,
      lpList,
      oltList,
      connectedDeviceList,
    ];
  }
}
