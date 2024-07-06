import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather.dart';

class LocationController extends GetxController {
  final WeatherModel _weatherModel = WeatherModel();
  Rx<int> temperature = 0.obs;
  Rx<String> cityName = "".obs;
  Rx<String> weatherIcon = "Error".obs;
  Rx<String> weatherMessage = "Unable to get weather data".obs;
  Rx<bool> isLoading = false.obs;
  SharedPreferences? prefs;

  @override
  void onInit() {
    super.onInit();
    loadSavedCity();
  }
  void updateWeatherData(dynamic weatherData) {
    if (weatherData != null) {
      double temp = weatherData["main"]["temp"];
      temperature.value = temp.toInt();
      var condition = weatherData["weather"][0]["id"];
      weatherIcon.value = _weatherModel.getWeatherIcon(condition);
      weatherMessage.value = _weatherModel.getMessage(temperature.value);
      cityName.value = weatherData["name"];
    } else {
      cityName.value = "";
      temperature.value = 0;
      weatherIcon.value = "Error";
      weatherMessage.value = "Unable to get weather data";
    }

  }

  void saveCity(String city) async {
    prefs ??= await SharedPreferences.getInstance();
    prefs!.setString('lastCity', city);
  }

  void loadSavedCity() async {
    prefs ??= await SharedPreferences.getInstance();
    String? lastCity = prefs!.getString('lastCity');
    if (lastCity != null && lastCity.isNotEmpty) {
      cityName.value = lastCity;
      fetchCityWeatherData(lastCity); // Fetch weather data for the saved city
    }
  }

  Future<void> fetchWeatherData() async {
    isLoading.value = true;
    var weatherData = await _weatherModel.getLocationWeather();
    if (weatherData == null || weatherData['error'] != null) {
      weatherMessage.value = 'Unable to get weather data for $cityName';
    } else {
      updateWeatherData(weatherData);
    }
    isLoading.value = false;
  }

  Future<void> fetchCityWeatherData(String cityName) async {
    isLoading.value = true;
    var weatherData = await _weatherModel.getCityWeather(cityName);
    if (weatherData == null || weatherData['error'] != null) {
      weatherMessage.value = 'Unable to get weather data for $cityName';
    }
    else {
      updateWeatherData(weatherData);
    }
    isLoading.value = false;
  }
}
