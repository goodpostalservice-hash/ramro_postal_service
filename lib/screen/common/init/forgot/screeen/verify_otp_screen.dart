import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../resource/color.dart';
import 'reset_password_screen.dart';

class VerifyOPTScreen extends StatefulWidget {
  String phone = '';
  String player_id = '';
  VerifyOPTScreen(this.phone, this.player_id, {super.key});

  @override
  _VerifyOPTScreenState createState() => _VerifyOPTScreenState();
}

class _VerifyOPTScreenState extends State<VerifyOPTScreen> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

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
        title: Text('Verify OTP', style: TextStyle(color: AppColors.blackBold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70.0),
                Text(
                  "Enter Your OTP",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.highlightBlackColor,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 20.0, bottom: 25.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: AppColors.borderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: SizedBox(
                          width: 185.0,
                          child: TextFormField(
                            controller: _otpController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6),
                            ],
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: AppColors.blackBold,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: '6 digits code',
                              hintStyle: TextStyle(
                                color: AppColors.fieldHint,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResetPasswordScreen(widget.phone, widget.player_id),
                      ),
                    );
                    // verify_opt(context, widget.phone, _otpController.text.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: isLoading
                          ? AppColors.disabledPrimaryBtn
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Verify OTP'.toUpperCase(),
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

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text(
                      'Having trouble with your opt verification. Contact administration for support.',
                      style: TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
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
}
