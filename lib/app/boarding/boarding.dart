import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mymosque/constant/colorConfig.dart';

class Boarding extends StatefulWidget {
  const Boarding({Key? key}) : super(key: key);
  _BoardingState createState() => _BoardingState();
}

class _BoardingState extends State<Boarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'الصفحة الرنيسية',
              body:
                  'في هذه الصفحة يمكنك ادخال برنامج الصلاة و العبادات. بالاضافة اى النشطات اخرى. ورؤية مجموعك اليومي و الاسبوعي في اعلىها !',
              image: buildImage("assets/images/main.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'صفحة التصنيف',
              body:
                  'في هذه الصفحة يمكن مشاهدة ترتيبك و متابعة تقدمك بين الاخرين.',
              image: buildImage("assets/images/rank.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'صفحة المقارنة و المنافسة',
              body:
                  'في صفحة التصنيف يمكنك النقر على اي اسم مستخدم اخر، لتتابع تقدمك و تقدمه في هذا الاسبوع!',
              image: buildImage("assets/images/compare.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'صفحة معلوماتي',
              body:
                  'في هذه الصفحة يمكنك مشاهدة تقدمك اليومي خلال الاسبوع، مع ايمكانية تعديل معلوماتك الشخصية.',
              image: buildImage("assets/images/profile.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () {
            if (kDebugMode) {
              print("Done clicked");
            }
            Navigator.of(context)
                .pushNamedAndRemoveUntil("initialScreen", (route) => false);
          },
          //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: true,
          isBottomSafeArea: true,
          skip: const Text("تخطي",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: buttonColor)),
          next: const Icon(
            Icons.forward,
            color: buttonColor,
          ),
          done: const Text("تم",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: buttonColor)),
          dotsDecorator: getDotsDecorator()),
    );
  }

  //widget to add the image on screen
  Widget buildImage(String imagePath) {
    return Container(
        child: Image.asset(
      imagePath,
      width: 300,
      height: 1000,
      // fit: BoxFit.fitHeight,
    ));
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imageFlex: 6,
      bodyFlex: 2,
      imagePadding: EdgeInsets.only(top: 60),
      pageColor: backgroundColor,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 10),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: buttonColor2,
      color: backgroundColor,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
