import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toseeadoctor/provider/current_location_provider.dart';

class CurrentLocationPage extends StatefulWidget {
  const CurrentLocationPage({Key? key}) : super(key: key);

  @override
  State<CurrentLocationPage> createState() => _CurrentLocationPageState();
}

class _CurrentLocationPageState extends State<CurrentLocationPage> {
  // CurrentLocationProvider? current;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    //TODO เรียก การใช้งาน location
    final current =
        Provider.of<CurrentLocationProvider>(context, listen: false);
    current.checkServiceEnabledLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLocationProvider>(
      builder: (_, current, child) => Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Text(
            'ตำแหน่งปัจจุบัน',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff7CDDC4),
        ),
        body:
            //TODO เช็คว่ามีค่า lat long เเล้ว ถ้ามีให้เเสดง map
            current.center == null
                ? Container()
                : GoogleMap(
                    mapType: MapType.satellite,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: current.center!,
                      zoom: 17.0,
                    ),
                    markers: MyMarker(current),
                  ),
      ),
    );
  }

  //TODO เเสดง map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.showMarkerInfoWindow(MarkerId('device'));
  }

  //TODO เเสดงจุด mark ปัจจุบัน
  Set<Marker> MyMarker(CurrentLocationProvider current) {
    return <Marker>[
      Marker(
        markerId: MarkerId('device'),
        position: current.center!,
      ),
    ].toSet();
  }
}
