class PrivacyData {
  final String title;
  final String effectiveDate;
  final String introduction;
  final List<PrivacySection> sections;
  final ContactInfo contactInfo;

  PrivacyData({
    required this.title,
    required this.effectiveDate,
    required this.introduction,
    required this.sections,
    required this.contactInfo,
  });

  factory PrivacyData.fromJson(Map<String, dynamic> json) {
    return PrivacyData(
      title: json['title'] ?? '',
      effectiveDate: json['effective_date'] ?? '',
      introduction: json['introduction'] ?? '',
      sections:
          (json['sections'] as List?)
              ?.map((e) => PrivacySection.fromJson(e))
              .toList() ??
          [],
      contactInfo: ContactInfo.fromJson(json['contact_info'] ?? {}),
    );
  }
}

class PrivacySection {
  final int id;
  final String heading;
  final String body;

  PrivacySection({required this.id, required this.heading, required this.body});

  factory PrivacySection.fromJson(Map<String, dynamic> json) {
    return PrivacySection(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      body: json['body'] ?? '',
    );
  }
}

// Note: If you already created ContactInfo in your Terms & Conditions model,
// you can reuse it and delete this duplicate here.
class ContactInfo {
  final String companyName;
  final String website;
  final String email;
  final String phone;
  final String address;

  ContactInfo({
    required this.companyName,
    required this.website,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      companyName: json['company_name'] ?? '',
      website: json['website'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
