// ignore_for_file: prefer_const_constructors

import 'package:airsense/data/models.dart';
import 'package:airsense/util/fetch_data.dart';
import 'package:airsense/widgets/graphs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Airsense - Test',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          appBar: AppBar(
            title: Column(
              children:  [
                Text(
                  "TEMPERATURE GRAPH",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "$dateFrom to $dateTo",
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
          ),
          body: const Home(),
        ));
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DeviceData>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 0, 0, 0)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DeviceData>? data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return Center(
              child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 50.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black)),
                  child: AspectRatio(
                      aspectRatio: 1.6,
                      child: LineChartGraph(
                        deviceDataList: data,
                      ))));
        }
      },
    );
  }
}
