import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CurrentLocationProvider with ChangeNotifier {
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  LatLng? center;

  Future<void> checkServiceEnabledLocation() async {
    //TODO เช็ค service location ว่า มีสิทธิมัย
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      //TODO ขอใช้งาน service location

      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    print("_serviceEnabled ${_serviceEnabled}");
    print("_permissionGranted ${_permissionGranted}");
    //TODO  getLocation ดึงข้อมลู lat long
    locationData = await location.getLocation();
    center = LatLng(locationData!.latitude!, locationData!.longitude!);
    notifyListeners();
    return;
  }
}
