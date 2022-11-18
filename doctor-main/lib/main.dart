import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toseeadoctor/provider/current_location_provider.dart';
import 'package:toseeadoctor/screen/current_location.dart';
import 'package:toseeadoctor/screen/nearby_search.dart';
import 'package:toseeadoctor/screen/news.dart';

import 'screen/splash_page.dart';

/// Requires that a Firestore emulator is running locally.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage
bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //TODO ประกาศการใช้งาน CurrentLocationProvider()
        ChangeNotifierProvider(create: (_) => CurrentLocationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'toseeadoctor',
        home: SplashPage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //TODO หน้า page default  เท่ากับ 0 เนื่องจากเราเลือกผ่าน List page
  int _page = 0;

  List page = [
    ///ข่าวสาร
    FirestoreExampleApp(),

    ///ตำเเหน่งปัจจุบัน
    CurrentLocationPage(),

    ///โรงพยาบาลใกล้ฉัน
    NearBySearchPage()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO สร้าง NavigationBar 1.ข่าวสาร | 2.ตำเเหน่งปัจจุบัน | 3. โรงพยาบาลใกล้ฉัน
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        height: 55,
        color: Color(0xff7CDDC4),
        buttonBackgroundColor: Color(0xff7CDDC4),
        items: <Widget>[
          Image.asset('assets/images/website.png', height: 50),
          Image.asset('assets/images/location.png', height: 50),
          Image.asset('assets/images/hospital.png', height: 50),
        ],
        onTap: (index) {
          //TODO คำสั่งเปลี่ยนหน้าตามเลข index
          setState(() {
            _page = index;
          });
        },
      ),
      body: Container(
        child: Center(child: page[_page]),
      ),
    );
  }
}
