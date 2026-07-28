import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/design_system/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/custom_app_widget.dart';
import '../../data/models/terms_data.dart';
import '../controllers/settings_controller.dart';

// Assume you fetch the TermsData from your API controller
// TermsData termsData = await api.fetchTerms();

class TermsAndConditionsScreen extends GetView<SettingsController> {
  const TermsAndConditionsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      appBar: backAppBar('Terms and Conditions', context),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount:
            controller.termsAndConditionsData.value!.sections.length +
            3, // +3 for Intro, Contact, and bottom spacing
        itemBuilder: (context, index) {
          // 1. Introduction Block
          if (index == 0) {
            return _buildHeader(context);
          }
          // 2. Sections Block
          else if (index <=
              controller.termsAndConditionsData.value!.sections.length) {
            final section =
                controller.termsAndConditionsData.value!.sections[index - 1];
            return _buildSection(section);
          }
          // 3. Contact Info Block
          else if (index ==
              controller.termsAndConditionsData.value!.sections.length + 1) {
            return _buildContactCard(context);
          }
          // 4. Bottom Spacing
          else {
            return const SizedBox(height: 40);
          }
        },
      ),
    );
  }

  // ── Header Widget ──
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.termsAndConditionsData.value?.title ?? '',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Effective Date: ${controller.termsAndConditionsData.value?.effectiveDate}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1976D2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          controller.termsAndConditionsData.value?.introduction ?? '',
          style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey[700]),
        ),
        const SizedBox(height: 32),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Section Widget (Numbered) ──
  Widget _buildSection(TermsSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number Badge
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(top: 2, right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${section.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              // Heading
              Expanded(
                child: Text(
                  section.heading,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Body Text
          Padding(
            padding: const EdgeInsets.only(
              left: 40,
            ), // Indent body text to align with heading
            child: Text(
              section.body,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.6,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Contact Card Widget ──
  Widget _buildContactCard(BuildContext context) {
    final contact = controller.termsAndConditionsData.value?.contactInfo;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need Help? Contact Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),
          _contactRow(
            Icons.language,
            'Website',
            contact!.website,
            () => _launchUrl(contact.website),
          ),
          const SizedBox(height: 16),
          _contactRow(
            Icons.email_outlined,
            'Email',
            contact.email,
            () => _launchUrl('mailto:${contact.email}'),
          ),
          const SizedBox(height: 16),
          _contactRow(
            Icons.phone_outlined,
            'Phone',
            contact.phone,
            () => _launchUrl('tel:${contact.phone}'),
          ),
          const SizedBox(height: 16),
          _contactRow(
            Icons.location_on_outlined,
            'Address',
            contact.address,
            () {},
          ),
        ],
      ),
    );
  }

  // ── Contact Row Helper ──
  Widget _contactRow(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1976D2), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
