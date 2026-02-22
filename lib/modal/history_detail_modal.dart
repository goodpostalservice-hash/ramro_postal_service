// class HistoryDetailModal {
//   String? result;
//   String? message;
//   bool? bookable;
//   Data? data;
//
//   HistoryDetailModal({this.result, this.message, this.bookable, this.data});
//
//   HistoryDetailModal.fromJson(Map<String, dynamic> json) {
//     result = json['result'];
//     message = json['message'];
//     bookable = json['bookable'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['result'] = this.result;
//     data['message'] = this.message;
//     data['bookable'] = this.bookable;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   HolderMapImage? holderMapImage;
//   HolderFamilyMember? holderFamilyMember;
//   HolderMapImage? holderBookingDescription;
//   HolderMapImage? holderPickdropLocation;
//   HolderMapImage? holderMetering;
//   HolderMapImage? holderDriver;
//   HolderReceipt? holderReceipt;
//   HolderDriverVehicleRating? holderDriverVehicleRating;
//   ButtonVisibility? buttonVisibility;
//
//   Data(
//       {this.holderMapImage,
//         this.holderFamilyMember,
//         this.holderBookingDescription,
//         this.holderPickdropLocation,
//         this.holderMetering,
//         this.holderDriver,
//         this.holderReceipt,
//         this.holderDriverVehicleRating,
//         this.buttonVisibility});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     holderMapImage = json['holder_map_image'] != null
//         ? new HolderMapImage.fromJson(json['holder_map_image'])
//         : null;
//     holderFamilyMember = json['holder_family_member'] != null
//         ? new HolderFamilyMember.fromJson(json['holder_family_member'])
//         : null;
//     holderBookingDescription = json['holder_booking_description'] != null
//         ? new HolderMapImage.fromJson(json['holder_booking_description'])
//         : null;
//     holderPickdropLocation = json['holder_pickdrop_location'] != null
//         ? new HolderMapImage.fromJson(json['holder_pickdrop_location'])
//         : null;
//     holderMetering = json['holder_metering'] != null
//         ? new HolderMapImage.fromJson(json['holder_metering'])
//         : null;
//     holderDriver = json['holder_driver'] != null
//         ? new HolderMapImage.fromJson(json['holder_driver'])
//         : null;
//     holderReceipt = json['holder_receipt'] != null
//         ? new HolderReceipt.fromJson(json['holder_receipt'])
//         : null;
//     holderDriverVehicleRating = json['holder_driver_vehicle_rating'] != null
//         ? new HolderDriverVehicleRating.fromJson(
//         json['holder_driver_vehicle_rating'])
//         : null;
//     buttonVisibility = json['button_visibility'] != null
//         ? new ButtonVisibility.fromJson(json['button_visibility'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.holderMapImage != null) {
//       data['holder_map_image'] = this.holderMapImage!.toJson();
//     }
//     if (this.holderFamilyMember != null) {
//       data['holder_family_member'] = this.holderFamilyMember!.toJson();
//     }
//     if (this.holderBookingDescription != null) {
//       data['holder_booking_description'] =
//           this.holderBookingDescription!.toJson();
//     }
//     if (this.holderPickdropLocation != null) {
//       data['holder_pickdrop_location'] = this.holderPickdropLocation!.toJson();
//     }
//     if (this.holderMetering != null) {
//       data['holder_metering'] = this.holderMetering!.toJson();
//     }
//     if (this.holderDriver != null) {
//       data['holder_driver'] = this.holderDriver!.toJson();
//     }
//     if (this.holderReceipt != null) {
//       data['holder_receipt'] = this.holderReceipt!.toJson();
//     }
//     if (this.holderDriverVehicleRating != null) {
//       data['holder_driver_vehicle_rating'] =
//           this.holderDriverVehicleRating!.toJson();
//     }
//     if (this.buttonVisibility != null) {
//       data['button_visibility'] = this.buttonVisibility!.toJson();
//     }
//     return data;
//   }
// }
//
// class HolderMapImage {
//   bool? visibility;
//   Data? data;
//
//   HolderMapImage({this.visibility, this.data});
//
//   HolderMapImage.fromJson(Map<String, dynamic> json) {
//     visibility = json['visibility'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visibility'] = this.visibility;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? mapImage;
//
//   Data({this.mapImage});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     mapImage = json['map_image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['map_image'] = this.mapImage;
//     return data;
//   }
// }
//
// class HolderFamilyMember {
//   bool? visibility;
//   String? name;
//   String? phoneNumber;
//   String? age;
//
//   HolderFamilyMember({this.visibility, this.name, this.phoneNumber, this.age});
//
//   HolderFamilyMember.fromJson(Map<String, dynamic> json) {
//     visibility = json['visibility'];
//     name = json['name'];
//     phoneNumber = json['phoneNumber'];
//     age = json['age'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visibility'] = this.visibility;
//     data['name'] = this.name;
//     data['phoneNumber'] = this.phoneNumber;
//     data['age'] = this.age;
//     return data;
//   }
// }
//
// class Data {
//   String? highlightedLeftText;
//   String? highlightedLeftTextStyle;
//   String? highlightedLeftTextColor;
//   String? smallLeftText;
//   String? smallLeftTextStyle;
//   String? smallLeftTextColor;
//   String? highlightedRightText;
//   String? highlightedRightTextStyle;
//   String? highlightedRightTextColor;
//   String? smallRightText;
//   String? smallRightTextStyle;
//   String? smallRightTextColor;
//
//   Data(
//       {this.highlightedLeftText,
//         this.highlightedLeftTextStyle,
//         this.highlightedLeftTextColor,
//         this.smallLeftText,
//         this.smallLeftTextStyle,
//         this.smallLeftTextColor,
//         this.highlightedRightText,
//         this.highlightedRightTextStyle,
//         this.highlightedRightTextColor,
//         this.smallRightText,
//         this.smallRightTextStyle,
//         this.smallRightTextColor});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     highlightedLeftText = json['highlighted_left_text'];
//     highlightedLeftTextStyle = json['highlighted_left_text_style'];
//     highlightedLeftTextColor = json['highlighted_left_text_color'];
//     smallLeftText = json['small_left_text'];
//     smallLeftTextStyle = json['small_left_text_style'];
//     smallLeftTextColor = json['small_left_text_color'];
//     highlightedRightText = json['highlighted_right_text'];
//     highlightedRightTextStyle = json['highlighted_right_text_style'];
//     highlightedRightTextColor = json['highlighted_right_text_color'];
//     smallRightText = json['small_right_text'];
//     smallRightTextStyle = json['small_right_text_style'];
//     smallRightTextColor = json['small_right_text_color'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['highlighted_left_text'] = this.highlightedLeftText;
//     data['highlighted_left_text_style'] = this.highlightedLeftTextStyle;
//     data['highlighted_left_text_color'] = this.highlightedLeftTextColor;
//     data['small_left_text'] = this.smallLeftText;
//     data['small_left_text_style'] = this.smallLeftTextStyle;
//     data['small_left_text_color'] = this.smallLeftTextColor;
//     data['highlighted_right_text'] = this.highlightedRightText;
//     data['highlighted_right_text_style'] = this.highlightedRightTextStyle;
//     data['highlighted_right_text_color'] = this.highlightedRightTextColor;
//     data['small_right_text'] = this.smallRightText;
//     data['small_right_text_style'] = this.smallRightTextStyle;
//     data['small_right_text_color'] = this.smallRightTextColor;
//     return data;
//   }
// }
//
// class Data {
//   bool? pickTextVisibility;
//   String? pickText;
//   bool? dropTextVisibility;
//   String? dropText;
//
//   Data(
//       {this.pickTextVisibility,
//         this.pickText,
//         this.dropTextVisibility,
//         this.dropText});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     pickTextVisibility = json['pick_text_visibility'];
//     pickText = json['pick_text'];
//     dropTextVisibility = json['drop_text_visibility'];
//     dropText = json['drop_text'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pick_text_visibility'] = this.pickTextVisibility;
//     data['pick_text'] = this.pickText;
//     data['drop_text_visibility'] = this.dropTextVisibility;
//     data['drop_text'] = this.dropText;
//     return data;
//   }
// }
//
// class Data {
//   String? textOne;
//   String? textTwo;
//   String? textThree;
//
//   Data({this.textOne, this.textTwo, this.textThree});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     textOne = json['text_one'];
//     textTwo = json['text_two'];
//     textThree = json['text_three'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['text_one'] = this.textOne;
//     data['text_two'] = this.textTwo;
//     data['text_three'] = this.textThree;
//     return data;
//   }
// }
//
// class Data {
//   String? circularImage;
//   String? highlightedText;
//   String? smallText;
//   bool? ratingVisibility;
//   String? rating;
//   bool? ratingButtonVisibility;
//   bool? ratingButtonEnable;
//   String? ratingButtonText;
//   String? ratingButtonTextColor;
//   String? ratingButtonTextStyle;
//
//   Data(
//       {this.circularImage,
//         this.highlightedText,
//         this.smallText,
//         this.ratingVisibility,
//         this.rating,
//         this.ratingButtonVisibility,
//         this.ratingButtonEnable,
//         this.ratingButtonText,
//         this.ratingButtonTextColor,
//         this.ratingButtonTextStyle});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     circularImage = json['circular_image'];
//     highlightedText = json['highlighted_text'];
//     smallText = json['small_text'];
//     ratingVisibility = json['rating_visibility'];
//     rating = json['rating'];
//     ratingButtonVisibility = json['rating_button_visibility'];
//     ratingButtonEnable = json['rating_button_enable'];
//     ratingButtonText = json['rating_button_text'];
//     ratingButtonTextColor = json['rating_button_text_color'];
//     ratingButtonTextStyle = json['rating_button_text_style'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['circular_image'] = this.circularImage;
//     data['highlighted_text'] = this.highlightedText;
//     data['small_text'] = this.smallText;
//     data['rating_visibility'] = this.ratingVisibility;
//     data['rating'] = this.rating;
//     data['rating_button_visibility'] = this.ratingButtonVisibility;
//     data['rating_button_enable'] = this.ratingButtonEnable;
//     data['rating_button_text'] = this.ratingButtonText;
//     data['rating_button_text_color'] = this.ratingButtonTextColor;
//     data['rating_button_text_style'] = this.ratingButtonTextStyle;
//     return data;
//   }
// }
//
// class HolderReceipt {
//   bool? visibility;
//   List<Data>? data;
//
//   HolderReceipt({this.visibility, this.data});
//
//   HolderReceipt.fromJson(Map<String, dynamic> json) {
//     visibility = json['visibility'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         // data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visibility'] = this.visibility;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? highlightedText;
//   String? highlightedTextColor;
//   String? highlightedStyle;
//   bool? highlightedVisibility;
//   String? smallText;
//   String? smallTextColor;
//   String? smallTextStyle;
//   bool? smallTextVisibility;
//   String? valueText;
//   String? valueTextColor;
//   String? valueTextStyle;
//   bool? valueTextvisibility;
//   String? smallTexotClor;
//
//   Data(
//       {this.highlightedText,
//         this.highlightedTextColor,
//         this.highlightedStyle,
//         this.highlightedVisibility,
//         this.smallText,
//         this.smallTextColor,
//         this.smallTextStyle,
//         this.smallTextVisibility,
//         this.valueText,
//         this.valueTextColor,
//         this.valueTextStyle,
//         this.valueTextvisibility,
//         this.smallTexotClor});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     highlightedText = json['highlighted_text'];
//     highlightedTextColor = json['highlighted_text_color'];
//     highlightedStyle = json['highlighted_style'];
//     highlightedVisibility = json['highlighted_visibility'];
//     smallText = json['small_text'];
//     smallTextColor = json['small_text_color'];
//     smallTextStyle = json['small_text_style'];
//     smallTextVisibility = json['small_text_visibility'];
//     valueText = json['value_text'];
//     valueTextColor = json['value_text_color'];
//     valueTextStyle = json['value_text_style'];
//     valueTextvisibility = json['value_textvisibility'];
//     smallTexotClor = json['small_texot_clor'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['highlighted_text'] = this.highlightedText;
//     data['highlighted_text_color'] = this.highlightedTextColor;
//     data['highlighted_style'] = this.highlightedStyle;
//     data['highlighted_visibility'] = this.highlightedVisibility;
//     data['small_text'] = this.smallText;
//     data['small_text_color'] = this.smallTextColor;
//     data['small_text_style'] = this.smallTextStyle;
//     data['small_text_visibility'] = this.smallTextVisibility;
//     data['value_text'] = this.valueText;
//     data['value_text_color'] = this.valueTextColor;
//     data['value_text_style'] = this.valueTextStyle;
//     data['value_textvisibility'] = this.valueTextvisibility;
//     data['small_texot_clor'] = this.smallTexotClor;
//     return data;
//   }
// }
//
// class HolderDriverVehicleRating {
//   bool? visibility;
//   VehicleData? vehicleData;
//
//   HolderDriverVehicleRating({this.visibility, this.vehicleData});
//
//   HolderDriverVehicleRating.fromJson(Map<String, dynamic> json) {
//     visibility = json['visibility'];
//     vehicleData = json['vehicle_data'] != null
//         ? new VehicleData.fromJson(json['vehicle_data'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visibility'] = this.visibility;
//     if (this.vehicleData != null) {
//       data['vehicle_data'] = this.vehicleData!.toJson();
//     }
//     return data;
//   }
// }
//
// class VehicleData {
//   String? bookingId;
//   String? text;
//   String? image;
//
//   VehicleData({this.bookingId, this.text, this.image});
//
//   VehicleData.fromJson(Map<String, dynamic> json) {
//     bookingId = json['booking_id'];
//     text = json['text'];
//     image = json['image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['booking_id'] = this.bookingId;
//     data['text'] = this.text;
//     data['image'] = this.image;
//     return data;
//   }
// }
//
// class ButtonVisibility {
//   bool? track;
//   bool? cancel;
//   bool? mailInvoice;
//   bool? support;
//   bool? coupon;
//
//   ButtonVisibility(
//       {this.track, this.cancel, this.mailInvoice, this.support, this.coupon});
//
//   ButtonVisibility.fromJson(Map<String, dynamic> json) {
//     track = json['track'];
//     cancel = json['cancel'];
//     mailInvoice = json['mail_invoice'];
//     support = json['support'];
//     coupon = json['coupon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['track'] = this.track;
//     data['cancel'] = this.cancel;
//     data['mail_invoice'] = this.mailInvoice;
//     data['support'] = this.support;
//     data['coupon'] = this.coupon;
//     return data;
//   }
// }