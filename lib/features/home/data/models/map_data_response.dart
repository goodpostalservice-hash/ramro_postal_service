class MapDataResponse {
  bool? success;
  int? zoomLevel;
  UserLocation? userLocation;
  MapBounds? mapBounds;
  int? count;
  List<AddressData>? data;

  MapDataResponse({
    this.success,
    this.zoomLevel,
    this.userLocation,
    this.mapBounds,
    this.count,
    this.data,
  });

  MapDataResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    zoomLevel = json['zoom_level'];
    userLocation = json['user_location'] != null
        ? UserLocation.fromJson(json['user_location'])
        : null;
    mapBounds = json['map_bounds'] != null
        ? MapBounds.fromJson(json['map_bounds'])
        : null;
    count = json['count'];
    if (json['data'] != null) {
      data = <AddressData>[];
      json['data'].forEach((v) {
        data!.add(AddressData.fromJson(v));
      });
    }
  }
}

class UserLocation {
  dynamic latitude;
  dynamic longitude;

  UserLocation({this.latitude, this.longitude});

  UserLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}

class MapBounds {
  Null north;
  Null south;
  Null east;
  Null west;

  MapBounds({this.north, this.south, this.east, this.west});

  MapBounds.fromJson(Map<String, dynamic> json) {
    north = json['north'];
    south = json['south'];
    east = json['east'];
    west = json['west'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['north'] = north;
    data['south'] = south;
    data['east'] = east;
    data['west'] = west;
    return data;
  }
}

class AddressData {
  int? id;
  String? longitude;
  String? latitude;
  String? cordinate;
  String? zipCode;
  String? area;
  String? zone;
  String? subZone;
  String? street;
  String? houseNum;
  String? fullAddressDetail;
  String? locationName;
  dynamic distance;

  AddressData({
    this.id,
    this.longitude,
    this.latitude,
    this.cordinate,
    this.zipCode,
    this.area,
    this.zone,
    this.subZone,
    this.street,
    this.houseNum,
    this.fullAddressDetail,
    this.locationName,
    this.distance,
  });

  AddressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    cordinate = json['cordinate'];
    zipCode = json['zip_code'];
    area = json['area'];
    zone = json['zone'];
    subZone = json['sub_zone'];
    street = json['street'];
    houseNum = json['house_num'];
    fullAddressDetail = json['full_address_detail'];
    locationName = json['location_name'];
    distance = json['distance'];
  }
}
