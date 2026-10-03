abstract class WeatherRemoteDataSource {
  Future<Map<String, dynamic>> getLocation(String city);

  Future<Map<String, dynamic>> getWeather(double latitude, double longtitude);
}
