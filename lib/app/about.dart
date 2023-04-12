import 'package:flutter/material.dart';
import 'package:mymosque/constant/colorConfig.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Testimonial> testimonials = [
      Testimonial('John Smith',
          'I have been using Product A for the past year and I am extremely satisfied with it. The customer support is excellent and the product itself is top-quality. I highly recommend it to anyone in need of a reliable and efficient solution.'),
      Testimonial('Jane Doe',
          'I was skeptical about Product B at first, but after using it for a few weeks I am pleasantly surprised. It is easy to use and customize, and it has saved me a lot of time and effort. I will definitely be using it again in the future.'),
      Testimonial('Bob Johnson',
          'Product C exceeded my expectations. Not only is it energy efficient, but it is also environmentally friendly. I feel good about using it and will be recommending it to my friends and family.'),
    ];

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: buttonColor,
              centerTitle: true,
              title: Text('من نحن'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "initialScreen", (route) => false);
                  },
                  icon: Icon(Icons.exit_to_app),
                  tooltip: 'تسجيل خروج',
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  //Name and Logo
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Text(
                          'قام بالبرمجة حسام الدين الجمال',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: const Offset(
                                  3.0,
                                  3.0,
                                ), //Offset
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/HusApps_trans.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //brief summary
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(8),
                    child:
                        //  Text(
                        //   'تقدم شركتنا مجموعة واسعة من المنتجات والخدمات عالية الجودة لتلبية احتياجات عملائنا.',
                        //   style: Theme.of(context).textTheme.bodyText2,
                        // ),
                        Text(
                      'صدقة جارية على روح النبي صلى الله عليه و سلم و من جنابه الى روح امي و ابي و جميع اموات المسلمين. بسر سورة الفاتحة !',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),

                  // //statement and values
                  // Container(
                  //     width: screenWidth,
                  //     padding: EdgeInsets.all(8),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Mission Statement:',
                  //           style: Theme.of(context).textTheme.headline6,
                  //         ),
                  //         SizedBox(height: 8),
                  //         Text(
                  //           'Our mission is to provide high-quality products and services to our customers.',
                  //           style: Theme.of(context).textTheme.bodyText2,
                  //         ),
                  //         SizedBox(height: 16),
                  //         Text(
                  //           'Values:',
                  //           style: Theme.of(context).textTheme.headline6,
                  //         ),
                  //         SizedBox(height: 8),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text(
                  //               'Customer satisfaction is our top priority'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('We strive for continuous improvement'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text(
                  //               'We value honesty and integrity in all our actions'),
                  //         ),
                  //       ],
                  //     )),

                  // //History and background
                  // Container(
                  //     width: screenWidth,
                  //     padding: EdgeInsets.all(8),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'History:',
                  //           style: Theme.of(context).textTheme.headline6,
                  //         ),
                  //         SizedBox(height: 8),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('Founded in 2010'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text(
                  //               'Started as a small business with a few employees'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text(
                  //               'Grown into a successful and well-respected organization'),
                  //         ),
                  //       ],
                  //     )),

                  // //products or service
                  // Container(
                  //     width: screenWidth,
                  //     padding: EdgeInsets.all(8),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Products:',
                  //           style: Theme.of(context).textTheme.headline6,
                  //         ),
                  //         SizedBox(height: 8),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('Product A: High-quality and durable'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('Product B: Easy to use and customize'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text(
                  //               'Product C: Energy efficient and environmentally friendly'),
                  //         ),
                  //       ],
                  //     )),

                  // //awards
                  // Container(
                  //     width: screenWidth,
                  //     padding: EdgeInsets.all(8),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Awards:',
                  //           style: Theme.of(context).textTheme.headline6,
                  //         ),
                  //         SizedBox(height: 8),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('Best Product Award 2020'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('Innovation of the Year 2021'),
                  //         ),
                  //         ListTile(
                  //           leading: Icon(Icons.check),
                  //           title: Text('Customer Satisfaction Award 2022'),
                  //         ),
                  //       ],
                  //     )),

                  // //Testimonials or reviews
                  // Container(
                  //   width: screenWidth,
                  //   padding: EdgeInsets.all(8),
                  //   child: Text(
                  //     'Testimonials:',
                  //     style: Theme.of(context).textTheme.headline6,
                  //   ),
                  // ),
                  // Container(
                  //   width: screenWidth,
                  //   padding: EdgeInsets.all(8),
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: testimonials.length,
                  //     itemBuilder: (context, index) {
                  //       return Card(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 testimonials[index].author,
                  //                 style: Theme.of(context).textTheme.subtitle1,
                  //               ),
                  //               SizedBox(height: 4),
                  //               Text(
                  //                 testimonials[index].text,
                  //                 style: Theme.of(context).textTheme.bodyText2,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  //contact information
                  Container(
                      width: screenWidth,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اتصل بنا',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(height: 8),
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text('مهاجرين'),
                            subtitle: Text('دمشق، سوريا'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('+963944394064'),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('husjammal@gmail.com'),
                          ),
                        ],
                      )),

                  //social media
                  //   Container(
                  //       width: screenWidth,
                  //       padding: EdgeInsets.all(8),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Follow Us:',
                  //             style: Theme.of(context).textTheme.headline6,
                  //           ),
                  //           SizedBox(height: 8),
                  //           ListTile(
                  //             leading: Icon(Icons.link),
                  //             title: Text('Facebook'),
                  //             onTap: () => launchUrl(
                  //                 Uri.parse('https://www.facebook.com/yourpage')),
                  //           ),
                  //           ListTile(
                  //             leading: Icon(Icons.link),
                  //             title: Text('Twitter'),
                  //             onTap: () => launchUrl(
                  //                 Uri.parse('https://www.twitter.com/yourpage')),
                  //           ),
                  //           ListTile(
                  //             leading: Icon(Icons.link),
                  //             title: Text('Instagram'),
                  //             onTap: () => launchUrl(Uri.parse(
                  //                 'https://www.instagram.com/yourpage')),
                  //           ),
                  //         ],
                  //       )),
                ],
              ),
            )));
  }
}

class Testimonial {
  final String author;
  final String text;

  Testimonial(this.author, this.text);
}
