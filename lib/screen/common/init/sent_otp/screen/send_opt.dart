import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../resource/color.dart';
import '../../../../../resource/string.dart';

class SendOTPScreen extends StatefulWidget {
  String country_code, phone, verifier;
  SendOTPScreen(this.country_code, this.phone, this.verifier, {super.key});

  @override
  _SendOTPScreenState createState() => _SendOTPScreenState();
}

class _SendOTPScreenState extends State<SendOTPScreen> {
  final formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  late bool initButton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initButton = false;
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
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70.0),
                Text(
                  AppStrings.enter_your_password,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.highlightBlackColor,
                  ),
                ),

                phoneWidget(),

                submitWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget phoneWidget() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 20.0, bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.borderColor, width: 1.0),
      ),
      child: TextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(30)],
        keyboardType: TextInputType.text,
        controller: _phoneController,
        obscureText: false,
        style: TextStyle(
          color: AppColors.blackBold,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget submitWidget() {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: () {},
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            color: true ? AppColors.primary : AppColors.disabledPrimaryBtn,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign In'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
