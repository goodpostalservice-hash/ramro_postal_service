import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../resource/color.dart';
import '../../../../../resource/string.dart';
import '../../../../../utility/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  String phone = '';
  String playerId = '';
  ForgotPasswordScreen(this.phone, this.playerId, {super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late bool initButton, clicked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initButton = false;
    clicked = false;
    _phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.normalBG,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.blackBold, size: 32.0),
        ),
        backgroundColor: AppColors.normalBG,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            if (clicked == false)
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70.0),
                    Text(AppStrings.enter_your_mobile,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.highlightBlackColor)),
                    dropDownCountry(),
                    if (true == true)
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 5.0, right: 10.0),
                              width: 1.0,
                              height: 30.0,
                              color: AppColors.fieldHint,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: SizedBox(
                                width: 185.0,
                                child: TextFormField(
                                  controller: _otpController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {},
                                  style: TextStyle(
                                      color: AppColors.blackBold,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: '6 digits otp',
                                    hintStyle: TextStyle(
                                        color: AppColors.fieldHint,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            otpVerifyButton()
                          ],
                        ),
                      )
                    else
                      button(),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text(
                            'Please wait. Sometime it takes few minutes to receive otp on your device.',
                            style: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 17.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              )
            else
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40.0),
                    Text("Reset Your Password",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackBold)),
                    const SizedBox(height: 30.0),
                    Container(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 10.0),
                      child: const Text("New Password"),
                    ),
                    TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: _newPasswordController,
                      decoration:
                          passwordInputDecoration('*********', Icons.lock),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 10.0),
                      child: const Text("Confirm Password"),
                    ),
                    TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration:
                          passwordInputDecoration('*********', Icons.lock),
                    ),
                  ],
                ),
              )
          ]),
        ),
      ),
    );
  }

  Widget dropDownCountry() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 20.0, bottom: 25.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: AppColors.borderColor, width: 1.0)),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 7.0, right: 7.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_drop_down, color: AppColors.fieldHint),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5.0, right: 10.0),
            width: 1.0,
            height: 30.0,
            color: AppColors.fieldHint,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SizedBox(
              width: 185.0,
              child: TextFormField(
                controller: _phoneController,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: AppColors.blackBold,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'XXXXXXXXXX',
                  hintStyle: TextStyle(
                      color: AppColors.fieldHint,
                      fontSize: 17.0,
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

  // set otp button
  Widget button() {
    return SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
                color: true ? AppColors.disabledPrimaryBtn : AppColors.primary,
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Send OTP'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))
              ],
            ),
          ),
        ));
  }

  // set verify otp
  Widget otpVerifyButton() {
    return SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
                color: true ? AppColors.disabledPrimaryBtn : AppColors.primary,
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Continue'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))
              ],
            ),
          ),
        ));
  }

  // set change password button
  Widget sendOTPButton() {
    return SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton(
          onPressed: () {},
          child: Container(
            width: double.infinity,
            height: 50.0,
            decoration: BoxDecoration(
                color: true ? AppColors.disabledPrimaryBtn : AppColors.primary,
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Continue'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))
              ],
            ),
          ),
        ));
  }
}
