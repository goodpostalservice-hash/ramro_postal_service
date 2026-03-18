import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../../core/error/toast.dart';
import '../../../../../../../resource/color.dart';
import '../../../../../../../resource/data.dart';
import '../../controller/send_otp_controller.dart';

class SendForgetOTPScreen extends GetView<SendOTPController> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  SendForgetOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.normalBG,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.blackBold, size: 28.0),
        ),
        backgroundColor: AppColors.normalBG,
        centerTitle: true,
        title: Image.asset("assets/icons/logo.png", width: 160.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                const SizedBox(height: 40.0),

                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                  child: const Text('Hello user, please enter your mobile number to receive an otp', style: TextStyle(
                      color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.normal
                  ), textAlign: TextAlign.center,),
                ),

                dropDownCountry(),

                button(),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDownCountry() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.borderColor, width: 1.0)
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 7.0, right: 7.0),
            child: Row(
              children: <Widget>[
                Image.asset(ListData.countryList[0]['flag'].toString(), height: 30.0),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5.0, right: 10.0),
            width: 1.0,
            height: 30.0,
            color: AppColors.fieldHint,
          ),
          Text(ListData.countryList[0]['country_code'].toString(), style: TextStyle(
              color: AppColors.blackBold, fontSize: 17.0, fontWeight: FontWeight.bold
          )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SizedBox(
              width: 185.0,
              child: TextFormField(
                controller: _phoneController,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 10) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                style: TextStyle(color: AppColors.blackBold, fontSize: 17.0,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'XXXXXXXXXX',
                  hintStyle: TextStyle(color: AppColors.fieldHint, fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Obx(() => ElevatedButton(
      onPressed: () {
        controller.isToLoadMore.value = true;
        if (_phoneController.text.length == 10) {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordScreen()));
          // controller.loadProductData('977${_phoneController.text}');
          controller.requestForgetPassword(_phoneController.text);
          // controller.loadProductData('9779811811888');
        } else {
          showErrorMessage('Invalid phone number');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.isToLoadMore.value ? AppColors.disabledPrimaryBtn : AppColors.primary,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        // decoration: BoxDecoration(
        //     color: controller.isToLoadMore() ? AppColors.disabledPrimaryBtn : AppColors.primary,
        //     borderRadius: BorderRadius.circular(5.0)
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(controller.isToLoadMore.value ? 'Please wait'.toUpperCase() : 'Send OTP'.toUpperCase(), style: const TextStyle(fontSize: 15.0,
                fontWeight: FontWeight.normal, color: Colors.white))
          ],
        ),
      ),
    ));
  }

  Widget continueWithFacebook() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.facebookBtn,
      ),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        margin: const EdgeInsets.all(0.0),
        height: 50.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 25.0),
              child: Icon(Icons.facebook_sharp, color: Colors.white, size: 38.0),
            ),
            SizedBox(width: 20.0),
            Text('Continue with Facebook', style:
            TextStyle(fontSize: 16.0, fontWeight:
            FontWeight.bold, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Future<void> delayFunction() async {
    print('Started');
    await Future.delayed(const Duration(seconds: 2));
    controller.isToLoadMore.value = false;
    print('Ended');
  }
}
