import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mymosque/constant/colorConfig.dart';
import 'package:mymosque/constant/linkapi.dart';
import 'dart:convert';

import 'package:mymosque/model/azkarModel.dart';

class AzkarPage extends StatefulWidget {
  @override
  _AzkarPageState createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  List imgList = [
    'assets/images/AzkarSabah.png',
    'assets/images/AzkarMasaa.png',
    'assets/images/AzkarPray.png'
  ];

  int _index = 0;
  String _url = "";

  void initState() {
    // TODO: implement initState
    super.initState();
    print('azkar initState');

    _url = linkAzkarSabahJSON;
  }

  Future<List<AzkarModel>> _fetchAzkar(List az) async {
    return az.map((azkar) => AzkarModel.fromJson(azkar)).toList();
  }

  Future<List<AzkarModel>> _fetchAzkar2(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // decode the JSON response with the correct encoding
      String jsonStr = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(jsonStr) as List<dynamic>;

      // map the JSON data to a list of AzkarModel objects
      return jsonData.map((json) => AzkarModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load azkar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: backgroundColor,
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: CarouselSlider.builder(
                    itemCount: imgList.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          print("Tapped  " + imgList[index]);
                          if (index == 0) {
                            _url = linkAzkarSabahJSON;
                          } else if (index == 1) {
                            _url = linkAzkarMasaaJSON;
                          } else {
                            _url = linkAzkarPrayJSON;
                          }
                          _index = index;
                          setState(() {});
                        },
                        child: Container(
                          //height: 5,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage(
                                imgList[index].toString(),
                              ),
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 120.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 15.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: backgroundColor,
                    ),
                    child: Text(
                      (_index == 0)
                          ? "أذكار الصباح والمساء"
                          : (_index == 1)
                              ? "أذكار النوم"
                              : "الأذكار بعد السلام من الصلاة",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: FutureBuilder<List<AzkarModel>>(
                    future: _fetchAzkar2(_url),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<AzkarModel> azkarList = snapshot.data!;
                        return ListView.builder(
                            itemBuilder: (context, index) => Card(
                                  color: buttonColor2,
                                  child: ListTile(
                                    leading: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/Duaa_logo1.png',
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                    title: Text(azkarList[index].text!),
                                    subtitle:
                                        Text(azkarList[index].count.toString()),
                                    trailing: Icon(Icons.more_vert),
                                    isThreeLine: true,
                                  ),
                                ),
                            itemCount: azkarList.length);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
                    },
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
