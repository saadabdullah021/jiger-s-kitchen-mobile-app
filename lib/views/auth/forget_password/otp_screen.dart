import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/widget/app_button.dart';
import 'package:jigers_kitchen/views/auth/forget_password/forget_password_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/widget/app_bar.dart';

class EnterOtpScreen extends StatefulWidget {
  String? email;
  EnterOtpScreen({super.key, this.email});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final ForgetPasswordController _con = Get.put(ForgetPasswordController());

  @override
  void initState() {
    _con.email = widget.email ?? "";
    super.initState();
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _con.timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar(text: "Enter OTP"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.08,
                ),
                Image.asset(
                  "assets/images/otp.png",
                  height: 200,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  "OTP Verification",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.jetBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: "Your OTP code is sent to ${_con.email}.",
                        style: TextStyle(
                            color: AppColors.jetBlackColor, fontSize: 15),
                        children: const <TextSpan>[
                          TextSpan(
                            text: " ",
                          ),
                          // TextSpan(
                          //     text: _con.email.value,
                          //     style: TextStyle(
                          //         color: AppColors.jetBlackColor,
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.bold))
                        ]),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      length: 5,
                      appContext: context,
                      keyboardType: TextInputType.phone,
                      backgroundColor: Colors.transparent,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 50,
                          activeColor: AppColors.primaryColor,
                          activeFillColor: Colors.grey.shade100,
                          selectedFillColor: Colors.transparent,
                          selectedColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey.shade600,
                          inactiveFillColor: Colors.transparent),
                      enableActiveFill: true,
                      onCompleted: (v) {
                        _con.OTP = v;
                      },
                      onChanged: (value) {
                        _con.OTP = value;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                    text: "Verify OTP",
                    onPressed: () {
                      _con.verifyOtp();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
