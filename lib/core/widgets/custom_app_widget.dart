import 'package:flutter/material.dart';
import 'package:ramro_postal_service/core/constants/app_exports.dart';

TextStyle tableHeader() {
  return TextStyle(
    color: appTheme.black,
    fontSize: AppTheme.light.textTheme.bodySmall?.fontSize,
    fontWeight: FontWeight.bold,
  );
}

TextStyle contentHeader() {
  return TextStyle(
    color: appTheme.black,
    fontSize: AppTheme.light.textTheme.bodySmall?.fontSize,
    fontWeight: FontWeight.w400,
  );
}

Container header(String header) {
  return Container(
    width: double.infinity,
    padding: AppSpacing.symmetric(vertical: AppSpacing.xl),
    child: Text(
      header,
      style: TextStyle(
        color: appTheme.white,
        fontSize: AppTheme.light.textTheme.titleMedium?.fontSize,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    ),
  );
}

Container darkHeader(String header) {
  return Container(
    width: double.infinity,
    padding: AppSpacing.symmetric(vertical: AppSpacing.xl),
    child: Text(
      header,
      style: TextStyle(
        color: appTheme.black,
        fontSize: AppTheme.light.textTheme.titleMedium?.fontSize,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    ),
  );
}

// TODO Bottom navigation screens appbar
AppBar titleAppBar(String title) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Text(
      title,
      style: TextStyle(
        color: appTheme.white,
        fontSize: AppTheme.light.textTheme.titleMedium?.fontSize,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

AppBar backAppBar(String title, BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: appTheme.gray25,
    automaticallyImplyLeading: true,
    centerTitle: true,
    leadingWidth: AppSizes.avatarXl,
    leading: Padding(
      padding: AppSpacing.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Material(
        color: appTheme.gray50,
        borderRadius: AppRadius.cardRadius,
        child: InkWell(
          borderRadius: AppRadius.cardRadius,
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            width: AppSpacing.colossal,
            height: AppSpacing.colossal,
            child: Icon(Icons.arrow_back, color: appTheme.black),
          ),
        ),
      ),
    ),
    title: Text(
      title,
      style: CustomTextStyles.titleLargeBlack20_500.copyWith(
        fontSize: getFontSize(20),
      ),
    ),
  );
}
