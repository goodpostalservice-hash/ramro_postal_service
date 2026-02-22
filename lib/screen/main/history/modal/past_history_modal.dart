class PastHistoryModal {
  String? result;
  String? message;
  String? nextPageUrl;
  int? totalPages;
  int? currentPage;
  List<Data>? data;

  PastHistoryModal(
      {this.result,
        this.message,
        this.nextPageUrl,
        this.totalPages,
        this.currentPage,
        this.data});

  PastHistoryModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    nextPageUrl = json['next_page_url'];
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    data['next_page_url'] = nextPageUrl;
    data['total_pages'] = totalPages;
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? paymentMethod;
  int? bookingId;
  bool? mapImageVisibility;
  String? mapImage;
  bool? pickVisibility;
  String? pickText;
  bool? dropVisibility;
  String? dropLocation;
  bool? driverBlockVisibility;
  String? statusText;
  String? circularImage;
  String? highlightedText;
  String? highlightedSmallText;
  String? valueText;
  bool? valueTextVisibility;
  String? valueTextColor;
  String? pickupLatitude;
  String? pickupLongitude;
  String? dropLatitude;
  String? dropLongitude;
  String? pickMarkerIcon;
  String? dropMarkerIcon;
  String? ployPoints;

  Data(
      {this.paymentMethod,
        this.bookingId,
        this.mapImageVisibility,
        this.mapImage,
        this.pickVisibility,
        this.pickText,
        this.dropVisibility,
        this.dropLocation,
        this.driverBlockVisibility,
        this.statusText,
        this.circularImage,
        this.highlightedText,
        this.highlightedSmallText,
        this.valueText,
        this.valueTextVisibility,
        this.valueTextColor,
        this.pickupLatitude,
        this.pickupLongitude,
        this.dropLatitude,
        this.dropLongitude,
        this.pickMarkerIcon,
        this.dropMarkerIcon,
        this.ployPoints});

  Data.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    bookingId = json['booking_id'];
    mapImageVisibility = json['map_image_visibility'];
    mapImage = json['map_image'];
    pickVisibility = json['pick_visibility'];
    pickText = json['pick_text'];
    dropVisibility = json['drop_visibility'];
    dropLocation = json['drop_location'];
    driverBlockVisibility = json['driver_block_visibility'];
    statusText = json['status_text'];
    circularImage = json['circular_image'];
    highlightedText = json['highlighted_text'];
    highlightedSmallText = json['highlighted_small_text'];
    valueText = json['value_text'];
    valueTextVisibility = json['value_text_visibility'];
    valueTextColor = json['value_text_color'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    pickMarkerIcon = json['pick_marker_icon'];
    dropMarkerIcon = json['drop_marker_icon'];
    ployPoints = json['ploy_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_method'] = paymentMethod;
    data['booking_id'] = bookingId;
    data['map_image_visibility'] = mapImageVisibility;
    data['map_image'] = mapImage;
    data['pick_visibility'] = pickVisibility;
    data['pick_text'] = pickText;
    data['drop_visibility'] = dropVisibility;
    data['drop_location'] = dropLocation;
    data['driver_block_visibility'] = driverBlockVisibility;
    data['status_text'] = statusText;
    data['circular_image'] = circularImage;
    data['highlighted_text'] = highlightedText;
    data['highlighted_small_text'] = highlightedSmallText;
    data['value_text'] = valueText;
    data['value_text_visibility'] = valueTextVisibility;
    data['value_text_color'] = valueTextColor;
    data['pickup_latitude'] = pickupLatitude;
    data['pickup_longitude'] = pickupLongitude;
    data['drop_latitude'] = dropLatitude;
    data['drop_longitude'] = dropLongitude;
    data['pick_marker_icon'] = pickMarkerIcon;
    data['drop_marker_icon'] = dropMarkerIcon;
    data['ploy_points'] = ployPoints;
    return data;
  }
}