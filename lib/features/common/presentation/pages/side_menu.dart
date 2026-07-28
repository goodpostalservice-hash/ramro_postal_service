// lib/screen/menu/view/menu_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';
import 'package:ramro_postal_service/core/storage/storage_util.dart';
import 'package:ramro_postal_service/core/widgets/outline_small_button.dart';
import 'package:ramro_postal_service/routes/app_routes.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../controllers/common_controller.dart'; // for AppConstant, routes, etc.

class MenuScreen extends GetView<CommonController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.sm + AppSpacing.xxs,
              ),
              child: Column(
                children: [
                  _ProfileCard(),
                  AppSpacing.gapMd,

                  // Preferences section
                  _SectionCard(
                    title: 'Preferences',
                    children: [
                      Obx(
                        () => _SettingsTile.switchTile(
                          leadingIcon: Assets.notification,
                          title: 'Notifications and sounds',
                          value: controller.notifEnabled.value,
                          onChanged: (v) => controller.notifEnabled.value = v,
                        ),
                      ),
                      const _DividerLine(),
                      Obx(
                        () => _SettingsTile.switchTile(
                          leadingIcon: Assets.location,
                          title: 'Location',
                          value: controller.locationEnabled.value,
                          onChanged: (v) =>
                              controller.locationEnabled.value = v,
                        ),
                      ),
                      const _DividerLine(),
                      // _SettingsTile.navTile(
                      //   leadingIcon: Assets.language,
                      //   title: 'Language',
                      //   trailingText: 'English',
                      //   onTap: () {},
                      // ),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.orderHistory,
                        title: 'My QR',
                        onTap: () {
                          Get.toNamed(AppRoutes.qr);
                        },
                      ),
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.language,
                        title: 'Available Packages',
                        onTap: () {
                          Get.toNamed(AppRoutes.getPackage);
                        },
                      ),

                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.wallet,
                        title: 'Wallet',
                        onTap: () {
                          Get.toNamed(AppRoutes.wallet);
                        },
                      ),
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.subscription,
                        title: 'My Subscription',
                        onTap: () {
                          Get.toNamed(AppRoutes.subscription);
                        },
                      ),

                      if (SStorageUtil.getUserData()?.userType == 'driver') ...[
                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Earning Dashboard',
                          onTap: () {
                            Get.toNamed(AppRoutes.earning);
                          },
                        ),

                        const _DividerLine(),
                        _SettingsTile.navTile(
                          leadingIcon: Assets.language,
                          title: 'Available orders',
                          onTap: () {
                            Get.toNamed(AppRoutes.availableOrders);
                          },
                        ),
                      ],
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.orderHistory,
                        title: 'Order History',
                        onTap: () {
                          Get.toNamed(AppRoutes.ordersHistory);
                        },
                      ),
                      const _DividerLine(),
                      _SettingsTile.navTile(
                        leadingIcon: Assets.addMissingPlace,
                        title: 'Add missing place',
                        onTap: () => Get.toNamed(AppRoutes.addAddress),
                      ),
                    ],
                  ),
                  AppSpacing.gapMd,

                  // Account section
                  _SectionCard(
                    title: 'Account',
                    children: [
                      _SettingsTile.navTile(
                        leadingIcon: Assets.support,
                        title: 'Settings',
                        onTap: () => Get.toNamed(AppRoutes.settings),
                      ),
                      // const _DividerLine(),
                      // _SettingsTile.navTile(
                      //   leadingIcon: Assets.terms,
                      //   title: 'Terms and privacy policy',
                      //   onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                      // ),
                      const _DividerLine(),
                      _SettingsTile.destructive(
                        leadingIcon: Assets.logout,
                        title: 'Logout',
                        onTap: () async {
                          showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),

                  AppSpacing.gapMd,
                  _VersionPill(version: '1.0.0'),
                  AppSpacing.gapXxxl,
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
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final UserData? profileResponse = SStorageUtil.getUserData();
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.profile);
      },
      child: Container(
        padding: AppSpacing.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: appTheme.white,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: appTheme.gray200),
        ),
        child: Row(
          children: [
            // avatar
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: CachedNetworkImage(
                  height: AppSizes.avatarXl - AppSpacing.sm,
                  width: AppSizes.avatarXl - AppSpacing.sm,
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                  placeholder: (_, __) => Image.asset(
                    AppAssets.bannersIcAppCardPlaceholder,
                    height: AppSizes.avatarXl - AppSpacing.sm,
                    width: AppSizes.avatarXl - AppSpacing.sm,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (_, __, ___) => Image.asset(
                    AppAssets.bannersIcAppCardPlaceholder,
                    height: AppSizes.avatarXl - AppSpacing.sm,
                    width: AppSizes.avatarXl - AppSpacing.sm,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalGapMd,
            // name + email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileResponse?.name ?? "",
                    style: TextStyle(
                      color: appTheme.black,
                      fontWeight: FontWeight.w700,
                      fontSize: AppTheme.light.textTheme.bodyLarge?.fontSize,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    profileResponse?.email ?? "",
                    style: TextStyle(
                      color: appTheme.gray700,
                      fontSize: AppTheme.light.textTheme.bodySmall?.fontSize,
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
          padding: AppSpacing.only(
            left: AppSpacing.md + AppSpacing.xxs,
            top: AppSpacing.md + AppSpacing.xxs,
            right: AppSpacing.md + AppSpacing.xxs,
            bottom: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: appTheme.black,
                    fontWeight: FontWeight.w700,
                    fontSize: AppTheme.light.textTheme.bodyLarge?.fontSize,
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
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: appTheme.gray200),
          ),
          child: Padding(
            padding: AppSpacing.symmetric(
              horizontal: AppSpacing.xs + AppSpacing.xxs,
            ),
            child: Column(children: children),
          ),
        ),
        AppSpacing.gapSm,
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
            Text(trailingText, style: CustomTextStyles.bodyMediumBlack14_400),
          AppSpacing.horizontalGapSm,
          const Icon(CupertinoIcons.chevron_right, size: AppSizes.iconMd),
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
        AppSpacing.horizontalGapMd,
        Expanded(
          child: Text(title, style: CustomTextStyles.bodyMediumBlack14_400),
        ),
        if (trailing != null) trailing!,
      ],
    );

    return InkWell(
      borderRadius: AppRadius.cardRadius,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
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
      width: AppSpacing.giant,
      height: AppSpacing.giant,
      decoration: BoxDecoration(
        color: appTheme.gray200,
        borderRadius: AppRadius.cardRadius,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        svgAsset!,
        width: AppSizes.iconMd,
        height: AppSizes.iconMd,
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
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.md + AppSpacing.xxs,
        vertical: AppSpacing.sm + AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: appTheme.white,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: appTheme.gray200),
      ),
      child: Text(
        'Version: $version',
        style: CustomTextStyles.bodyMediumBlack14_400,
      ),
    );
  }
}
