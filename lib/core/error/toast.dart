import 'package:fluttertoast/fluttertoast.dart';
import 'package:ramro_postal_service/core/design_system/design_system.dart';

showSuccessMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: AppSemanticColors.light.success,
    textColor: appTheme.white,
    fontSize: AppSizes.toastFontSize,
  );
}

showErrorMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: appTheme.errorColor,
    textColor: appTheme.white,
    fontSize: AppSizes.toastFontSize,
  );
}

showErrorLongMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: appTheme.errorColor,
    textColor: appTheme.white,
    fontSize: AppSizes.toastFontSize,
  );
}
