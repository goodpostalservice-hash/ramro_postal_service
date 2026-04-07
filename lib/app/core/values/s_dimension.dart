import 'package:get/get.dart';

class SDimension {
  // Private constructor
  SDimension._();

  // Common spacing
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 28.0;
  static const double jumbo = 32.0;
  static const double giant = 36.0;
  static const double colossal = 40.0;
  static const double mega = 44.0;
  static const double superSize = 48.0;
  static const double ultra = 52.0;
  static const double hyper = 56.0;
  static const double epic = 60.0;

  static const double logoSize = 60.0;
}

class Dimension {
  //Dynamic size values
  static double screenHeight = Get.context!.height;
  static double screenwidth = Get.context!.width;

  //Custom height & width for various components
  static double height64 = screenHeight / 14.01;
  static double height100 = screenHeight / 8.97;
  static double height12 = screenHeight / 74.75;
  static double height25 = screenHeight / 35.88;
  static double height170 = screenHeight / 5.27;
  static double height110 = screenHeight / 8.15;
  static double height70 = screenHeight / 12.81;
  static double carasoul250 = screenHeight / 3.588;
  static double height55 = screenHeight / 16.30;
  static double height95 = screenHeight / 9.44;
  static double height8 = screenHeight / 112.125;
  static double height280 = screenHeight / 3.20;
  static double height80 = screenHeight / 11.21;
  static double height180 = screenHeight / 4.98;

  static double height150 = screenHeight / 8.98;
  static double height60 = screenHeight / 14.95;
  static double height200 = screenHeight / 4.485;
  static double height188 = screenHeight / 4.77;
  static double height230 = screenHeight / 3.9;
  static double height22 = screenHeight / 40.77;
  static double height35 = screenHeight / 25.62;
  static double height300 = screenHeight / 2.99;
  static double height340 = screenHeight / 2.63;
  static double height350 = screenHeight / 2.56;
  static double height380 = screenHeight / 2.36;
  static double height500 = screenHeight / 1.794;
  static double height400 = screenHeight / 2.242;
  static double height450 = screenHeight / 1.99;
  static double height600 = screenHeight / 1.49;

  //for dynamic height
  static double height5 = screenHeight / 179.4;
  static double height10 = screenHeight / 89.7;
  static double height15 = screenHeight / 59.8;
  static double height20 = screenHeight / 44.85;
  static double height30 = screenHeight / 29.9;
  static double height40 = screenHeight / 22.45;
  static double height45 = screenHeight / 19.9;
  static double height50 = screenHeight / 17.94;

  //for dynamic width also Padding & margin
  static double width5 = screenHeight / 179.4;
  static double width10 = screenHeight / 89.7;
  static double width15 = screenHeight / 59.8;
  static double width20 = screenHeight / 44.85;
  static double width30 = screenHeight / 29.9;
  static double width40 = screenHeight / 22.45;
  static double width45 = screenHeight / 19.9;
  static double width270 = screenwidth / 1.83;

  //for dynamic font
  static double font16 = screenHeight / 56.13;
  static double font20 = screenHeight / 44.24;
  static double font26 = screenHeight / 34.31;
  static double font18 = screenHeight / 49.83;
  static double font32 = screenHeight / 28.0;
  static double font14 = screenHeight / 64.0;
  static double font12 = screenHeight / 74.08;
  static double font10 = screenHeight / 88.9;
  static double font30 = screenHeight / 29.9;

  //for dynamic radius
  static double radius5 = screenHeight / 179.74;
  static double radius10 = screenHeight / 89.7;
  static double radius15 = screenHeight / 59.74;

  static double radius20 = screenHeight / 44.81;
  static double radius25 = screenHeight / 35.88;
  static double radius30 = screenHeight / 29.9;
  static double radius50 = screenHeight / 17.94;

  //for dynamic icon

  static double icon16 = screenHeight / 56.13;
  static double icon22 = screenHeight / 40.77;
  static double icon24 = screenHeight / 37.37;
  static double icon32 = screenHeight / 28.03;

  //For logo
  static double logoHeight132 = screenHeight / 6.63;
  static double logoWidth132 = screenHeight / 3.11;
  static double logoforUI = screenHeight / 11.21;

  //Button
  static double buttonWidth = screenHeight / 2.36;
  static double buttonHeight = screenHeight / 16.61;

  static double heightA = screenHeight / 4.485;
  static double widthB = screenHeight / 3.588;

  static double heigght45 = screenHeight / 19.33;
}

class Applength {
  static const double height64 = 64;
}

mixin AppDimens {
  static const tiny = 12.0;
  static const mini = 14.0;
  static const small = 15.0;
  static const normal = 17.0;
  static const medium = 20.0;
  static const large = 22.0;
  static const big = 24.0;
}
