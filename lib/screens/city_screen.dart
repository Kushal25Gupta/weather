import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:weather/controllers/location_controller.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  late String cityName;
  final WeatherModel _weatherModel = WeatherModel();
  LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city_background.jpg'),
            fit: BoxFit.cover,
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
              return Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 50.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: kTextFieldInputDecoration,
                      onChanged: (value) {
                        cityName = value;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (cityName.isNotEmpty) {
                        await locationController.fetchCityWeatherData(cityName);
                        if (locationController.weatherMessage.value.contains('Unable')) {
                          Get.snackbar(
                            'Error',
                            'Unable to get weather data for $cityName',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else {
                          Get.back();
                        }
                      }
                    },
                    child: const Text(
                      'Get Weather',
                      style: kButtonTextStyle,
                    ),
                  ),
                  if (locationController.cityName.value.isNotEmpty)
                    Text(
                      'Last Searched City: ${locationController.cityName.value}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
