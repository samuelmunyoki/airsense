// ignore_for_file: non_constant_identifier_names

class DeviceData {
  final int id;
  final String dev_id;
  final int temp;
  final int humidity;
  final int co2;
  final double batt;
  final String datetime;

  const DeviceData({
    required this.id,
    required this.dev_id,
    required this.temp,
    required this.datetime,
    required this.co2,
    required this.batt,
    required this.humidity,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      id: json['id'],
      dev_id: json['dev_id'],
      temp: json['temp'],
      datetime: json['datetime'],
      co2: json['co2'],
      batt: json['batt'],
      humidity: json['humidity'],
    );
  }
}
