import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../resource/color.dart';
import '../../../../../../resource/string.dart';
import '../../controller/password_controller.dart';

class PasswordScreen extends GetView<PasswordController> {
  static String phone = '';
  final formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Map<String, dynamic> _deviceData = <String, dynamic>{};
  String? genderType, emailPlayerId = "082927238", modelName, deviceId, manufacture, operating_system;

  PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.normalBG,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.toNamed('/login'),
          icon: Icon(Icons.arrow_back, color: AppColors.blackBold, size: 28.0),
        ),
        backgroundColor: AppColors.normalBG,
        centerTitle: true,
        title: Text('Continue to Login'.toUpperCase(), style: const TextStyle(
          color: Colors.black87, fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                Text(AppStrings.enter_your_password, style: TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.highlightBlackColor
                )),

                passwordWidget(),

                submitWidget(),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/sendForgetOTP');
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                      child: Text('Forgot password?', style: TextStyle(color: AppColors.blackBold, fontSize: 16.0, fontStyle: FontStyle.italic)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // void _handleGetDeviceState() async {
  //   var status = await OneSignal.shared.getDeviceState();
  //   if (status == null || status.userId == null)
  //     return;
  //
  //
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //
  //   setState(() {
  //     emailPlayerId = status.userId!;
  //     modelName = androidInfo.model!;
  //   });
  //   print('Running on ${androidInfo.model}');
  //
  //   print("Email Player Id: " + emailPlayerId.toString());
  //   print("Modal Name: " + modelName.toString());
  //
  //   // get all data of mobile
  //   initPlatformState();
  // }
  //
  // Future<void> initPlatformState() async {
  //   var deviceData = <String, dynamic>{};
  //
  //   try {
  //     if (Platform.isAndroid) {
  //       deviceData =
  //           _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     } else if (Platform.isIOS) {
  //       deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
  //     }
  //   } on PlatformException {
  //     deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }
  //
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _deviceData = deviceData;
  //     deviceId = _deviceData['androidId'];
  //     manufacture = _deviceData['manufacturer'];
  //     operating_system = _deviceData['version.sdkInt'].toString();
  //   });
  //
  //   print("Device Data: " + _deviceData.toString());
  //   print("Device Id: " + deviceId.toString());
  //   print("Manufacture: " + manufacture.toString());
  //   print("Operating System: " + operating_system.toString());
  // }

  Widget passwordWidget() {
    return Obx(() => Container(
      height: 55.0,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 20.0, bottom: 25.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.borderColor, width: 1.0)
      ),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        keyboardType: TextInputType.text,
        controller: _passwordController,
        obscureText: controller.isPasswordVisible.value,
        style: TextStyle(color: AppColors.blackBold, fontSize: 17.0,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            isDense: true,
            hintText: 'XXXXXXXXXX',
            hintStyle: TextStyle(color: AppColors.fieldHint, fontSize: 17.0,
                fontWeight: FontWeight.bold),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () {
                if (controller.isPasswordVisible.value == false) {
                  controller.isPasswordVisible.value = true;
                } else {
                  controller.isPasswordVisible.value = false;
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: controller.isPasswordVisible.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
            )
        ),
      ),
    ));
  }

  Widget submitWidget() {
    return Obx(() => ElevatedButton(
      onPressed: () {
        if (_passwordController.text.isNotEmpty) {
          controller.checkPasswordField(phone, _passwordController.text.toString());
        }
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.isToLoadMore.value ? AppColors.disabledPrimaryBtn : AppColors.primary,
      ),
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(controller.isToLoadMore.value ? 'Please wait'.toUpperCase() : 'Sign In'.toUpperCase(), style: const TextStyle(fontSize: 15.0,
                fontWeight: FontWeight.normal, color: Colors.white))
          ],
        ),
      ),
    ));
  }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'androidId': build.androidId,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }
  //
  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'systemName': data.systemName,
  //     'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     'utsname.sysname:': data.utsname.sysname,
  //     'utsname.nodename:': data.utsname.nodename,
  //     'utsname.release:': data.utsname.release,
  //     'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }
}