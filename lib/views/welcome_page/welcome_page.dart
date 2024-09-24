import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jigers_kitchen/utils/app_images.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_keys.dart';
import '../../utils/local_db_helper.dart';
import '../auth/login/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();
  final List<String> _titlesList = [
    'Unmatched Quality',
    'EXCEPTIONAL SERVICE',
    'EASY ORDER',
  ];

  final List<String> _subtitlesList = [
    'We understand that the secret to great food is the quality of the ingredients',
    'Our service team is a source of our pride. They are friendly, professional and always ready to help you with a smile.',
    'We offer online ordering services to make your orders easier.',
  ];

  final List<dynamic> _imageList = [
    AppImages.onBoard1,
    AppImages.onBoard2,
    AppImages.onBoard3,
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemBuilder: (context, index) => getPage(
                _imageList[index],
                _titlesList[index],
                _subtitlesList[index],
                context,
                (index + 1) == _imageList.length),
            controller: pageController,
            itemCount: _imageList.length,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
              right: 13,
              bottom: 17,
              child: InkWell(
                  onTap: () {
                    SharedPref.getInstance()
                        .addBoolToSF(AppKeys.isFirstTime, false);
                    _currentIndex != 2
                        ? pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceInOut)
                        : Get.off(() => const LoginScreen());
                  },
                  child: Text(
                    _currentIndex == 2 ? "Skip >" : "Next >",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.lightBlue,
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget getPage(dynamic image, titlesList, subtitlesList, BuildContext context,
      bool isLastPage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: AppColors.textGreyColor,
          radius: 70,
          child: SizedBox(height: 80, child: Image.asset(image)),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          titlesList.toString().toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 35, left: 35, top: 15),
            child: Text(
              subtitlesList,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.greyColor,
                height: 2,
                letterSpacing: 1.2,
              ),
            )),
      ],
    );
  }
}
