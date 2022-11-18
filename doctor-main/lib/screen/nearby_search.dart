import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toseeadoctor/api/api%20_services.dart';
import 'package:toseeadoctor/provider/current_location_provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class NearBySearchPage extends StatefulWidget {
  const NearBySearchPage({Key? key}) : super(key: key);

  @override
  State<NearBySearchPage> createState() => _NearBySearchPageState();
}

class _NearBySearchPageState extends State<NearBySearchPage> {
  Future<List<dynamic>?>? data;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final current =
        Provider.of<CurrentLocationProvider>(context, listen: false);
    //TODO เรียกค่า location ใหม่เสมอ
    current.checkServiceEnabledLocation().then((value) => data = first());
  }

  Future<List<dynamic>?> first() async {
    //TODO call Provider
    final current =
        Provider.of<CurrentLocationProvider>(context, listen: false);
    //TODO เช็คว่ามีค่า location อยู่จรืง
    if (current.locationData!.latitude != null &&
        current.locationData!.longitude != null) {
      //TODO ส่ง lat long ค้นหาโรงพยาบาลใกล้ตัว
      return await ApiService.getNearBySearch(
          current.locationData!.latitude!, current.locationData!.longitude!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLocationProvider>(
      builder: (_, current, child) => Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            'โรงพยาบาลใกล้ฉัน',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff7CDDC4),
        ),
        body: current.locationData == null
            ? Container()
            : FutureBuilder(
                //TODO เรียกใช้งาน function first()
                future: data,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 5.0,
                        color: Colors.teal,
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) =>
                              card(snapshot.data![index]));
                    }
                  }
                  return Container();
                },
              ),
      ),
    );
  }

  //TODO การ์ดเเสดงโรงพยาบาลใกล้ๆ
  Widget card(dynamic data) {
    // formatted_phone_number: 039 389 454, name: Makham Hospital, url: https://maps.google.com/?cid=13102293360142535272, website: http://makhamhospital.com/}
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xff7CDDC4),
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff7CDDC4),
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  // Icon(Icons.store, color: Colors.white, size: 30),
                  Image.asset('assets/images/hospital.png', height: 50),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      '${data['name']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.teal.shade50,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                      color: data['formatted_phone_number'] != null
                          ? Color(0xff7CDDC4)
                          : Color(0xff7CDDC4).withOpacity(0.5),
                      onPressed: () {
                        if (data['formatted_phone_number'] != null) {
                          _makePhoneCall('${data['formatted_phone_number']}');
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/images/call.png', height: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              // '${data['formatted_phone_number'] != null ? data['formatted_phone_number'] : 'ไม่พบข้อมูล'}',
                              'เบอร์โทร(phone number)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: data['formatted_phone_number'] != null
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  RaisedButton(
                      color: data['url'] != null
                          ? Color(0xff7CDDC4)
                          : Color(0xff7CDDC4).withOpacity(0.5),
                      onPressed: () {
                        if (data['url'] != null) {
                          _launchInBrowser(Uri.parse('${data['url']}'));
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/images/map.png', height: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              // '${data['url'] != null ? data['url'] : 'ไม่พบข้อมูล'}',
                              'ที่ตั้งโรงพยาบาล(hospital location)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: data['url'] != null
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  RaisedButton(
                      color: data['website'] != null
                          ? Color(0xff7CDDC4)
                          : Color(0xff7CDDC4).withOpacity(0.5),
                      onPressed: () {
                        if (data['website'] != null) {
                          _launchInBrowser(Uri.parse('${data['website']}'));
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/images/url.png', height: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              // '${data['website'] != null ? data['website'] : 'ไม่พบข้อมูล'}',
                              'เว็บไซต์โรงพยาบาล(hospital website)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: data['website'] != null
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //   Card(
    //   child: Row(
    //     children: [
    //       Column(
    //         children: [
    //           Text('${data['name']}'),
    //           Text('${data['formatted_phone_number']}'),
    //           Text('${data['url']}'),
    //           Text('${data['website']}'),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
