import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:weather/config/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/controllers/location_controller.dart';
import 'package:weather/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLocationError = false;
  LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather();
    if (weatherData == null || weatherData['error'] != null) {
      setState(() {
        isLocationError = true;
      });
    } else {
      setState(() {
        isLocationError = false;
      });
      locationController.updateWeatherData(weatherData);
      Get.toNamed(RoutesNames.locationScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLocationError == true
            ? ElevatedButton(
                onPressed: () {
                  getLocationData();
                },
                child: const Text('Request Permission'),
              )
            : const SpinKitDoubleBounce(
                color: Colors.white,
                size: 100.0,
              ),
      ),
    );
  }
}
