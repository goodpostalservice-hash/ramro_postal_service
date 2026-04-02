import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_export.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/screen/common/init/opt/screen/otp.dart';

class RegisterScreen extends StatefulWidget {
  static String phone = '';

  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool showPassword = false;

  final formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String? genderType,
      emailPlayerId,
      modelName,
      deviceId,
      manufacture,
      operating_system;

  late bool initButton;

  int userTypeId = 1;

  int id = 1;

  // image
  var _pickedFile;
  late String filePath, fileName = "", paymentMethod;
  String? select, image;

  @override
  void initState() {
    super.initState();
    initButton = false;
    _handleGetDeviceState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray25,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getHorizontalSize(16)),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBackButton(context),
                Text(
                  'Create Your Account',
                  style: CustomTextStyles.headlineMedium_32_600,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Enter full name',
                    style: CustomTextStyles.bodyMediumBlack1000_14_500,
                  ),
                ),
                formWidget(),
                const SizedBox(height: 15.0),
                submitWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleGetDeviceState() async {
    var status = OneSignal.User.pushSubscription.id;
    if (status == null) return;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    setState(() {
      emailPlayerId = status;
      modelName = androidInfo.model;
    });
    print('Running on ${androidInfo.model}');

    print("Email Player Id: $emailPlayerId");
    print("Modal Name: $modelName");

    // get all data of mobile
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.',
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      deviceId = _deviceData['androidId'];
      manufacture = _deviceData['manufacturer'];
      operating_system = _deviceData['version.sdkInt'].toString();
    });

    print("Device Data: $_deviceData");
    print("Device Id: $deviceId");
    print("Manufacture: $manufacture");
    print("Operating System: $operating_system");
  }

  Widget formWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextFormField(
          controller: _firstNameController,
          hint: 'First name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your first name.";
            }
            return null;
          },
        ),
        CustomTextFormField(
          controller: _lastNameController,
          hint: 'Last name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your last name.";
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Enter your email',
            style: CustomTextStyles.bodyMediumBlack1000_14_500,
          ),
        ),
        CustomTextFormField(
          controller: _emailController,
          hint: 'Enter your email address',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your email.";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget submitWidget() {
    return ElevatedButton(
      onPressed: () {
        var myJSON = {
          "first_name": _firstNameController.text.toString(),
          "last_name": _lastNameController.text.toString(),
          "email": _emailController.text.toString(),
          "phone": "977${_phoneController.text.toString()}",
        };
        if (formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });
          registerUser(myJSON);
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: appTheme.orangeBase),
      child: Container(
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
          color: appTheme.orangeBase,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isLoading
                  ? 'Please wait'.toUpperCase()
                  : 'Register Account'.toUpperCase(),
              style: CustomTextStyles.bodyLargeGray_16_500,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.id,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  // register user form
  void registerUser(var sendJSON) async {
    var userDetail = await sendJSON;

    print(userDetail.toString());

    var dio = Dio();

    final response = await dio
        .post(
          ApiConstant.user,
          options: Options(headers: {'Accept': 'application/json'}),
          data: FormData.fromMap(userDetail),
        )
        .catchError((error, stackTrace) {
          setState(() {
            isLoading = false;
          });
          showErrorMessage('Something went wrong while registering.');
        });

    final responseData = response.data;
    if (response.statusCode == 200) {
      setState(() {
        if (responseData['success'] == true) {
          isLoading = false;
          OTPScreen.phone = userDetail['phone'];
          showSuccessMessage(responseData['message'].toString());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OTPScreen()),
          );
        } else {
          setState(() {
            isLoading = false;
          });

          String? firstError;
          for (var key in responseData.keys) {
            if (responseData[key] is List && responseData[key].isNotEmpty) {
              firstError = responseData[key][0]; // Get the first error message
              break;
            }
          }
          if (firstError != null) {
            showErrorMessage(firstError.toString());
          }
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorMessage(responseData['message'].toString());
    }
  }
}
