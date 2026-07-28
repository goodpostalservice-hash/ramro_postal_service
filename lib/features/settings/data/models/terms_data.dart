class TermsData {
  final String title;
  final String effectiveDate;
  final String introduction;
  final List<TermsSection> sections;
  final ContactInfo contactInfo;

  TermsData({
    required this.title,
    required this.effectiveDate,
    required this.introduction,
    required this.sections,
    required this.contactInfo,
  });

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      title: json['title'] ?? '',
      effectiveDate: json['effective_date'] ?? '',
      introduction: json['introduction'] ?? '',
      sections:
          (json['sections'] as List?)
              ?.map((e) => TermsSection.fromJson(e))
              .toList() ??
          [],
      contactInfo: ContactInfo.fromJson(json['contact_info'] ?? {}),
    );
  }
}

class TermsSection {
  final int id;
  final String heading;
  final String body;

  TermsSection({required this.id, required this.heading, required this.body});

  factory TermsSection.fromJson(Map<String, dynamic> json) {
    return TermsSection(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      body: json['body'] ?? '',
    );
  }
}

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
