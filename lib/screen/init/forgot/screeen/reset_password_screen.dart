import 'package:flutter/material.dart';
import '../../../../resource/color.dart';

class ResetPasswordScreen extends StatefulWidget {
  String phone = '';
  String player_id = '';

  ResetPasswordScreen(this.phone, this.player_id, {super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _passswordController = TextEditingController();
  final TextEditingController _cpassswordController = TextEditingController();

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
        title: Text('Reset Password', style: TextStyle(color: AppColors.blackBold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[

                // new password
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: AppColors.borderColor, width: 1.0)
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: SizedBox(
                          width: 185.0,
                          child: TextFormField(
                            controller: _passswordController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: AppColors.blackBold, fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'New Password',
                              hintStyle: TextStyle(color: AppColors.fieldHint, fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // confirm password
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 10.0, bottom: 45.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: AppColors.borderColor, width: 1.0)
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: SizedBox(
                          width: 185.0,
                          child: TextFormField(
                            controller: _cpassswordController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: AppColors.blackBold, fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(color: AppColors.fieldHint, fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // reset password
                ElevatedButton(
                  onPressed: () {
                    // change_password(context);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                        // color: isLoading ? AppColors.disabledPrimaryBtn : AppColors.primary,
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Reset Password'.toUpperCase(), style: const TextStyle(fontSize: 15.0,
                            fontWeight: FontWeight.normal, color: Colors.white))
                      ],
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