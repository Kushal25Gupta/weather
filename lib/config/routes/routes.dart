import 'package:get/get.dart';
import 'package:weather/config/routes/routes_names.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/screens/loading_screen.dart';
import 'package:weather/screens/location_screen.dart';

class Routes {
  static appRoutes() => [
        GetPage(
          name: RoutesNames.loadingScreen,
          page: () => LoadingScreen(),
        ),
        GetPage(
          name: RoutesNames.locationScreen,
          page: () => LocationScreen(),
        ),
        GetPage(
          name: RoutesNames.cityScreen,
          page: () => CityScreen(),
        ),
      ];
}
