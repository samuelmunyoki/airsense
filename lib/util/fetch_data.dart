import 'dart:convert';

import 'package:airsense/constants/endpoints.dart';
import 'package:airsense/data/models.dart';
import 'package:http/http.dart' as http;

// Create a map of index and date
Map<int, DateTime> dateChangeIndices = {};
String dateTo = "2024-05-14 23:59:59";
String dateFrom = "2024-05-7 00:00:00";

// Make the HTTP Request
Future<List<DeviceData>> fetchData() async {
  
  //JSON data to be send to server
  var postjsonData = [
    {
      "dev_id": "00000000000000bb",
      "dateFrom": dateFrom,
      "dateTo": dateTo,
    }
  ];

  // Encode your JSON data (RAW)
  String postjsonDataString = jsonEncode(postjsonData);

  // Construction the ENDPOINT URL
  String url = Uri.https(BaseUrl, FetchDeviceDataByIdPath).toString();

  try {
    // Fetching data through POST
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: postjsonDataString,
    );

    if (response.statusCode == 200) {
      // then parse the JSON into a list of DeviceData objects.
      List<dynamic> data = jsonDecode(response.body);
      List<DeviceData> _deviceDataList =
          data.map((item) => DeviceData.fromJson(item)).toList();

      DateTime? previousDate;
      for (int i = 0; i < _deviceDataList.length; i++) {
        DateTime currentDate = DateTime.parse(_deviceDataList[i]
            .datetime); // Convert datetime string to DateTime object
        DateTime currentDateWithoutTime = DateTime(currentDate.year,
            currentDate.month, currentDate.day); // Extract date part
        if (previousDate != null && currentDateWithoutTime != previousDate) {
          dateChangeIndices[i] = currentDateWithoutTime;
        }
        previousDate = currentDateWithoutTime;
      }
      // print(dateChangeIndices);

      return _deviceDataList;
    } else {
      // if other than 200 OK throw an exception.
      throw Exception('Failed to unmarshal JSON data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
}
