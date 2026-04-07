import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../resource/color.dart';
import '../../../../../resource/string.dart';
import 'verify_otp_screen.dart';

class SendOPTScreen extends StatefulWidget {
  String phone = '';
  String playerId = '';
  SendOPTScreen(this.phone, this.playerId, {super.key});

  @override
  _SendOPTScreenState createState() => _SendOPTScreenState();
}

class _SendOPTScreenState extends State<SendOPTScreen> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _phoneController.text = widget.phone.toString();
    });
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
        title: Text('Send OTP', style: TextStyle(color: AppColors.blackBold)),
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
                  AppStrings.enter_your_mobile,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.highlightBlackColor,
                  ),
                ),

                dropDownCountry(),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VerifyOPTScreen(widget.phone, widget.playerId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      // color: isLoading ? AppColors.disabledPrimaryBtn : AppColors.primary,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Send OTP'.toUpperCase(),
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
                      'Please wait. Sometime it takes few minutes to receive otp on your device.',
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

  /// widgets
  Widget dropDownCountry() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 20.0, bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: AppColors.borderColor, width: 1.0),
      ),
      child: Row(
        children: <Widget>[
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
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'XXXXXXXXXX',
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
    );
  }
}
