import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static var client = http.Client();
  static Future<List<dynamic>?> getNearBySearch(
    double lat,
    double long,
  ) async {
    try {
      List dataList = [];
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=utf-8',
      };
      //TODO ใช้ lat long เพื่อค้นหาโรงพยาบาลใกล้เคียง
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${long}&rankby=distance&type=hospital&keyword=โรงพยาบาล,hospital&key=AIzaSyBidiViddOIvNap__6DuxbK-wkBaXqOE54');
      var response = await client.get(
        url,
        headers: requestHeaders,
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result != null) {
          for (var i = 0; i < result['results'].length; i++) {
            print(result['results']);
            // if (i < 3) {
            final data = await getPlaceDetail(result['results'][i]['place_id']);
            dataList.add(data!['result']);
            // }
          }
        }
        print(dataList);
        return dataList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getPlaceDetail(String placeId) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json; charset=utf-8',
      };
      //TODO ดึง detail ของโรงพยาบาล
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?fields=name,formatted_phone_number,url,website&place_id=${placeId}&key=AIzaSyBidiViddOIvNap__6DuxbK-wkBaXqOE54');
      var response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
