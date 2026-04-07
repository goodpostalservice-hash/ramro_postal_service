// lib/screen/menu/view/menu_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/app/core/utils/storage_util.dart';
import 'package:ramro_postal_service/app/core/values/const_keys.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart'; // for AppConstant, routes, etc.
import 'package:ramro_postal_service/screen/driver/order_history/view/order_history_screen.dart';
import 'package:ramro_postal_service/screen/common/about/view/privacy_policy.dart';
import 'package:ramro_postal_service/screen/common/profile/controller/profile_controller.dart';
import 'package:ramro_postal_service/screen/common/profile/model/profile_response_model.dart';
import 'package:ramro_postal_service/screen/driver/available_orders/presentation/available_orders_screen.dart';
import 'package:ramro_postal_service/screen/user/available_packages/presentation/pages/available_packages.dart';
import 'package:ramro_postal_service/user_type_screen.dart';

import '../../app/routes/app_pages.dart';
import 'widget/small_outline_button.dart';

class MenuScreen extends GetView<ProfileController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      backgroundColor: appTheme.white,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const _NoGlowBouncyBehavior(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Obx(
                    () => _ProfileCard(
                      profileResponse: controller.resultList.value,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Preferences section
                  _SectionCard(
                    title: 'Preferences',
                    children: [
                      _SettingsTile.switchTile(
                        leadingIcon: Assets.notification,
                        title: 'Notifications and sounds',
                        value: controller.notifEnabled.value,
                        onChanged: (v) => controller.notifEnabled.value = v,
                      ),
                      const _DividerLine(),
                      _SettingsTile.switchTile(
                        leadingIcon: Assets.location,
                        title: 'Location',
                        value: controller.locationEnabled.value,
                        onChanged: (v) => controller.locationEnabled.value = v,
                      ),
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.language,
                        title: 'Language',
                        trailingText: 'English',
                        onTap: () {},
                      ),

                      if (SStorageUtil.getData(key: SConstKeys.selectedRole) ==
                          'rider') ...[
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Wallet',
                          onTap: () {
                            Get.toNamed(Routes.WALLET);
                          },
                        ),
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'My Subscription',
                          onTap: () {
                            Get.toNamed(Routes.MY_SUBSCRIPTION);
                          },
                        ),
                      ],
                      if (SStorageUtil.getData(key: SConstKeys.selectedRole) ==
                          'driver') ...[
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Earning Dashboard',
                          onTap: () {
                            Get.toNamed(Routes.EARNING_DASHBOARD);
                          },
                        ),
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Order History',
                          onTap: () {
                            Get.to(() => OrderHistoryScreen());
                          },
                        ),
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Available orders',
                          onTap: () {
                            Get.to(() => AvailableOrdersScreen());
                          },
                        ),
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Available Packages',
                          onTap: () {
                            Get.to(() => AvailablePackageScreen());
                          },
                        ),
                      ],
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.addMissingPlace,
                        title: 'Add missing place',
                        onTap: () => Get.toNamed('/addPlace'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Account section
                  _SectionCard(
                    title: 'Account',
                    children: [
                      _SettingsTile.navTile(
                        leadingIcon: Assets.support,
                        title: 'Support',
                        // onTap: () => Get.to(() => const FAQScreen()),
                        onTap: () => Get.to(() => const RoleSelectionPage()),
                      ),
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.terms,
                        title: 'Terms and privacy policy',
                        onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                      ),
                      const _DividerLine(),
                      _SettingsTile.destructive(
                        leadingIcon: Assets.logout,
                        title: 'Logout',
                        onTap: () {
                          // Place your logout flow here
                          SStorageUtil.deleteAuthData();
                          Get.offAllNamed(Routes.SELECT_ROLE);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  _VersionPill(version: '1.0.0'),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------- Bounce everywhere & no glow ----------
class _NoGlowBouncyBehavior extends ScrollBehavior {
  const _NoGlowBouncyBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

/// ---------- Profile Card ----------
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profileResponse});

  final ProfileResponseModel profileResponse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('/profile');
      },
      child: Container(
        padding: EdgeInsets.all(getSize(8.0)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appTheme.gray200),
        ),
        child: Row(
          children: [
            // avatar
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: CachedNetworkImage(
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                  placeholder: (_, __) => Image.asset(
                    'assets/banners/ic_app_card_placeholder.png',
                    height: 64,
                    width: 64,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (_, __, ___) => Image.asset(
                    'assets/banners/ic_app_card_placeholder.png',
                    height: 64,
                    width: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // name + email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${profileResponse.firstName ?? ""} ${profileResponse.lastName ?? ""}",
                    style: TextStyle(
                      color: AppColors.blackBold,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profileResponse.email ?? "",
                    style: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 13.5,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            // edit button
            OutlineSmallButton(
              icon: CupertinoIcons.pencil,
              label: 'Edit',
              onTap: () => Get.toNamed('/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- Generic Section Card ----------
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // header
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.blackBold,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        // items
        Container(
          decoration: BoxDecoration(
            color: appTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appTheme.gray200),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(children: children),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

/// ---------- Reusable tiles ----------
class _SettingsTile extends StatelessWidget {
  const _SettingsTile._({
    required this.leadingIcon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final String leadingIcon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Simple nav row
  factory _SettingsTile.navTile({
    required String leadingIcon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return _SettingsTile._(
      leadingIcon: leadingIcon,
      title: title,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: AppColors.blackBold, fontSize: 14),
            ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_right, size: 18),
        ],
      ),
    );
  }

  /// Switch row
  factory _SettingsTile.switchTile({
    required String leadingIcon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _SettingsTile._(
      leadingIcon: leadingIcon,
      title: title,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: appTheme.orangeBase,
        inactiveTrackColor: appTheme.gray200,
      ),
    );
  }

  /// Destructive row (logout)
  factory _SettingsTile.destructive({
    required String leadingIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return _SettingsTile._(
      leadingIcon: leadingIcon,
      title: title,
      onTap: onTap,
      trailing: const Icon(CupertinoIcons.chevron_right, size: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        _LeadingIcon(svgAsset: leadingIcon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: AppColors.blackBold, fontSize: 15),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: row,
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.svgAsset});

  final String? svgAsset; // optional: e.g. 'assets/icons/bell.svg'

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: appTheme.gray200,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        svgAsset!,
        width: 18,
        height: 18,
        // color for mono SVGs; remove if your asset is multicolor
        colorFilter: ColorFilter.mode(appTheme.black, BlendMode.srcIn),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: appTheme.gray200);
  }
}

/// ---------- Small outline button in profile card ----------

/// ---------- Version pill ----------
class _VersionPill extends StatelessWidget {
  const _VersionPill({required this.version});
  final String version;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Version: $version',
        style: TextStyle(fontSize: 14.5, color: AppColors.blackBold),
      ),
    );
  }
}
