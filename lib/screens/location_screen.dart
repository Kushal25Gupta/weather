import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/config/routes/routes_names.dart';
import 'package:weather/controllers/location_controller.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
  }

  void refreshWeather() async {
    await locationController.fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Obx(() {
            if (locationController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final int temperature = locationController.temperature.value;
              final String weatherIcon = locationController.weatherIcon.value;
              final String weatherMessage = locationController.weatherMessage.value;
              final String cityName = locationController.cityName.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: refreshWeather,
                        child: const Icon(
                          Icons.near_me,
                          size: 50.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RoutesNames.cityScreen);
                        },
                        child: const Icon(
                          Icons.location_city,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '$temperature°',
                          style: kTempTextStyle,
                        ),
                        Text(
                          weatherIcon,
                          style: kConditionTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      "$weatherMessage in $cityName!",
                      textAlign: TextAlign.right,
                      style: kMessageTextStyle,
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
