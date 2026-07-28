enum SearchAddressSource { ramro, google }

class SearchResponse {
  final bool? success;
  final String? query;
  final List<SearchAddress> data;

  SearchResponse({this.success, this.query, this.data = const []});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      success: json['success'],
      query: json['query'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SearchAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'query': query,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SearchAddress {
  final int? id;
  final String? longitude;
  final String? latitude;
  final String? cordinate;
  final String? zipCode;
  final String? area;
  final String? zone;
  final String? subZone;
  final String? street;
  final String? houseNum;
  final String? fullAddressDetail;
  final String? locationName;
  final String? createdAt;
  final String? updatedAt;
  final String? placeId;
  final SearchAddressSource source;

  SearchAddress({
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
    this.createdAt,
    this.updatedAt,
    this.placeId,
    SearchAddressSource? source,
  }) : source =
           source ??
           (placeId != null
               ? SearchAddressSource.google
               : SearchAddressSource.ramro);

  factory SearchAddress.fromJson(Map<String, dynamic> json) {
    return SearchAddress(
      id: json['id'],
      longitude: json['longitude']?.toString(),
      latitude: json['latitude']?.toString(),
      cordinate: json['cordinate']?.toString(),
      zipCode: json['zip_code']?.toString(),
      area: json['area']?.toString(),
      zone: json['zone']?.toString(),
      subZone: json['sub_zone']?.toString(),
      street: json['street']?.toString(),
      houseNum: json['house_num']?.toString(),
      fullAddressDetail: json['full_address_detail']?.toString(),
      locationName: json['location_name']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      placeId: json['place_id']?.toString(),
      source: _sourceFromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
      'cordinate': cordinate,
      'zip_code': zipCode,
      'area': area,
      'zone': zone,
      'sub_zone': subZone,
      'street': street,
      'house_num': houseNum,
      'full_address_detail': fullAddressDetail,
      'location_name': locationName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'place_id': placeId,
      'source': source.name,
    };
  }

  bool get isRamro => source == SearchAddressSource.ramro;

  bool get hasCoordinates =>
      double.tryParse(latitude ?? '') != null &&
      double.tryParse(longitude ?? '') != null;

  static SearchAddressSource _sourceFromJson(Map<String, dynamic> json) {
    final source = json['source']?.toString();
    if (source == SearchAddressSource.google.name) {
      return SearchAddressSource.google;
    }
    if (source == SearchAddressSource.ramro.name) {
      return SearchAddressSource.ramro;
    }

    // Search history written by older app versions has no source field.
    return json['place_id'] != null
        ? SearchAddressSource.google
        : SearchAddressSource.ramro;
  }

  String get displayAddress {
    if ((fullAddressDetail ?? '').trim().isNotEmpty) {
      return fullAddressDetail!.trim();
    }

    final parts = [
      houseNum,
      street,
      subZone,
      zone,
      area,
      zipCode,
    ].where((e) => e != null && e.trim().isNotEmpty).cast<String>().toList();

    return parts.join(', ');
  }
}
