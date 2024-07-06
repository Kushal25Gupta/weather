import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

const apikey = '0499090184a6410515552d6a21d603fb';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var url = "$openWeatherMapURL?q=$cityName&appid=$apikey&units=metric";
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    if (weatherData == null || weatherData['error'] != null) {
      return {'error': 'City not found or API error'};
    }
    if (weatherData['cod'] != 200) {
      return {'error': weatherData['message'] ?? 'Unknown error'};
    }
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    final isLocationError = await location.getCurrentLocation();
    if (isLocationError) {
      return {'error': 'Unable to fetch location'};
    }

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apikey&units=metric'
    );
    var weatherData = await networkHelper.getData();
    if (weatherData == null || weatherData['error'] != null) {
      return {'error': 'City not found or API error'};
    }
    if (weatherData['cod'] != 200) {
      return {'error': weatherData['message'] ?? 'Unknown error'};
    }
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
